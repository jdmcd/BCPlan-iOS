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
    
    typealias SuccessAPIResponse = (_ object: CodableType?) -> Void
    typealias ErrorAPIResponse = (_ error: ErrorResponse?) -> Void
    
    var method: Alamofire.HTTPMethod { get set }
    var endpoint: API.Endpoint { get set }
    var isAuthedRequest: Bool { get set }
    func request(parameters: Codable?, success: @escaping SuccessAPIResponse, error: @escaping ErrorAPIResponse)
    func defaultHeaderObject() -> DefaultHeader
    func defaultHeader() -> HTTPHeaders
    func tokenHeader(token: String) -> HTTPHeaders
    func url() -> String
}

extension APIRequestRepresentable {
    func defaultHeaderObject() -> DefaultHeader {
        return DefaultHeader(contentType: "application/json; charset=utf-8", apiKey: API.apiKey)
    }
    
    func defaultHeader() -> HTTPHeaders {
        return defaultHeaderObject().asStringValueDictionary()
    }
    
    func tokenHeader(token: String) -> HTTPHeaders {
        return TokenHeader(defaultHeader: defaultHeaderObject(), token: "Bearer \(token)").asStringValueDictionary()
    }
    
    func url() -> String {
        return API.createUrl(endpoint: endpoint)
    }

    //MARK: - Request functions
    func request(user: User?, success: @escaping SuccessAPIResponse, error: @escaping ErrorAPIResponse) {
        request(parameters: nil, user: user, success: success, error: error)
    }

    func request(parameters: Codable?, success: @escaping SuccessAPIResponse, error: @escaping ErrorAPIResponse) {
        request(parameters: parameters, user: nil, success: success, error: error)
    }

    func request(success: @escaping SuccessAPIResponse, error: @escaping ErrorAPIResponse) {
        request(parameters: nil, user: nil, success: success, error: error)
    }
    
    func request(parameters: Codable?, user: User?, success: @escaping SuccessAPIResponse, error: @escaping ErrorAPIResponse) {
        //validate whether or not there should be a user
        if isAuthedRequest && user == nil {
            error(ErrorResponse(reason: "This is an authorized request and a user object was not passed in"))
            return
        }
        
        //create headers
        var headers = defaultHeader()
        if let user = user {
            headers = tokenHeader(token: user.token)
        }
        
        AlamoHelper.manager.request(
            url(),
            method: method,
            parameters: parameters?.asDictionary(),
            encoding: JSONEncoding.default,
            headers: headers).responseJSON { response in
                //each response should have a status code and a json value
                guard let statusCode = response.response?.statusCode else {
                    error(ErrorResponse(reason: "Connection may be offline"))
                    return
                }
                
                guard let jsonValue = response.result.value else {
                    //check if the status code is still 200...300, because sometimes responses will return only a status code
                    if 200...299 ~= statusCode {
                        success(nil)
                    } else {
                        //return success=false because the status code was not in the acceptable range
                        error(ErrorResponse(reason: "Could not get JSON value"))
                    }
                    
                    return
                }
                
                guard let data = try? JSONSerialization.data(withJSONObject: jsonValue) else {
                    //check if the status code is still 200...300, because sometimes responses will return only a status code
                    if 200...299 ~= statusCode {
                        success(nil)
                    } else {
                        //return success=false because the status code was not in the acceptable range
                        error(ErrorResponse(reason: "Could not get parse data"))
                    }
                    
                    return
                }
                
                if 200...299 ~= statusCode {
                    //success
                    success(CodableType.from(data: data))
                } else {
                    //error - we need a JSONDecoder here because `ErrorResponse` does not conform to APIModel
                    error(try? JSONDecoder().decode(ErrorResponse.self, from: data))
                }
        }
    }
}
