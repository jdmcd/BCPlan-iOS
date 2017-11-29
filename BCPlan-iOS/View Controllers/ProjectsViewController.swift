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
    
    //MARK: - Methods
    @objc private func getData() {
        HUD.show(.progress)
        let successHandler: ((ProjectResponse?) -> Void) = { [unowned self] projectResponse in
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
        let animation = AnimationType.from(direction: .left, offset: 30.0)
        for (index, view) in tableView.visibleCells.enumerated() {
            let delay = Double(index) * 0.05
            if let animatable = view as? Animatable {
                animatable.animateViews(animations: [animation], delay: delay)
            } else {
                view.animate(animations: [animation], delay: delay)
            }
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
            selectedProject = projectResponse.pending[indexPath.row]
        }
        
        if let project = selectedProject {
            performSegue(withIdentifier: Constants.pushToProjectDetails, sender: project)
        } else {
            self.showError()
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
