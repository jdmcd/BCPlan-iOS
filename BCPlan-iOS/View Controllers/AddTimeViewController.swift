//
//  AddTimeViewController.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 12/5/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit
import PKHUD

class AddTimeViewController: UIViewController {

    @IBOutlet private weak var datePicker: UIDatePicker!
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
    }
    
    @IBAction private func suggestTimeButtonTapped(_ sender: UIButton) {
        HUD.show(.progress)
        let successHandler: ((EmptyResponseType?) -> Void) = { _ in
            HUD.hide()
            self.dismiss(animated: true, completion: nil)
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            self.showError(errorResponse: error)
        }
        
        let params = SuggestTimeRequest(date: datePicker.date)
        SuggestTime(projectId: project.id).request(parameters: params, user: User.currentUser(), success: successHandler, error: errorHandler)
    }

    @IBAction private func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
