//
//  TokenHeader.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation

struct TokenHeader: Codable {
    var contentType: String
    var apiKey: String
    var token: String
    
    init(defaultHeader: DefaultHeader, token: String) {
        self.contentType = defaultHeader.contentType
        self.apiKey = defaultHeader.apiKey
        self.token = token
    }
    
    enum CodingKeys: String, CodingKey {
        case contentType = "Content-Type"
        case apiKey = "API-KEY"
        case token = "Authorization"
    }
}
