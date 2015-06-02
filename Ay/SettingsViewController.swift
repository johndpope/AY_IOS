
//
//  SettingsViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/31/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    // Go back to the main page
    @IBAction func exit_settings_pressed(sender: AnyObject) {
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
    
    
    ///////////////// TABLEVIEW DELEGATE METHODS ////////////////////

    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var rval : Int = 0
        switch section {
            case 0: rval = 2; break;
            case 1: rval = 3; break;
            case 2: rval = appDelegate.data_manager!.cur_user!.familyMembers.count; break;
            case 3: rval = 2; break;
            default : rval = 2; break;
        }
        return rval
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(list_event_cell_identifier, forIndexPath: indexPath) as? ListEventCell
        if (cell == nil) {
            cell = ListEventCell (style: UITableViewCellStyle.Default, reuseIdentifier: list_event_cell_identifier)
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(25)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header_view = UIView()
        var header_label = UILabel(frame: CGRectMake(10, 10, 200, 21))
        return header_view
        /*switch section {
        case 0: rval = 2; break;
        case 1: rval = 3; break;
        case 2: rval = appDelegate.data_manager!.cur_user!.familyMembers.count; break;
        case 3: rval = 2; break;
        default : rval = 2; break;
        }*/
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    
    
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
