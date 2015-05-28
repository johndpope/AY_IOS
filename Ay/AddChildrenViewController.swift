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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool){
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
            ParseCoreService().updateUser(app_delegate.data_manager!.cur_user!.first_name, last_name: app_delegate.data_manager!.cur_user!.last_name, family_members: app_delegate.data_manager!.cur_user!.familyMembers)
        }
    }

    
    
    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let app_delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let user = app_delegate.data_manager!.cur_user
        if user != nil && user!.familyMembers.count != 0 {
            return user!.familyMembers.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = app_delegate.data_manager!.cur_user

        
        var cell = tableView.dequeueReusableCellWithIdentifier(add_child_cell_identifier)as? ChildInfoTableViewCell
        let row = indexPath.row
        let child = user!.familyMembers.allObjects[row] as! FamilyMember
        cell!.name_label.text = child.name as String
        cell!.age_label.text = "Age: " + "\(child.age)"
        
        var member_image = UIImageView(frame: CGRectMake(15, 7, 30, 30))
        member_image.layer.borderWidth = 1
        member_image.layer.borderColor = child.assigned_color().CGColor
        member_image.layer.cornerRadius = member_image.frame.height / 2
        member_image.clipsToBounds = true
        member_image.backgroundColor = child.assigned_color() as UIColor
        
        cell?.addSubview(member_image)
        
        return cell!
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*println ("NOT IMPLEMENTED YET")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(deal_detail_segue_identifer, sender: tableView)
        let row = indexPath.row*/
        
        // TODO, but I think we will disable user interaction
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
