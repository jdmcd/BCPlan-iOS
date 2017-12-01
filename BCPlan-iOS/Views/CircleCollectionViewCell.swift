//
//  CircleCollectionViewCell.swift
//  BCPlan-iOS
//
//  Created by Jimmy McDermott on 11/29/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit

class CircleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var letterLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var acceptedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        letterLabel.layer.cornerRadius = letterLabel.frame.width / 2
        letterLabel.layer.masksToBounds = true
    }
    
    func configure(member: DetailedProject.Member) {
        guard let firstLetter = member.name.first else { return }
        letterLabel.text = String(describing: firstLetter).uppercased()
        nameLabel.text = member.name
        
        if member.accepted {
            acceptedLabel.isHidden = true
        } else {
            acceptedLabel.isHidden = false
        }
    }
    
    func configurePlus() {
        nameLabel.isHidden = false
        acceptedLabel.isHidden = true
        nameLabel.text = "Add Member"
        letterLabel.text = "+"
    }
}
