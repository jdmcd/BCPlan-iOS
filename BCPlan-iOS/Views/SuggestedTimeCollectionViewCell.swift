//
//  SuggestedTimeCollectionViewCell.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit

class SuggestedTimeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    var timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }

    func configure(date: DetailedProject.MeetingDate) {
        dateLabel.text = dateFormatter.string(from: date.date)
        timeLabel.text = timeFormatter.string(from: date.date)
    }
}
