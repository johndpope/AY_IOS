
//
//  AddEventViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/18/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addPressed(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
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
        switch section {
            case 0 :
                return 2
            case 1 :
                return 3
            case 2 :
                return 3
            default :
                return 3
        }
    }
    
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 2 {
            
        }
    }*/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        switch indexPath.section {
            case 0 :
                // Title
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_title_cell_identifier) as? TitleCell
                    if cell == nil {
                        cell = TitleCell(style: UITableViewCellStyle.Default, reuseIdentifier: add_event_title_cell_identifier)
                    }
                }
                // Location
                else {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_location_cell_identifier) as? LocationCell

                    if cell == nil {
                        cell = LocationCell(style: UITableViewCellStyle.Default, reuseIdentifier: add_event_location_cell_identifier)
                    }
                }
                break
            case 1 :
                // Start time
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_start_cell_identifier) as? StartDateCell

                    if cell == nil {
                        cell = StartDateCell(style: UITableViewCellStyle.Default, reuseIdentifier: add_event_start_cell_identifier)
                    }
                }
                // End time
                else if indexPath.row == 1{
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_end_cell_identifier) as? EndDateCell

                    if cell == nil {
                        cell = EndDateCell(style: UITableViewCellStyle.Default, reuseIdentifier: add_event_end_cell_identifier)
                    }
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_repeat_cell_identifier) as? RepeatCell
                    if cell == nil {
                        cell = RepeatCell(style: UITableViewCellStyle.Default, reuseIdentifier: add_event_repeat_cell_identifier)
                    }
                }
        
            case 2 :
        
                // Notify
                if indexPath.row == 0{
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_notify_cell_identifier) as? NotifyCell

                    if cell == nil {
                        cell = NotifyCell(style: UITableViewCellStyle.Default, reuseIdentifier: add_event_notify_cell_identifier)
                    }
                }
                //Participants
                else if indexPath.row == 1{
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_participants_cell_identifier) as? ParticipantsCell

                    if cell == nil {
                        cell = ParticipantsCell(style: UITableViewCellStyle.Default, reuseIdentifier: add_event_participants_cell_identifier)
                    }
                }
                // Notes
                else {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_notes_cell_identifier) as? NotesCell

                    if cell == nil {
                        cell = NotesCell(style: UITableViewCellStyle.Default, reuseIdentifier: add_event_notes_cell_identifier)
                    }
                }
            default :
                cell = UITableViewCell()
            
        }
        
        return cell!
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*println ("NOT IMPLEMENTED YET")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(deal_detail_segue_identifer, sender: tableView)
        let row = indexPath.row*/
    }
}
