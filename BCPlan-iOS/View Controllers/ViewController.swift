//
//  ViewController.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        let loginRequest = Login(email: "email2@email.com", password: "password")
        let successHandler: ((User?) -> Void) = { [unowned self] user in
            guard let user = user else { self.showError(); return }
            User.login(user: user)
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { [unowned self] error in
            self.showError(errorResponse: error)
        }
        
        LoginRequest.request(parameters: loginRequest, success: successHandler, error: errorHandler)
    }
}
