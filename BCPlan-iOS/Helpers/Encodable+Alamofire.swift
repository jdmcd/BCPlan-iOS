//
//  Encodable+Alamofire.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

extension Encodable {
    func asDictionary() -> Parameters {
        do {
            let data = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] ?? [:]
        } catch {
            return [:]
        }
    }
    
    func asStringValueDictionary() -> HTTPHeaders {
        do {
            let data = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] ?? [:]
        } catch {
            return [:]
        }
    }
}
