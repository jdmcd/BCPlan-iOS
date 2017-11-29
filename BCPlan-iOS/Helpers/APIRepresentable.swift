//
//  APIRepresentable.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRepresentable {
    var method: Alamofire.HTTPMethod { get set }
    var endpoint: API.Endpoint { get set }
    func request()
    func defaultHeaderObject() -> DefaultHeader
    func defaultHeader() -> [String: String]?
    func tokenHeader(token: String) -> [String: String]?
    func url() -> String
}

extension APIRepresentable {
    func defaultHeaderObject() -> DefaultHeader {
        return DefaultHeader(contentType: "application/json; charset=utf-8", apiKey: API.apiKey)
    }
    
    func defaultHeader() -> [String: String]? {
        return defaultHeaderObject().asStringValueDictionary()
    }
    
    func tokenHeader(token: String) -> [String: String]? {
        return TokenHeader(defaultHeader: defaultHeaderObject(), token: "Bearer \(token)").asStringValueDictionary()
    }
    
    func url() -> String {
        return API.createUrl(endpoint: endpoint)
    }
}
