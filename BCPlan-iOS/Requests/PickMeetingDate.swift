//
//  PickMeetingDate.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 12/5/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

struct PickMeetingDate: APIRequestRepresentable {
    typealias CodableType = EmptyResponseType
    var method: Alamofire.HTTPMethod = .patch
    var endpoint: API.Endpoint
    var isAuthedRequest = true
    
    init(projectId: Int, meetingDateId: Int) {
        endpoint = .pickMeetingDate(projectId: projectId, meetingDateId: meetingDateId)
    }
}

