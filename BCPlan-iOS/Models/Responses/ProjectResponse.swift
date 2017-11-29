//
//  ProjectResponse.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation

struct ProjectResponse: Codable {
    var admin: [Project]
    var accepted: [Project]
    var pending: [Project]
    
    func projects() -> [Project] {
        var projects = [Project]()
        
        projects.append(contentsOf: admin)
        projects.append(contentsOf: accepted)
        projects.append(contentsOf: pending)
        
        return projects
    }
}
