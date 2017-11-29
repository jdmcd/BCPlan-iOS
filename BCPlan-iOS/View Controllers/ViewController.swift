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
        let registerRequest = Register(name: "New Name", email: "email2@email.com", password: "password")
        RegisterRequest.request(parameters: registerRequest) { user, error in
            print(user)
            print(error)
        }
        
//        let loginRequest = Login(email: "email@email.com", password: "password")
//        LoginRequest.request(parameters: loginRequest) { (user, error) in
//            print(user)
//            print(error)
//        }
    }
}
