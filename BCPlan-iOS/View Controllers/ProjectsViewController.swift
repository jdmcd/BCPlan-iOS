//
//  ProjectsViewController.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit
import PKHUD
import ViewAnimator
import DZNEmptyDataSet

class ProjectsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    //MARK: - Properties
    var projectResponse: ProjectResponse?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Empty dataset properties
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        
        //register header nib
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")

        //notification registration for first login.register
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getData),
                                               name: Notification.Name(rawValue: Constants.logInRegister),
                                               object: nil)
        
        if User.loggedIn() {
            getData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !User.loggedIn() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navVc = storyboard.instantiateViewController(withIdentifier: Constants.loginNav)
            present(navVc, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions
    @IBAction private func addButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create Project", message: "You will be the administrator of this project.", preferredStyle: .alert)
        
        var projectNameTextField = UITextField()
        alertController.addTextField { textField in
            projectNameTextField = textField
            textField.placeholder = "Project Name"
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        let okButton = UIAlertAction(title: "Create", style: .default) { action in
            guard let projectName = projectNameTextField.text else { return }
            self.createProject(projectName: projectName)
        }
        
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Methods
    private func createProject(projectName: String) {
        let createProjectParams = CreateProjectObject(name: projectName)
        
        HUD.show(.progress)
        let successHandler: ((Project?) -> Void) = { project in
            HUD.hide()
            
            guard let project = project else { self.showError(); return }
            self.projectResponse?.admin.insert(project, at: 0)
            
            self.tableView.reloadData()
            
            //we are inserting the row at the top, so it should always be at (0,0)
            let indexPath = IndexPath(row: 0, section: 0)
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
            self.animateCell(cell: cell, delay: 0)
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        CreateProject().request(parameters: createProjectParams, user: User.currentUser(), success: successHandler, error: errorHandler)
    }
    
    @objc private func getData() {
        HUD.show(.progress)
        let successHandler: ((ProjectResponse?) -> Void) = { projectResponse in
            HUD.hide()
            self.projectResponse = projectResponse
            self.tableView.reloadData()
            self.animateTable()
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        GetProjects().request(user: User.currentUser(), success: successHandler, error: errorHandler)
    }
    
    private func animateTable() {
        for (index, view) in tableView.visibleCells.enumerated() {
            let delay = Double(index) * 0.05
            animateCell(cell: view, delay: delay)
        }
    }
    
    private func animateCell(cell: UITableViewCell, delay: Double) {
        let animation = AnimationType.from(direction: .left, offset: 30.0)
        if let animatable = cell as? Animatable {
            animatable.animateViews(animations: [animation], delay: delay)
        } else {
            cell.animate(animations: [animation], delay: delay)
        }
    }
    
    enum SectionType: Int {
        case admin
        case accepted
        case pending
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.pushToProjectDetails {
            guard let detailsVC = segue.destination as? ProjectDetailsViewController else { return }
            guard let project = sender as? Project else { return }
            
            detailsVC.project = project
        } else if segue.identifier == Constants.showAcceptedProjects {
            guard let detailsVC = segue.destination as? AcceptedProjectViewController else { return }
            guard let project = sender as? Project else { return }
            
            detailsVC.project = project
        }
    }
    
    private func sectionsToShow() -> [SectionType] {
        var sections = [SectionType]()
        if let projectResponse = projectResponse {
            if !projectResponse.admin.isEmpty {
                sections.append(.admin)
            }
            
            if !projectResponse.accepted.isEmpty {
                sections.append(.accepted)
            }
            
            if !projectResponse.pending.isEmpty {
                sections.append(.pending)
            }
        }
        
        return sections
    }
    
    private func showInviteAlert(project: Project) {
        let alertController = UIAlertController(title: "Invitation", message: "Accept or delete invitation for \(project.name)", preferredStyle: .alert)
        let acceptButton = UIAlertAction(title: "Accept", style: .default) { _ in
            self.accept(project: project)
        }
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.delete(project: project)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(acceptButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func accept(project: Project) {
        HUD.show(.progress)
        let successHandler: ((EmptyResponseType?) -> Void) = { _ in
            HUD.hide()
            self.getData()
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        guard let currentUser = User.currentUser() else { return }
        InvitationRequest(projectId: project.id, requestType: .accept)
            .request(user: currentUser, success: successHandler, error: errorHandler)
    }
    
    private func delete(project: Project) {
        HUD.show(.progress)
        let successHandler: ((EmptyResponseType?) -> Void) = { _ in
            HUD.hide()
            self.getData()
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        guard let currentUser = User.currentUser() else { return }
        InvitationRequest(projectId: project.id, requestType: .delete)
            .request(user: currentUser, success: successHandler, error: errorHandler)
    }
}

//MARK: - UITableViewDataSource
extension ProjectsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = sectionsToShow()
        let currentSection = sections[section]
        
        if currentSection == .admin {
            return projectResponse?.admin.count ?? 0
        } else if currentSection == .accepted {
            return projectResponse?.accepted.count ?? 0
        } else if currentSection == .pending {
            return projectResponse?.pending.count ?? 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.projectsCell, for: indexPath)
        guard let projectResponse = projectResponse else { return cell }
        
        let sections = sectionsToShow()
        let currentSection = sections[indexPath.section]
        
        if currentSection == .admin {
            cell.textLabel?.text = projectResponse.admin[indexPath.row].name
        } else if currentSection == .accepted {
            cell.textLabel?.text = projectResponse.accepted[indexPath.row].name
        } else if currentSection == .pending {
            cell.textLabel?.text = projectResponse.pending[indexPath.row].name
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsToShow().count
    }
}

//MARK: - UITableViewDelegate
extension ProjectsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let projectResponse = projectResponse else { return }
        let sections = sectionsToShow()
        let currentSection = sections[indexPath.section]
        var selectedProject: Project?
        
        if currentSection == .admin {
            selectedProject = projectResponse.admin[indexPath.row]
        } else if currentSection == .accepted {
            selectedProject = projectResponse.accepted[indexPath.row]
        } else if currentSection == .pending {
            showInviteAlert(project: projectResponse.pending[indexPath.row])
        }
        
        if let project = selectedProject {
            if currentSection == .admin {
                performSegue(withIdentifier: Constants.pushToProjectDetails, sender: project)
            } else {
                performSegue(withIdentifier: Constants.showAcceptedProjects, sender: project)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as! TableSectionHeader
        
        let sections = sectionsToShow()
        let currentSection = sections[section]
        
        if currentSection == .admin {
            header.titleLabel.text = "My Projects"
        } else if currentSection == .accepted {
            header.titleLabel.text = "Accepted Projects"
        } else if currentSection == .pending {
            header.titleLabel.text = "Pending Projects"
        }
        
        return header
    }
}

//MARK: - DZNEmptyDataSetSource
extension ProjectsViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No projects yet. Try creating your own!"
        return NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.darkGray])
    }
}
