//
//  Project.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation

class Project: Codable, APIModel {
    var id: Int
    var name: String
    var user_id: Int
    var meeting_date_id: Int?
}
