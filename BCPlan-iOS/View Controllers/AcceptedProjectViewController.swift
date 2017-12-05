//
//  AcceptedProjectViewController.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 12/5/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import PKHUD

class AcceptedProjectViewController: UIViewController {

    @IBOutlet private weak var suggestedTimesCollectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var attendingMembersLabel: UILabel!
    @IBOutlet private weak var attendingButton: UIButton!
    
    var project: Project!
    private var detailedProject: DetailedProject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendingMembersLabel.isHidden = true
        tableView.isHidden = true
        tableView.tableFooterView = UIView()
        attendingButton.isHidden = true
        
        let suggestedNib = UINib(nibName: "SuggestedTimeCollectionViewCell", bundle: nil)
        suggestedTimesCollectionView.register(suggestedNib, forCellWithReuseIdentifier: Constants.suggestedTime)
        suggestedTimesCollectionView.emptyDataSetSource = self
        
        title = project.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }
    
    private func checkForRequestingAttendanceResponse() {
        guard let detailedProject = detailedProject else { return }
        if detailedProject.hasSelectedDate() {
            attendingButton.isHidden = false
            
            if detailedProject.attending {
                attendingButton.setTitle("Mark as not attending", for: .normal)
            } else {
                attendingButton.setTitle("Mark as attending", for: .normal)
            }
        }
    }
    
    private func reloadAttendingMembers() {
        guard let detailedProject = detailedProject else { return }
        if detailedProject.attendingUsers.count == 0 {
            attendingMembersLabel.isHidden = true
            tableView.isHidden = true
        } else {
            attendingMembersLabel.isHidden = false
            tableView.isHidden = false
        }

        tableView.reloadData()
    }
    
    @IBAction private func attendanceButtonTapped(_ sender: UIButton) {
        guard let detailedProject = detailedProject else { return }
        
        HUD.show(.progress)
        let successHandler: ((EmptyResponseType?) -> Void) = { _ in
            HUD.hide()
            self.getData()
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        if detailedProject.attending {
            let attendance = SetAttendance(projectId: project.id, attendance: .notAttending)
            attendance.request(user: User.currentUser(), success: successHandler, error: errorHandler)
        } else {
            let attendance = SetAttendance(projectId: project.id, attendance: .attending)
            attendance.request(user: User.currentUser(), success: successHandler, error: errorHandler)
        }
    }
    
    private func getData() {
        HUD.show(.progress)
        let successHandler: ((DetailedProject?) -> Void) = { detailedProject in
            HUD.hide()
            self.detailedProject = detailedProject
            self.suggestedTimesCollectionView.reloadData()
            self.checkForRequestingAttendanceResponse()
            self.reloadAttendingMembers()
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        let projectRequest = GetProject(endpoint: .project(projectId: project.id))
        projectRequest.request(user: User.currentUser(), success: successHandler, error: errorHandler)
    }
    
    private func vote(meetingDate: DetailedProject.MeetingDate) {
        let alertController = UIAlertController(title: "Select", message: "Do you want to vote for this time?", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Yes", style: .default) { action in
            
            HUD.show(.progress)
            let successHandler: ((EmptyResponseType?) -> Void) = { _ in
                HUD.hide()
                self.getData()
            }
            
            let errorHandler: ((ErrorResponse?) -> Void) = { error in
                HUD.hide()
                self.showError(errorResponse: error)
            }
            
            let vote = Vote(meetingDateId: meetingDate.id)
            vote.request(user: User.currentUser(), success: successHandler, error: errorHandler)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(yesButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
}


extension AcceptedProjectViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailedProject?.dates.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.suggestedTime, for: indexPath) as! SuggestedTimeCollectionViewCell
        
        guard let detailedProject = detailedProject else { return cell }
        let date = detailedProject.dates[indexPath.row]
        
        if let votedFor = detailedProject.votedFor, votedFor == date.id, !detailedProject.hasSelectedDate() {
            cell.configureForVote(date: date)
        } else {
            cell.configure(date: date)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailedProject = detailedProject else { return }
        
        if !detailedProject.hasSelectedDate() {
            vote(meetingDate: detailedProject.dates[indexPath.row])
        }
    }
}

extension AcceptedProjectViewController: UITableViewDataSource {
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

extension AcceptedProjectViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No times added yet"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        return NSAttributedString(string: text, attributes: [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
            NSAttributedStringKey.paragraphStyle: paragraphStyle
            ])
    }
}
