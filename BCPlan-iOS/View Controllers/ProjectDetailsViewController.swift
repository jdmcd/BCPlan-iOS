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
    
    @IBOutlet private weak var projectMemberCollectionView: UICollectionView!
    @IBOutlet private weak var suggestedTimesCollectionView: UICollectionView!
    
    var project: Project!
    private var detailedProject: DetailedProject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        HUD.show(.progress)
        let successHandler: ((DetailedProject?) -> Void) = { detailedProject in
            HUD.hide()
            self.detailedProject = detailedProject
            self.projectMemberCollectionView.reloadData()
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        let projectRequest = GetProject(endpoint: .project(projectId: project.id))
        projectRequest.request(user: User.currentUser(), success: successHandler, error: errorHandler)
    }
    
    private func addButtonTapped() {
        performSegue(withIdentifier: Constants.addUsers, sender: project)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.addUsers {
            guard let destination = segue.destination as? UINavigationController else { return }
            guard let vc = destination.viewControllers.first as? AddUserViewController else { return }
            
            vc.project = project
        }
    }
}

extension ProjectDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == projectMemberCollectionView {
            guard let membersCount = detailedProject?.members.count else { return 0 }
            return membersCount + 1
        } else {
            return 4
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == projectMemberCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.circleCollectionId, for: indexPath) as! CircleCollectionViewCell
            
            if indexPath.row == 0 {
                cell.configurePlus()
            } else {
                guard let detailedProject = detailedProject else { return cell }
                cell.configure(member: detailedProject.members[indexPath.row-1])
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.suggestedTime, for: indexPath) as! SuggestedTimeCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == projectMemberCollectionView && indexPath.row == 0 {
            addButtonTapped()
        }
    }
}

extension ProjectDetailsViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No members added yet"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        return NSAttributedString(string: text, attributes: [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
            NSAttributedStringKey.paragraphStyle: paragraphStyle
            ])
    }
}
