//
//  DetailedProject.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation

class DetailedProject: Codable, APIModel {
    var id: Int
    var name: String
    var user_id: Int
    var attending: Bool
    var meeting_date_id: Int?
    var members: [Member]
    var dates: [MeetingDate]
    var attendingUsers: [User]
    
    struct Member: Codable {
        var id: Int
        var name: String
        var accepted: Bool
    }
    
    struct MeetingDate: Codable {
        var id: Int
        var date: Date
        var votes: Int
        var selected: Bool
    }
    
    func hasSelectedDate() -> Bool {
        return dates.map { $0.selected }.contains(true)
    }
}
