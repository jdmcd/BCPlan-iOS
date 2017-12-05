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
    
    let redColor = UIColor(red: 126.0/255.0, green: 31.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    let greenColor = UIColor(red: 151.0/255.0, green: 246.0/255.0, blue: 136.0/255.0, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }

    func configure(date: DetailedProject.MeetingDate) {
        layer.borderWidth = 0
        layer.borderColor = nil
        
        if date.selected {
            backgroundColor = greenColor
        } else {
            backgroundColor = redColor
        }
        
        dateLabel.text = dateFormatter.string(from: date.date)
        
        var vote = "vote"
        if date.votes != 1 {
            vote = "votes"
        }
        
        timeLabel.text = "\(timeFormatter.string(from: date.date)) (\(date.votes) \(vote))"
    }
    
    func configureForVote(date: DetailedProject.MeetingDate) {
        layer.borderWidth = 4
        layer.borderColor = greenColor.cgColor
        backgroundColor = redColor
        
        dateLabel.text = dateFormatter.string(from: date.date)
        
        var vote = "vote"
        if date.votes != 1 {
            vote = "votes"
        }
        
        timeLabel.text = "\(timeFormatter.string(from: date.date)) (\(date.votes) \(vote))"
    }
    
    func configureAdd() {
        layer.borderWidth = 0
        layer.borderColor = nil
        
        backgroundColor = redColor
        dateLabel.text = "Add Time"
        timeLabel.text = ""
    }
}
