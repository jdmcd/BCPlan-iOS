//
//  UIViewController+Alert.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showError(errorResponse: ErrorResponse?) {
        let errorBody = errorResponse?.reason ?? "Something went wrong. Please try again."
        showError(string: errorBody)
    }
    
    func showError() {
        showError(errorResponse: nil)
    }
    
    func showError(string: String) {
        let alert = UIAlertController(title: "Error", message: string, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        
        present(alert, animated: true)
    }
}
