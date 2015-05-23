
//
//  ScheduleTableViewCell.swift
//  Ay
//
//  Created by Do Kwon on 5/9/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var participant_color_code: UIView!
    @IBOutlet weak var start_time_label: UILabel!
    @IBOutlet weak var end_time_label: UILabel!
    @IBOutlet weak var title_label: UILabel!
    
    var cur_event : AyEvent?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
