//
//  RegisterViewController.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit
import PKHUD

class RegisterViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    //MARK: - Actions
    @IBAction private func registerButtonTapped(_ sender: UIButton) {
        register()
    }
    
    //MARK: - Methods
    private func register() {
        guard let name = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextField.text else { return }
        
        guard password == confirmPassword else { showError(string: "Password's don't match"); return }
        
        HUD.show(.progress)
        let registerRequest = Register(name: name, email: email, password: password)
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
        
        RegisterRequest().request(parameters: registerRequest, success: successHandler, error: errorHandler)
    }
}

//MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            confirmPasswordTextField.resignFirstResponder()
            register()
        }
        
        return true
    }
}
