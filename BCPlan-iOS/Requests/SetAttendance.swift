//
//  SetAttendance.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 12/5/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

struct SetAttendance: APIRequestRepresentable {
    typealias CodableType = EmptyResponseType
    var method: Alamofire.HTTPMethod = .patch
    var endpoint: API.Endpoint
    var isAuthedRequest = true
    
    init(projectId: Int, attendance: Attendance) {
        endpoint = .attendance(projectId: projectId, attendance: attendance)
    }
    
    enum Attendance {
        case attending
        case notAttending
    }
}
