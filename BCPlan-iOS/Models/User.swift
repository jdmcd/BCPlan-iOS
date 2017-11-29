//
//  User.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation

struct User: Codable, APIModel {
    var id: Int
    var name: String
    var email: String
    var admin: Bool
    var token: String
}
