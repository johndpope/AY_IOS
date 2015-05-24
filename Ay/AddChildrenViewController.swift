//
//  AddChildrenViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/23/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class AddChildrenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    
    
    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let app_delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let user = app_delegate.data_manager!.cur_user
        if user != nil && user!.family_members!.count != 0 {
            return user!.family_members!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let app_delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let user = app_delegate.data_manager!.cur_user

        
        var cell = tableView.dequeueReusableCellWithIdentifier(add_child_cell_identifier)as? ChildInfoTableViewCell
        let row = indexPath.row
        cell!.name_label.text = user!.family_members![row]["first_name"] as? String
        cell!.age_label.text = user!.family_members![row]["age"] as? String

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
