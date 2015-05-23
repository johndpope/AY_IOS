
//
//  AddEventViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/18/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class RepeatSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    
    var onDataAvailable : ((data: NSDictionary) -> ())?
    
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
            return self.appDelegate.data_manager!.repeat_none_options.count
        case 1 :
            return self.appDelegate.data_manager!.repeat_options.count
        default :
            return 1
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        switch indexPath.section {
            
        case 0 :
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: repeat_none_option_cell)
            cell?.textLabel?.text = self.appDelegate.data_manager!.repeat_none_options[indexPath.row]
            break
            
        case 1 :
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: repeat_option_cell)
            cell?.textLabel?.text = self.appDelegate.data_manager!.repeat_options[indexPath.row]
            break
            
        default :
            // Should never get here...
            cell = UITableViewCell()
            
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let row = Row(indexPath: indexPath)
        var return_val = NSMutableDictionary()
        return_val.setObject(indexPath.section, forKey: "section")
        return_val.setObject(indexPath.row, forKey: "row")
        switch indexPath.section {
            
        case 0 :
            self.onDataAvailable?(data: return_val)
            self.dismissViewControllerAnimated(true, completion: nil)
            break
        
        case 1 :
            self.onDataAvailable?(data: return_val)
            self.dismissViewControllerAnimated(true, completion: nil)
            break
            
        default :
            // Should never get here...
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    private enum Row: Int {
        case Never
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
                row = Row.Never
            case (1, 0):
                row = Row.Daily
            case (1, 1):
                row = Row.Weekly
            case (1, 2):
                row = Row.TwoWeekly
            case (1, 3):
                row = Row.Monthly
            case (1, 4):
                row = Row.Yearly
            default:
                ()
            }
            
            assert(row != Row.Unknown)
            
            self = row
        }
    }
}
