//
//  CreateProject.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

struct CreateProject: APIRequestRepresentable {
    typealias CodableType = Project
    var method: Alamofire.HTTPMethod = .post
    var endpoint: API.Endpoint = .createProject
    var isAuthedRequest = true
}
