//
//  ChildGenderCell.swift
//  Ay
//
//  Created by Ki Suk Jang on 5/28/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class ChildGenderCell: UITableViewCell {
    
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}