//
//  AlamofireHelper.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/28/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation
import Alamofire

class AlamoHelper {
    static var manager: SessionManager = {
        let configuration = URLSessionConfiguration.ephemeral
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    }()
}
