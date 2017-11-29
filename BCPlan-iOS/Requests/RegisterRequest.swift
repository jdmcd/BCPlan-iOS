//
//  RegisterRequest.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

struct RegisterRequest: APIRequestRepresentable {
    typealias CodableType = User
    static var method: Alamofire.HTTPMethod = .post
    static var endpoint: API.Endpoint = .register
}
