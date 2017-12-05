//
//  SuggestTimeRequest.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 12/5/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import Foundation

class SuggestTimeRequest: Codable {
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
}
