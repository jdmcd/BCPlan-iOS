//
//  RegisterViewController.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction private func registerButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let registerRequest = Register(name: name, email: email, password: password)
        let successHandler: ((User?) -> Void) = { [unowned self] user in
            guard let user = user else { self.showError(); return }
            User.login(user: user)
            print(user)
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { [unowned self] error in
            self.showError(errorResponse: error)
        }
        
        RegisterRequest.request(parameters: registerRequest, success: successHandler, error: errorHandler)
    }
}
