//
//  APIRepresentable.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRequestRepresentable {
    associatedtype CodableType: Codable
    
    static var method: Alamofire.HTTPMethod { get set }
    static var endpoint: API.Endpoint { get set }
    static func request(parameters: Codable?, completion: @escaping (_ object: CodableType?, _ error: Error?) -> Void)
    static func defaultHeaderObject() -> DefaultHeader
    static func defaultHeader() -> HTTPHeaders
    static func tokenHeader(token: String) -> HTTPHeaders
    static func url() -> String
}

extension APIRequestRepresentable {
    static func defaultHeaderObject() -> DefaultHeader {
        return DefaultHeader(contentType: "application/json; charset=utf-8", apiKey: API.apiKey)
    }
    
    static func defaultHeader() -> HTTPHeaders {
        return defaultHeaderObject().asStringValueDictionary()
    }
    
    static func tokenHeader(token: String) -> HTTPHeaders {
        return TokenHeader(defaultHeader: defaultHeaderObject(), token: "Bearer \(token)").asStringValueDictionary()
    }
    
    static func url() -> String {
        return API.createUrl(endpoint: endpoint)
    }
}
