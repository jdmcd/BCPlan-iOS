//
//  GetProjectsRequest.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

struct GetProjects: APIRequestRepresentable {
    typealias CodableType = ProjectResponse
    static var method: Alamofire.HTTPMethod = .get
    static var endpoint: API.Endpoint = .projects
    static var isAuthedRequest = false
}

