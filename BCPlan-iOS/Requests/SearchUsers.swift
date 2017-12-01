//
//  SearchUsers.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/30/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

struct SearchUsers: APIRequestRepresentable {
    typealias CodableType = [User]
    var method: Alamofire.HTTPMethod = .get
    var endpoint: API.Endpoint
    var isAuthedRequest = true
    
    init(projectId: Int, query: String) {
        guard let encodedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { fatalError() }
        self.endpoint = .searchUser(projectId: projectId, query: encodedString)
    }
}
