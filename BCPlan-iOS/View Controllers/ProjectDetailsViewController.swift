//
//  ProjectDetailsViewController.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit
import PKHUD
import DZNEmptyDataSet

class ProjectDetailsViewController: UIViewController {
    
    @IBOutlet private weak var attendingMembersLabel: UILabel!
    @IBOutlet private weak var projectMemberCollectionView: UICollectionView!
    @IBOutlet private weak var suggestedTimesCollectionView: UICollectionView!
    @IBOutlet private weak var attendingMembersTableView: UITableView!
    
    var project: Project!
    private var detailedProject: DetailedProject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendingMembersLabel.isHidden = true
        attendingMembersTableView.isHidden = true
        attendingMembersTableView.dataSource = self
        attendingMembersTableView.tableFooterView = UIView()
        
        let circleNib = UINib(nibName: "CircleCollectionViewCell", bundle: nil)
        projectMemberCollectionView.register(circleNib, forCellWithReuseIdentifier: Constants.circleCollectionId)
        projectMemberCollectionView.emptyDataSetSource = self
        
        let suggestedNib = UINib(nibName: "SuggestedTimeCollectionViewCell", bundle: nil)
        suggestedTimesCollectionView.register(suggestedNib, forCellWithReuseIdentifier: Constants.suggestedTime)
        suggestedTimesCollectionView.emptyDataSetSource = self
        
        title = project.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }
    
    private func reloadAttendingMembers() {
        attendingMembersLabel.isHidden = false
        attendingMembersTableView.isHidden = false
        attendingMembersTableView.reloadData()
    }
    
    private func getData() {
        HUD.show(.progress)
        let successHandler: ((DetailedProject?) -> Void) = { detailedProject in
            HUD.hide()
            self.detailedProject = detailedProject
            self.projectMemberCollectionView.reloadData()
            self.suggestedTimesCollectionView.reloadData()
            
            if let dP = detailedProject, !dP.attendingUsers.isEmpty {
                self.reloadAttendingMembers()
            }
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        let projectRequest = GetProject(endpoint: .project(projectId: project.id))
        projectRequest.request(user: User.currentUser(), success: successHandler, error: errorHandler)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.addUsers {
            guard let destination = segue.destination as? UINavigationController else { return }
            guard let vc = destination.viewControllers.first as? AddUserViewController else { return }
            
            vc.project = project
        } else if segue.identifier == Constants.addTime {
            guard let destination = segue.destination as? UINavigationController else { return }
            guard let vc = destination.viewControllers.first as? AddTimeViewController else { return }
            
            vc.project = project
        }
    }
    
    private func showSelectController(meetingDate: DetailedProject.MeetingDate) {
        let alertController = UIAlertController(title: "Select", message: "Do you want to mark this time as selected?", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Yes", style: .default) { action in
            self.selectMeetingDate(meetingDate: meetingDate)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(yesButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func selectMeetingDate(meetingDate: DetailedProject.MeetingDate) {
        HUD.show(.progress)
        let successHandler: ((EmptyResponseType?) -> Void) = { _ in
            HUD.hide()
            self.getData()
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        let pickMeetingDate = PickMeetingDate(projectId: project.id, meetingDateId: meetingDate.id)
        pickMeetingDate.request(user: User.currentUser(), success: successHandler, error: errorHandler)
    }
}

extension ProjectDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let detailedProject = detailedProject else { return 0 }
        if collectionView == projectMemberCollectionView {
            if detailedProject.hasSelectedDate() {
                return detailedProject.members.count
            } else {
                return detailedProject.members.count + 1
            }
        } else {
            if detailedProject.hasSelectedDate() {
                return detailedProject.dates.count
            } else {
                return detailedProject.dates.count + 1
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == projectMemberCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.circleCollectionId, for: indexPath) as! CircleCollectionViewCell
            
            guard let detailedProject = detailedProject else { return cell }
            if detailedProject.hasSelectedDate() {
                cell.configure(member: detailedProject.members[indexPath.row])
            } else {
                if indexPath.row == 0 {
                    cell.configurePlus()
                } else {
                    cell.configure(member: detailedProject.members[indexPath.row - 1])
                }
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.suggestedTime, for: indexPath) as! SuggestedTimeCollectionViewCell
            
            guard let detailedProject = detailedProject else { return cell }
            if detailedProject.hasSelectedDate() {
                cell.configure(date: detailedProject.dates[indexPath.row])
            } else {
                if indexPath.row == 0 {
                    cell.configureAdd()
                } else {
                    cell.configure(date: detailedProject.dates[indexPath.row - 1])
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailedProject = detailedProject else { return }
        if collectionView == projectMemberCollectionView && !detailedProject.hasSelectedDate() && indexPath.row == 0 {
            performSegue(withIdentifier: Constants.addUsers, sender: nil)
        } else if collectionView == suggestedTimesCollectionView {
            if !detailedProject.hasSelectedDate() {
                if indexPath.row == 0 {
                    performSegue(withIdentifier: Constants.addTime, sender: nil)
                } else {
                    showSelectController(meetingDate: detailedProject.dates[indexPath.row - 1])
                }
            }
        }
    }
}

extension ProjectDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detailedProject = detailedProject else { return 0 }
        return detailedProject.attendingUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.attendingMember, for: indexPath)
        
        let user = detailedProject?.attendingUsers[indexPath.row]
        cell.textLabel?.text = user?.name
        cell.detailTextLabel?.text = user?.email
        
        return cell
    }
}

extension ProjectDetailsViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var text = ""
        if scrollView == projectMemberCollectionView {
            text = "No members added yet"
        } else if scrollView == suggestedTimesCollectionView {
            text = "No times added yet"
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        return NSAttributedString(string: text, attributes: [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
            NSAttributedStringKey.paragraphStyle: paragraphStyle
            ])
    }
}
