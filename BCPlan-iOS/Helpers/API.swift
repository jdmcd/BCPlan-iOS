//
//  API.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

class API {
    static let apiKey = "test"
//    static let baseUrl = "https://bcplan.herokuapp.com/api/v1/"
    static let baseUrl = "http://0.0.0.0:8080/api/v1/"
    
    enum Endpoint {
        case login
        case register
        case projects
        case createProject
        case project(projectId: Int)
        case searchUser(projectId: Int, query: String)
        case inviteUser(projectId: Int, userId: Int)
        
        var endpoint: String {
            switch self {
            case .login:
                return "login"
            case .register:
                return "register"
            case .projects:
                return "projects"
            case .createProject:
                return "project"
            case .project(let id):
                return "project/\(id)"
            case .searchUser(let id, let query):
                return "project/\(id)/user?query=\(query)"
            case .inviteUser(let projectId, let userId):
                return "project/\(projectId)/invite/\(userId)"
            }
        }
    }
    
    static func createUrl(endpoint: Endpoint) -> String {
        return "\(API.baseUrl)\(endpoint.endpoint)"
    }
}
