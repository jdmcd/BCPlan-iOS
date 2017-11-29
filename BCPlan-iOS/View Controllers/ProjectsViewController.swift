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

class ProjectsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    //MARK: - Properties
    var projectResponse: ProjectResponse?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: Notification.Name(rawValue: Constants.logInRegister), object: nil)
        
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
}

//MARK: - UITableViewDataSource
extension ProjectsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.admin.rawValue {
            return projectResponse?.admin.count ?? 0
        } else if section == SectionType.accepted.rawValue {
            return projectResponse?.accepted.count ?? 0
        } else {
            return projectResponse?.pending.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.projectsCell, for: indexPath)
        
        cell.textLabel?.text = projectResponse?.threeDimensionalArray()[indexPath.section][indexPath.row].name
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SectionType.admin.rawValue {
            return "Projects I Own"
        } else if section == SectionType.accepted.rawValue {
            return "Projects I've Accepted"
        } else {
            return "Pending Projects"
        }
    }
}

//MARK: - UITableViewDelegate
extension ProjectsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let project = projectResponse?.threeDimensionalArray()[indexPath.section][indexPath.row]
        performSegue(withIdentifier: Constants.pushToProjectDetails, sender: project)
    }
}
