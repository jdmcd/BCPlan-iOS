//
//  HeadersWithoutToken.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation

struct DefaultHeader: Codable {
    var contentType: String
    var apiKey: String
    
    init(contentType: String, apiKey: String) {
        self.contentType = contentType
        self.apiKey = apiKey
    }
    
    enum CodingKeys: String, CodingKey {
        case contentType = "Content-Type"
        case apiKey = "API-KEY"
    }
}
