//
//  User.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation

struct User: APIModel, Codable {
    var id: Int
    let name: String
    let email: String
    let admin: Bool
    let token: String
}

extension User {
    private static let userDefaultsKey = "current-user"
    
    static func currentUser() -> User? {
        guard let userData = UserDefaults.standard.data(forKey: userDefaultsKey) else { return nil }
        return User.from(data: userData)
    }
    
    static func loggedIn() -> Bool {
        return currentUser() != nil
    }
    
    static func login(user: User) {
        guard let userData = user.jsonData else { return }
        UserDefaults.standard.set(userData, forKey: userDefaultsKey)
    }
    
    static func clearCurrentUser() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
