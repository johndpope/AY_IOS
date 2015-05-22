
//
//  LocationCell.swift
//  Ay
//
//  Created by Do Kwon on 5/18/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet weak var locationTextField: UITextField!

    @IBAction func locationEntered(sender: AnyObject) {
        locationTextField.endEditing(true)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
