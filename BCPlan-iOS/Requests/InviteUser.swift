//
//  InviteUser.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/30/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

class InviteUser: APIRequestRepresentable {
    typealias CodableType = EmptyResponseType
    var method: Alamofire.HTTPMethod = .post
    var endpoint: API.Endpoint
    var isAuthedRequest = true
    
    init(projectId: Int, userId: Int) {
        self.endpoint = .inviteUser(projectId: projectId, userId: userId)
    }
}
