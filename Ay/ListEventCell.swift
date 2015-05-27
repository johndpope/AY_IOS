//
//  ListEventCell.swift
//  Ay
//
//  Created by Ki Suk Jang on 5/23/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class ListEventCell: UITableViewCell {
    @IBOutlet weak var start_time_label: UILabel!
    // Contains the location
    @IBOutlet weak var subtitle_label: UILabel!
    @IBOutlet weak var end_time_label: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var colorImageView: UIImageView!
    
    var event_id: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
