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
    private var first_nameCell: ChildFirstNameCell!
    private var last_nameCell: ChildLastNameCell!
    private var ageCell: ChildAgeCell!
    private var genderCell: ChildGenderCell!
    private var interestCell: ChildInterestCell!
    
    let header_height = 24
    
    @IBOutlet weak var viewTitleView: UILabel!
    var type : String!
    var member: FamilyMember!
    var index_path: NSIndexPath!
    
    let color_strs = ["blue", "green", "yellow", "red", "orange", "purple"]
    let colors = [UIColor(red:0.11, green:0.61,blue:0.89,alpha:1.0), UIColor(red:0.31, green:0.68,blue:0.33,alpha:1.0), UIColor(red:0.99, green:0.84,blue:0.28,alpha:1.0), UIColor(red:0.95, green:0.06,blue:0.35,alpha:1.0), UIColor(red:0.99, green:0.59,blue:0.15,alpha:1.0), UIColor(red:0.61, green:0.18,blue:0.68,alpha:1.0)]
    
    var onDataAvailable : ((data: NSMutableDictionary) -> ())?
    
    @IBAction func first_name_entered(sender: AnyObject) {
        member.first_name = first_nameCell.nameView.text
        
    }
    
    @IBAction func last_name_entered(sender: AnyObject) {
        member.last_name = last_nameCell.nameView.text
        
    }
    
    @IBAction func age_entered(sender: AnyObject) {
        if let age = ageCell.ageView.text.toInt() {
            member.age = age
            return
        }
        
        member.age = 0
    }
    
    @IBAction func gender_entered(sender: AnyObject) {
        let segmented_control = sender as! UISegmentedControl
        // Boy
        if(segmented_control.selectedSegmentIndex == 0) {
            println ("Boy selected")
            member.gender = 1
        }
        // Girl
        else {
            println ("Girl selected")
            member.gender = 0
        }
    }
    
    @IBAction func interest_entered(sender: AnyObject) {
        println ("interest entered")
        member.interests = interestCell.interestView.text
    }
    
    
    @IBAction func cancel_pressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func infoComplete() -> Bool {
        if (member.age as! Int) > 0 && member.color != ""{
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

            // Add the child as a family member
            if index_path == nil{
                if type == "adult"{
                    index_path = NSIndexPath(forRow: -1, inSection: 0)
                } else {
                    index_path = NSIndexPath(forRow: -1, inSection: 1)
                }
            }
            var data = NSMutableDictionary()
            data.setObject(index_path, forKey: "index_path")
            data.setObject(member, forKey: "member")
            self.onDataAvailable?(data: data)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.childInfoTableView.delegate = self
        self.childInfoTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if member == nil {
            if type == "adult" {
                viewTitleView.text = "New Adult"
            } else {
                viewTitleView.text = "New Child"
            }
            member = FamilyMember()
            member.gender = 1
            member.color = ""
        } else {
            viewTitleView.text = member.first_name + " " + member.last_name
            populateTableView()
        }
        
    }
    
    func populateTableView(){
        first_nameCell.nameView.text = member.first_name
        last_nameCell.nameView.text = member.last_name
        ageCell.ageView.text = String(member.age as! Int)
        interestCell.interestView.text = member.interests
        genderCell.genderSwitch.selectedSegmentIndex = ((member.gender as! Int) - 1) * -1
        self.childInfoTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        switch indexPath.section {
            
        case 0 :
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier(add_child_first_name_cell_identifier) as? ChildFirstNameCell
                first_nameCell = cell as! ChildFirstNameCell
            } else if indexPath.row == 1 {
                cell = tableView.dequeueReusableCellWithIdentifier(add_child_last_name_cell_identifier) as? ChildLastNameCell
                last_nameCell = cell as! ChildLastNameCell
            } else if indexPath.row == 2 {
                cell = tableView.dequeueReusableCellWithIdentifier(add_child_age_cell_identifier) as? ChildAgeCell
                ageCell = cell as! ChildAgeCell
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(add_child_gender_cell_identifier) as? ChildGenderCell
                genderCell = cell as! ChildGenderCell
            }
            break
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier(add_child_color_cell_identifier) as? UITableViewCell
            
            for view in cell!.subviews{
                if view is UIImageView {
                    view.removeFromSuperview()
                }
            }
            
            for var i = 0; i < colors.count; ++i {
                var ui_color = colors[i]
                
                let x = 25 + 59 * i
                var member_image = UIImageView(frame: CGRectMake(CGFloat(x), 12, 34, 34))
                member_image.layer.borderWidth = 1
                member_image.layer.borderColor = ui_color.CGColor
                member_image.layer.cornerRadius = member_image.frame.height / 2
                member_image.clipsToBounds = true
                member_image.backgroundColor = ui_color
                member_image.tag = i
                
                var tgr = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
                member_image.addGestureRecognizer(tgr)
                member_image.userInteractionEnabled = true
                
                var check_image = UIImageView(frame: CGRectMake(11, 12, 15, 11))
                check_image.image = UIImage(named: "ParticipantCheck.png")
                if member != nil {
                    if member.color == color_strs[i]{
                        println("check")
                        member_image.addSubview(check_image)
                    }
                }
                
                cell?.addSubview(member_image)
            }

            break
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier(add_child_interest_cell_identifier) as? ChildInterestCell
            interestCell = cell as! ChildInterestCell
            break
        default:
            cell = UITableViewCell()
        }
        return cell!
    }
    
    func imageTapped(gesture: AnyObject){
        var image_view = gesture.view as! UIImageView
        member.color = color_strs[image_view.tag]
        self.childInfoTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 60
        }
        
        return 44
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
            labelView.text = "BASIC INFORMATION"
        } else if section == 1 {
            labelView.text = "TAG COLOR"
        } else if section == 2 {
            labelView.text = "INTERESTS"
        }
        
        var headerView = UIView()
        headerView.addSubview(labelView)
        
        return headerView
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        first_nameCell.nameView.endEditing(true)
        last_nameCell.nameView.endEditing(true)
        ageCell.ageView.endEditing(true)
        interestCell.interestView.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
