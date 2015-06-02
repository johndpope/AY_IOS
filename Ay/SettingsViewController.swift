
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
        self.view.backgroundColor = UIColor(red: 0.68, green: 0.68 ,blue:0.68, alpha: 1.0)
        // Do any additional setup after loading the view.
    } 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    ///////////////// TABLEVIEW DELEGATE METHODS ////////////////////

    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.data_manager!.cur_user!.familyMembers.count == 0 {
            return 2
        }
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var rval : Int = 0
        switch section {
            case 0: rval = 2; break;
            case 1: rval = 1; break;
            case 2: rval = appDelegate.data_manager!.cur_user!.familyMembers.count; break;
            default : rval = 2; break;
        }
        return rval
    }
    
   /* func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }*/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(general_cell_identifier, forIndexPath: indexPath) as? UITableViewCell
            if indexPath.row == 0 {
                cell!.textLabel!.text = "About"
            }  else {
                cell!.textLabel!.text = "Logout"
            }
        } else if indexPath.section == 1 {
             cell = tableView.dequeueReusableCellWithIdentifier(integration_cell_identifier, forIndexPath: indexPath) as? UITableViewCell
        } else {
             cell = tableView.dequeueReusableCellWithIdentifier(family_name_cell_identifier, forIndexPath: indexPath) as? UITableViewCell
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let child  = appDelegate.data_manager!.cur_user!.familyMembers.allObjects[indexPath.row] as! FamilyMember
            
            
            
            cell!.textLabel!.text = child.first_name + " " + child.last_name
            
        }
        
        
        
        
        return cell!
    }
    
    /*func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(25)
    }*/
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "General"
        } else if section == 1 {
            return "Integrations"
        }
        return "Edit Family Members"
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
