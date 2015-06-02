
//
//  AddEventViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/18/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class NotifyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var onDataAvailable : ((data: NSDictionary) -> ())?
    var select_dictionary: NSMutableDictionary?
    
    @IBOutlet weak var notifyTableView: UITableView!
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.notifyTableView.delegate = self
        self.notifyTableView.dataSource = self
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
            return self.appDelegate.data_manager!.notify_none_options.count
        case 1 :
            return self.appDelegate.data_manager!.notify_options.count
        default :
            return 1
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        switch indexPath.section {
            
        case 0 :
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: notify_none_option_cell)
            cell?.textLabel?.text = self.appDelegate.data_manager!.notify_none_options[indexPath.row]
            
            let cell_width = cell!.frame.size.width
            var check_image = UIImageView(frame: CGRectMake(cell_width, 15, 20, 15))
            check_image.image = UIImage(named: "OptionCheck.png")
            check_image.hidden = true
            if select_dictionary == nil || (select_dictionary!["section"] as! Int) == indexPath.section && (select_dictionary!["row"] as! Int) == indexPath.row{
                    check_image.hidden = false
            }
            cell?.addSubview(check_image)
            break
        
        case 1 :
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: notify_option_cell)
            cell?.textLabel?.text = self.appDelegate.data_manager!.notify_options[indexPath.row]
            
            let cell_width = cell!.frame.size.width
            var check_image = UIImageView(frame: CGRectMake(cell_width, 15, 20, 15))
            check_image.image = UIImage(named: "OptionCheck.png")
            check_image.hidden = true
            if select_dictionary != nil && (select_dictionary!["section"] as! Int) == indexPath.section && (select_dictionary!["row"] as! Int) == indexPath.row{
                check_image.hidden = false
            }
            cell?.addSubview(check_image)
            break
            
        default :
            // Should never get here...
            cell = UITableViewCell()
            
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = Row(indexPath: indexPath)
        if select_dictionary == nil {
            select_dictionary = NSMutableDictionary()
        }
        
        select_dictionary!.setObject(indexPath.section, forKey: "section")
        select_dictionary!.setObject(indexPath.row, forKey: "row")
        self.notifyTableView.reloadData()
        
        switch indexPath.section {
            
        case 0 :
            self.onDataAvailable?(data: select_dictionary!)
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("dismissCurrentView"), userInfo: nil, repeats: false)
            
            break
            
        case 1 :
            self.onDataAvailable?(data: select_dictionary!)
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("dismissCurrentView"), userInfo: nil, repeats: false)
            break
            
        default :
            // Should never get here...
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("dismissCurrentView"), userInfo: nil, repeats: false)
            
        }
    }
    
    func dismissCurrentView(){
        self.dismissViewControllerAnimated(true, completion: nil)
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
                row = Row.EventTime
            case (1, 1):
                row = Row.FiveMin
            case (1, 2):
                row = Row.TenMin
            case (1, 3):
                row = Row.FifteenMin
            case (1, 4):
                row = Row.ThirtyMin
            case (1, 5):
                row = Row.OneHr
            case (1, 6):
                row = Row.TwoHr
            case (1, 7):
                row = Row.OneDay
            case (1, 8):
                row = Row.TwoDay
            case (1, 9):
                row = Row.OneWeek
            default:
                ()
            }
            
            assert(row != Row.Unknown)
            
            self = row
        }
    }
}
