//
//  AddChildrenViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/23/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class AddChildrenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let app_delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    private var adult_list = NSMutableSet()
    private var child_list = NSMutableSet()
    
    private var type : String!
    private var member: FamilyMember!
    private var index_path: NSIndexPath!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let header_height = 35
    
    override func viewDidAppear(animated: Bool){
        index_path = nil
        member = nil
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // When preparing for the segue, have viewController1 provide a closure for
        // onDataAvailable
        if let viewController = segue.destinationViewController as? ViewController {
            var new_list = adult_list
            new_list.unionSet(child_list as Set<NSObject>)
            app_delegate.data_manager!.cur_user?.familyMembers = new_list
            ParseCoreService().updateUser(app_delegate.data_manager!.cur_user!.first_name, last_name: app_delegate.data_manager!.cur_user!.last_name, family_members: app_delegate.data_manager!.cur_user!.familyMembers)
        } else if let viewController = segue.destinationViewController as? ChildInfoViewController {
            if sender is AddAdultCell {
                type = "adult"
            } else if sender is AddChildCell{
                type = "child"
            } else if sender is ChildInfoTableViewCell{
                index_path = self.tableView.indexPathForCell(sender as! ChildInfoTableViewCell)! as NSIndexPath
                if index_path.section == 0 {
                    type = "adult"
                    member = adult_list.allObjects[index_path.row] as! FamilyMember
                } else {
                    type = "child"
                    member = child_list.allObjects[index_path.row] as! FamilyMember
                }
            }
            viewController.type = type
            viewController.member = member
            viewController.index_path = index_path
            viewController.onDataAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    weakSelf.updateFamilyList(data)
                }
            }
        }
    }
    
    func updateFamilyList(data: NSMutableDictionary){
        index_path = nil
        member = nil
        var path = data["index_path"] as! NSIndexPath
        if path.section == 0 {
            (data["member"] as! FamilyMember).type = "adult"
            if path.row >= 0 {
                var array = adult_list.allObjects as! [FamilyMember]
                array.removeAtIndex(path.row)
                adult_list = NSMutableSet(array: array)
            }
            adult_list.addObject(data["member"] as! FamilyMember)
        } else {
            (data["member"] as! FamilyMember).type = "child"
            if path.row >= 0 {
                var array = child_list.allObjects as! [FamilyMember]
                array.removeAtIndex(path.row)
                child_list = NSMutableSet(array: array)
            }
            child_list.addObject(data["member"] as! FamilyMember)
        }
    }

    
    
    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return adult_list.count + 1
        } else {
            return child_list.count + 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = app_delegate.data_manager!.cur_user

        var cell : UITableViewCell?
        switch indexPath.section {
            
        case 0 :
            if indexPath.row < adult_list.count {
                cell = tableView.dequeueReusableCellWithIdentifier(add_family_person_cell_identifier) as? ChildInfoTableViewCell
                let adult = adult_list.allObjects[indexPath.row] as! FamilyMember
                (cell as! ChildInfoTableViewCell).name_label.text = (adult.first_name as String) + " " + (adult.last_name as String)
                
                var member_image = UIImageView(frame: CGRectMake(20, 14, 15, 15))
                member_image.layer.borderWidth = 1
                member_image.layer.borderColor = adult.assigned_color().CGColor
                member_image.layer.cornerRadius = member_image.frame.height / 2
                member_image.clipsToBounds = true
                member_image.backgroundColor = adult.assigned_color() as UIColor
                
                cell?.addSubview(member_image)
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(add_adult_cell_identifier)as? AddAdultCell
            }
            break
        case 1:
            if indexPath.row < child_list.count {
                cell = tableView.dequeueReusableCellWithIdentifier(add_family_person_cell_identifier)as? ChildInfoTableViewCell
                let child = child_list.allObjects[indexPath.row] as! FamilyMember
                (cell as! ChildInfoTableViewCell).name_label.text = (child.first_name as String) + " " + (child.last_name as String)
                
                var member_image = UIImageView(frame: CGRectMake(20, 14, 15, 15))
                member_image.layer.borderWidth = 1
                member_image.layer.borderColor = child.assigned_color().CGColor
                member_image.layer.cornerRadius = member_image.frame.height / 2
                member_image.clipsToBounds = true
                member_image.backgroundColor = child.assigned_color() as UIColor
                
                cell?.addSubview(member_image)
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(add_child_cell_identifier)as? AddChildCell
            }
            break
        default :
            // Should never get here...
            cell = UITableViewCell()
            
        }
        
        return cell!
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(header_height)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var labelView = UILabel(frame: CGRect(x: 15, y: 7, width: 200, height: header_height))
        if section == 0 {
            labelView.text = "ADULT"
        } else {
            labelView.text = "CHILDREN"
        }
        labelView.textAlignment = NSTextAlignment.Left
        labelView.font = UIFont(name: labelView.font.fontName, size: 17)
        labelView.textColor = UIColor.blackColor()
        
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
