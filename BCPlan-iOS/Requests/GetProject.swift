//
//  GetProject.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

struct GetProject: APIRequestRepresentable {
    typealias CodableType = DetailedProject
    var method: Alamofire.HTTPMethod = .get
    var endpoint: API.Endpoint
    var isAuthedRequest = true
    
    init(endpoint: API.Endpoint) {
        self.endpoint = endpoint
    }
}
