//
//  ChildInfoViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/24/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit
import Foundation

class ChildInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var childInfoTableView: UITableView!
    private var nameCell: ChildNameCell!
    private var ageCell: ChildAgeCell!
    private var genderCell: ChildGenderCell!
    private var interestCell: ChildInterestCell!
    
    let header_height = 24
    
    var child = FamilyMember()
    
    @IBAction func name_entered(sender: AnyObject) {
        child.name = nameCell.nameView.text
        
    }
    
    @IBAction func age_entered(sender: AnyObject) {
        if let age = ageCell.ageView.text.toInt() {
            child.age = age
            return
        }
        
        child.age = 0
    }
    
    @IBAction func gender_entered(sender: AnyObject) {
        let segmented_control = sender as! UISegmentedControl
        // Boy
        if(segmented_control.selectedSegmentIndex == 0) {
            println ("Boy selected")
            child.gender = 1
        }
        // Girl
        else {
            println ("Girl selected")
            child.gender = 0
        }
    }
    
    @IBAction func interest_entered(sender: AnyObject) {
        println ("interest entered")
        child.interests = interestCell.interestView.text
    }
    
    
    @IBAction func cancel_pressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func assign_color(){
        
        let color_strs = ["blue", "green", "yellow", "red", "orange", "purple"]
        
        let i : Int = Int(arc4random_uniform(6))
        child.color = color_strs[i]
    }
    
    func infoComplete() -> Bool {
        if (child.age as! Int) > 0{
            return true
        }
        return false
    }
    
    @IBAction func done_pressed(sender: AnyObject) {
        // Verify data completeness
        if !infoComplete() {
            let alertController = UIAlertController(title: "Incomplete", message: "You need to fill in all the required fields.", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                
                //self.dismissViewControllerAnimated(true, completion:nil)
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        } else {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            // Assign a random color to the child
            assign_color ()
            // Add the child as a family member
            appDelegate.data_manager!.cur_user!.familyMembers.addObject(child)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.childInfoTableView.delegate = self
        self.childInfoTableView.dataSource = self
        
        child.gender = 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(add_child_name_cell_identifier) as? ChildNameCell
            nameCell = cell as! ChildNameCell
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier(add_child_age_cell_identifier) as? ChildAgeCell
            ageCell = cell as! ChildAgeCell
        } else if indexPath.section == 2{
            cell = tableView.dequeueReusableCellWithIdentifier(add_child_gender_cell_identifier) as? ChildGenderCell
            genderCell = cell as! ChildGenderCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(add_child_interest_cell_identifier) as? ChildInterestCell
            interestCell = cell as! ChildInterestCell
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 35
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var labelView = UILabel(frame: CGRect(x: 15, y: 7, width: 200, height: header_height))
        labelView.textAlignment = NSTextAlignment.Left
        labelView.font = UIFont(name: labelView.font.fontName, size: 17)
        labelView.textColor = UIColor.blackColor()
        
        if section == 0 {
            labelView.text = "Name"
        } else if section == 1 {
            labelView.text = "Age"
        } else if section == 2 {
            labelView.text = "Gender"
        } else {
            labelView.text = "Interest"
        }
        
        var headerView = UIView()
        headerView.addSubview(labelView)
        
        return headerView
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
