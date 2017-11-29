//
//  ViewController.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit
import PKHUD

class LoginViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //MARK: - Actions
    @IBAction private func loginButtonTapped(_ sender: Any) {
        login()
    }
    
    //MARK: - Methods
    private func login() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        HUD.show(.progress)
        let loginRequest = Login(email: email, password: password)
        let successHandler: ((User?) -> Void) = { user in
            HUD.hide()
            
            guard let user = user else { self.showError(); return }
            User.login(user: user)
            
            //post the notification
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.logInRegister), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
        
        let errorHandler: ((ErrorResponse?) -> Void) = { error in
            HUD.hide()
            
            self.showError(errorResponse: error)
        }
        
        LoginRequest().request(parameters: loginRequest, success: successHandler, error: errorHandler)
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            login()
        }
        
        return true
    }
}
