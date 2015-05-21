
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
                if time_showing == TimeCellShowingType.NONE_SHOWING {
                    return 3
                } else {
                    return 4
                }
            case 2 :
                return 3
            default :
                return 3
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        switch indexPath.section {
            case 0 :
                // Title
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_title_cell_identifier) as? TitleCell
                    
                }
                // Location
                else {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_location_cell_identifier) as? LocationCell

                }
                break
            case 1 :
                
                if time_showing == TimeCellShowingType.NONE_SHOWING {
                    // Start time
                    if indexPath.row == 0 {
                        cell = tableView.dequeueReusableCellWithIdentifier(add_event_start_cell_identifier) as? StartDateCell
                        
                    } // End time
                    else if indexPath.row == 1{
                        cell = tableView.dequeueReusableCellWithIdentifier(add_event_end_cell_identifier) as? EndDateCell
                        
                    } else {
                        cell = tableView.dequeueReusableCellWithIdentifier(add_event_repeat_cell_identifier) as? RepeatCell
                        
                    }
                } else if time_showing == TimeCellShowingType.START_SHOWING {
                    // Start time
                    if indexPath.row == 0 {
                        cell = tableView.dequeueReusableCellWithIdentifier(add_event_start_cell_identifier) as? StartDateCell
                
                    } else if indexPath.row == 1 {
                        cell = tableView.dequeueReusableCellWithIdentifier(add_event_time_picker_cell_identifier) as? TimePickerCell
                    }
                        
                        // End time
                    else if indexPath.row == 2{
                        cell = tableView.dequeueReusableCellWithIdentifier(add_event_end_cell_identifier) as? EndDateCell
                        
                    } else {
                        cell = tableView.dequeueReusableCellWithIdentifier(add_event_repeat_cell_identifier) as? RepeatCell
                        
                    }
                } else {
                    // Start time
                    if indexPath.row == 0 {
                        cell = tableView.dequeueReusableCellWithIdentifier(add_event_start_cell_identifier) as? StartDateCell
                        
                    }
                        
                        // End time
                    else if indexPath.row == 1{
                        cell = tableView.dequeueReusableCellWithIdentifier(add_event_end_cell_identifier) as? EndDateCell
                        
                    } else if indexPath.row == 2 {
                        cell = tableView.dequeueReusableCellWithIdentifier(add_event_time_picker_cell_identifier) as? TimePickerCell
                    }
                    
                    else {
                        cell = tableView.dequeueReusableCellWithIdentifier(add_event_repeat_cell_identifier) as? RepeatCell
                        
                    }
                }
            
                    
            
        
            case 2 :
        
                // Notify
                if indexPath.row == 0{
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_notify_cell_identifier) as? NotifyCell

                }
                //Participants
                else if indexPath.row == 1{
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_participants_cell_identifier) as? ParticipantsCell

                }
                // Notes
                else {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_notes_cell_identifier) as? NotesCell

                }
            default :
                // Should never get here...
                cell = UITableViewCell()
            
        }
        
        return cell!
    }
    
    enum TimeCellShowingType {
        case NONE_SHOWING
        case START_SHOWING
        case END_SHOWING
    }
    
    var time_showing = TimeCellShowingType.NONE_SHOWING
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*println ("NOT IMPLEMENTED YET")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(deal_detail_segue_identifer, sender: tableView)
        let row = indexPath.row*/
        // Either start time or end time
        if (indexPath.section == 1) {
            var path : NSIndexPath?
            
            if (indexPath.row == 0) {
                tableView.beginUpdates()
                path = NSIndexPath(forRow: 1, inSection: 1)
                tableView.insertRowsAtIndexPaths([path!], withRowAnimation: .Fade)
                time_showing = TimeCellShowingType.START_SHOWING
                
                tableView.endUpdates()
            } else if indexPath.row == 1 {
                tableView.beginUpdates()
                path = NSIndexPath(forRow: 2, inSection: 1)
                tableView.insertRowsAtIndexPaths([path!], withRowAnimation: .Fade)
                
                time_showing = TimeCellShowingType.END_SHOWING
                
                tableView.endUpdates()
            }
            
            
            
        }
    }
}
