//
//  ProjectDetailsViewController.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit
import PKHUD

class ProjectDetailsViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var project: Project!
    private var detailedProject: DetailedProject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CircleCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.circleCollectionId)
        
        title = project.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        HUD.show(.progress)
        let successHandler: ((DetailedProject?) -> Void) = { detailedProject in
            HUD.hide()
            self.detailedProject = detailedProject
            self.collectionView.reloadData()
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        let projectRequest = GetProject(endpoint: .project(projectId: project.id))
        projectRequest.request(user: User.currentUser(), success: successHandler, error: errorHandler)
    }
}

extension ProjectDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailedProject?.members.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.circleCollectionId, for: indexPath) as! CircleCollectionViewCell

        guard let detailedProject = detailedProject else { return cell }
        cell.configure(member: detailedProject.members[indexPath.row])
        
        return cell
    }
}
