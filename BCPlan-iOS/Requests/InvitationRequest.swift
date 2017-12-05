//
//  InvitationRequest.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 12/3/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

class InvitationRequest: APIRequestRepresentable {
    typealias CodableType = EmptyResponseType
    var method: Alamofire.HTTPMethod = .post
    var endpoint: API.Endpoint
    var isAuthedRequest = true
    
    init(projectId: Int, requestType: RequestType) {
        if requestType == .accept {
            endpoint = .acceptInvitation(projectId: projectId)
        } else {
            endpoint = .denyInvitation(projectId: projectId)
        }
    }
}

extension InvitationRequest {
    enum RequestType {
        case accept
        case delete
    }
}
