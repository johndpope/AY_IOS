
//
//  AddEventViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/18/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class NotifyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var none_options: [String] = ["None"]
    var notify_options: [String] = ["At the time of event", "5 minutes before", "10 minutes before", "15 minutes before", "30 minutes before", "1 hour before", "2 hours before", "1 day before", "2 days before", "1 week before"]
    
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
    
    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return none_options.count
        case 1 :
            return notify_options.count
        default :
            return 1
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        switch indexPath.section {
            
        case 0 :
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: none_option_cell)
            cell?.textLabel?.text = none_options[indexPath.row]
            break
        
        case 1 :
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: notify_option_cell)
            cell?.textLabel?.text = notify_options[indexPath.row]
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
