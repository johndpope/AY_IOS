
//
//  ChildInfoTableViewCell.swift
//  Ay
//
//  Created by Do Kwon on 5/24/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class ChildInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var age_label: UILabel!
    @IBOutlet weak var name_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
