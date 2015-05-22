
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
    
    var onDataAvailable : ((data: String) -> ())?
    
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
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: notify_none_option_cell)
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
        
        switch indexPath.section {
            
        case 0 :
            self.onDataAvailable?(data: none_options[indexPath.row])
            self.dismissViewControllerAnimated(true, completion: nil)
            break
            
        case 1 :
            self.onDataAvailable?(data: notify_options[indexPath.row])
            self.dismissViewControllerAnimated(true, completion: nil)
            break
            
        default :
            // Should never get here...
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    private enum Row: Int {
        case None
        case EventTime
        case FiveMin
        case TenMin
        case FifteenMin
        case ThirtyMin
        case OneHr
        case TwoHr
        case OneDay
        case TwoDay
        case OneWeek
        
        case Unknown
        
        
        init(indexPath: NSIndexPath) {
            var row = Row.Unknown
            
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                row = Row.None
            case (1, 0):
                row = Row.FiveMin
            case (1, 1):
                row = Row.TenMin
            case (1, 2):
                row = Row.FifteenMin
            case (1, 3):
                row = Row.ThirtyMin
            case (1, 4):
                row = Row.OneHr
            case (1, 5):
                row = Row.TwoHr
            case (1, 6):
                row = Row.OneDay
            case (1, 7):
                row = Row.TwoDay
            case (1, 8):
                row = Row.OneWeek
            default:
                ()
            }
            
            assert(row != Row.Unknown)
            
            self = row
        }
    }
}
