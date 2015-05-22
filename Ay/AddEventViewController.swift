
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
    
    private var startDatePickerHidden = false
    private var endDatePickerHidden = false
    private var start_date_cell : StartDateCell!
    private var end_date_cell : EndDateCell!
    private var start_date_picker_cell : StartTimePickerCell!
    private var end_date_picker_cell : EndTimePickerCell!
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addPressed(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        initializeDatePickers()
        
        // Do any additional setup after loading the view.
    }
    
    func initializeDatePickers(){
        toggleStartDatePicker()
        toggleEndDatePicker()
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
                return 6
            case 2 :
                return 1
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
                
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_start_cell_identifier) as? StartDateCell
                    start_date_cell = cell as! StartDateCell
                    if start_date_cell.dateView.text == "Detail" {
                        var date_picker = UIDatePicker()
                        start_date_cell.dateView.text = NSDateFormatter.localizedStringFromDate(date_picker.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
                    }
                } else if indexPath.row == 1 {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_start_time_picker_cell_identifier) as? StartTimePickerCell
                    start_date_picker_cell = cell as! StartTimePickerCell
                } else if indexPath.row == 2{
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_end_cell_identifier) as? EndDateCell
                    end_date_cell = cell as! EndDateCell
                    if end_date_cell.dateView.text == "Detail" {
                        var date_picker = UIDatePicker()
                        end_date_cell.dateView.text = NSDateFormatter.localizedStringFromDate(date_picker.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
                    }
                } else if indexPath.row == 3 {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_end_time_picker_cell_identifier) as? EndTimePickerCell
                    end_date_picker_cell = cell as! EndTimePickerCell
                } else if indexPath.row == 4{
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_repeat_cell_identifier) as? RepeatCell
                        
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_notify_cell_identifier) as? NotifyCell
                }
                    
            
        
            case 2 :
        
                if indexPath.row == 0{
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_participants_cell_identifier) as? ParticipantsCell

                }
            default :
                // Should never get here...
                cell = UITableViewCell()
            
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = Row(indexPath: indexPath)
        
        if row == Row.StartDatePicker{
            if startDatePickerHidden {
                return 0
            } else {
                return 135
            }
        } else if row == Row.EndDatePicker {
            if endDatePickerHidden {
                return 0
            } else {
                return 135
            }
        } else {
            return 44
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = Row(indexPath: indexPath)
        
        if row == Row.StartDate{
            toggleStartDatePicker()
        } else if row == Row.EndDate {
            toggleEndDatePicker()
        }
    }
    
    @IBAction
    func didChangeStartDate() {
        if start_date_cell != nil && start_date_picker_cell != nil {
            start_date_cell.dateView.text = NSDateFormatter.localizedStringFromDate(start_date_picker_cell.datePicker.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        }
    }
    
    @IBAction
    func didChangeEndDate() {
        if end_date_cell != nil && end_date_picker_cell != nil {
            end_date_cell.dateView.text = NSDateFormatter.localizedStringFromDate(end_date_picker_cell.datePicker.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        }
    }
    
    private func toggleStartDatePicker() {
        startDatePickerHidden = !startDatePickerHidden
        
        // Force table to update its contents
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func toggleEndDatePicker() {
        endDatePickerHidden = !endDatePickerHidden
        
        // Force table to update its contents
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private enum Row: Int {
        case Title
        case Location
        case StartDate
        case StartDatePicker
        case EndDate
        case EndDatePicker
        case Repeat
        case Notify
        case Participants
        
        case Unknown
        
        
        init(indexPath: NSIndexPath) {
            var row = Row.Unknown
            
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                row = Row.Title
            case (0, 1):
                row = Row.Location
            case (1, 0):
                row = Row.StartDate
            case (1, 1):
                row = Row.StartDatePicker
            case (1, 2):
                row = Row.EndDate
            case (1, 3):
                row = Row.EndDatePicker
            case (1, 4):
                row = Row.Repeat
            case (1, 5):
                row = Row.Notify
            case (2, 0):
                row = Row.Participants
            default:
                ()
            }
            
            assert(row != Row.Unknown)
            
            self = row
        }
    }
}
