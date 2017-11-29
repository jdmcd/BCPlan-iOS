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
    
    var project: Project!
    private var detailedProject: DetailedProject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = project.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        HUD.show(.progress)
        let successHandler: ((DetailedProject?) -> Void) = { detailedProject in
            HUD.hide()
            self.detailedProject = detailedProject
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        let projectRequest = GetProject(endpoint: .project(projectId: project.id))
        projectRequest.request(user: User.currentUser(), success: successHandler, error: errorHandler)
    }
}
