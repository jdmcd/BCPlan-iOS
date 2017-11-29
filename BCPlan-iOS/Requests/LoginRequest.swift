//
//  LoginRequest.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct LoginRequest: APIRequestRepresentable {
    typealias CodableType = User
    
    static var method: Alamofire.HTTPMethod = .post
    static var endpoint: API.Endpoint = .login
    
    static func request(parameters: Codable?, completion: @escaping (_ object: User?, _ error: Error?) -> Void) {
        AlamoHelper.manager.request(
            url(),
            method: method,
            parameters: parameters?.asDictionary(),
            encoding: JSONEncoding.default,
            headers: defaultHeader()).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let data = try? JSONSerialization.data(withJSONObject: value) else { return }
                    completion(User.from(data: data), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
}
