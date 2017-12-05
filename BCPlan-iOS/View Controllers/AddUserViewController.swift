//
//  AddUserViewController.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/30/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit
import PKHUD

class AddUserViewController: UIViewController {

    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    var project: Project!
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search for a user by name or email"
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func searchUsers() {
        guard let query = searchBar.text else { return }
        
        let successHandler: (([User]?) -> Void) = { users in
            guard let users = users else { return }
            self.users = users
            self.tableView.reloadData()
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            self.showError(errorResponse: error)
        }
        
        SearchUsers(projectId: project.id, query: query).request(user: User.currentUser(), success: successHandler, error: errorHandler)
    }
}

extension AddUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.userCell, for: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].name
        cell.detailTextLabel?.text = users[indexPath.row].email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}

extension AddUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedUser = users[indexPath.row]
        let successHandler: ((EmptyResponseType?) -> Void) = { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            self.showError(errorResponse: error)
        }
        
        
        InviteUser(projectId: project.id,
                   userId: selectedUser.id).request(user: User.currentUser(),
                                                    success: successHandler,
                                                    error: errorHandler)
    }
}

extension AddUserViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(searchUsers),
                                               object: nil)
        perform(#selector(searchUsers), with: self, afterDelay: 1)
    }
}
