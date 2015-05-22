
//
//  AddEventViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/18/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class RepeatSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var repeat_options: [String] = ["Every Day", "Every Week", "Every Other Week", "Every Month", "Every Year"]
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return repeat_options.count
        default :
            return 1
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        switch indexPath.section {
            
        case 0 :
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: repeat_option_cell)
            cell?.textLabel?.text = repeat_options[indexPath.row]
            break
            
        default :
            // Should never get here...
            cell = UITableViewCell()
            
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = Row(indexPath: indexPath)
    }
    
    private enum Row: Int {
        case Daily
        case Weekly
        case TwoWeekly
        case Monthly
        case Yearly
        
        case Unknown
        
        
        init(indexPath: NSIndexPath) {
            var row = Row.Unknown
            
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                row = Row.Daily
            case (0, 1):
                row = Row.Weekly
            case (0, 2):
                row = Row.TwoWeekly
            case (0, 3):
                row = Row.Monthly
            case (0, 4):
                row = Row.Yearly
            default:
                ()
            }
            
            assert(row != Row.Unknown)
            
            self = row
        }
    }
}
