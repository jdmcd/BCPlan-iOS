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
    associatedtype CodableType: APIModelCodable
    
    static var method: Alamofire.HTTPMethod { get set }
    static var endpoint: API.Endpoint { get set }
    static func request(parameters: Codable?, completion: @escaping (_ object: CodableType?, _ error: ErrorResponse?) -> Void)
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
    
    static func request(parameters: Codable?, completion: @escaping (_ object: CodableType?, _ error: ErrorResponse?) -> Void) {
        AlamoHelper.manager.request(
            url(),
            method: method,
            parameters: parameters?.asDictionary(),
            encoding: JSONEncoding.default,
            headers: defaultHeader()).responseJSON { response in
                //each response should have a status code and a json value
                guard let statusCode = response.response?.statusCode else {
                    completion(nil, ErrorResponse(reason: "Could not get status code"))
                    return
                }
                
                guard let jsonValue = response.result.value else {
                    completion(nil, ErrorResponse(reason: "Could not get JSON value"))
                    return
                }
                
                guard let data = try? JSONSerialization.data(withJSONObject: jsonValue) else {
                    completion(nil, ErrorResponse(reason: "Could not parse data"))
                    return
                }
                
                if 200...299 ~= statusCode {
                    //success
                    completion(CodableType.from(data: data), nil)
                } else {
                    //error - we need a JSONDecoder here because `ErrorResponse` does not conform to APIModel
                    completion(nil, try? JSONDecoder().decode(ErrorResponse.self, from: data))
                }
        }
    }
}
