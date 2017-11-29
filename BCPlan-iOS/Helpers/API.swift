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
    static let apiKey = ""
    static let baseUrl = "https://bcplan.herokuapp.com/api/v1/"
    
    enum Endpoint {
        case login
        case register
        case projects
        case createProject
        case project(projectId: Int)
        
        var endpoint: String {
            switch self {
            case .login:
                return "\(API.baseUrl)/login"
            case .register:
                return "\(API.baseUrl)/register"
            case .projects:
                return "\(API.baseUrl)/projects"
            case .createProject:
                return "\(API.baseUrl)/project"
            case .project(let id):
                return "\(API.baseUrl)/project/\(id)"
            }
        }
    }
    
    static func createUrl(endpoint: Endpoint) -> String {
        return "\(API.baseUrl)\(endpoint.endpoint)"
    }
}
