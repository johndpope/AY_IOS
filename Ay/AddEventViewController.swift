
//
//  AddEventViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/18/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var tableView: UITableView!
    
    private var startDatePickerHidden = false
    private var endDatePickerHidden = false
    private var repeatEndHidden = true
    private var start_date_cell : StartDateCell!
    private var end_date_cell : EndDateCell!
    private var start_date_picker_cell : StartTimePickerCell!
    private var end_date_picker_cell : EndTimePickerCell!
    private var title_cell : TitleCell!
    private var loc_cell : LocationCell!
    private var repeat_cell : RepeatCell!
    private var repeat_end_cell : RepeatEndCell!
    private var notify_cell : NotifyCell!
    
    private var repeat_option : NSDictionary!
    private var repeat_end_time: NSDate!
    private var notify_time: NSDate!
    
    let flags: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addPressed(sender: AnyObject) {
        
        var recur_freq = getRecurStructure()
        var new_event = AyEvent(id: appDelegate.data_manager!.cur_user!.Object_Id, target_name: "Brian", start: start_date_picker_cell.datePicker.date, end: end_date_picker_cell.datePicker.date, title: title_cell.titleTextField.text, alarm: notify_time, recur_end: repeat_end_time, recur_freq: recur_freq, recur_occur: 0)
        self.appDelegate.data_manager!.events.append(new_event)
        ParseCoreService().createEvent("Brian", title: title_cell.titleTextField.text, start: start_date_picker_cell.datePicker.date, end: end_date_picker_cell.datePicker.date, alarm: notify_time, recur_end: repeat_end_time, recur_freq: recur_freq, recur_occur: 0)
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func setRepeat(data: NSDictionary){
        if (data["section"] as! Int) == 0{
            repeat_option = nil
            repeat_cell.repeatView.text = self.appDelegate.data_manager!.repeat_none_options[(data["row"] as! Int)]
            repeatEndHidden = true
            repeat_end_cell.repeatEndView.text = "Never"
        } else {
            repeat_option = data
            repeat_cell.repeatView.text = self.appDelegate.data_manager!.repeat_options[(data["row"] as! Int)]
            repeatEndHidden = false
        }
        
        // Force table to update its contents
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func setRepeatEnds(data: NSDictionary){
        if data["date"] == nil {
            repeat_end_time = nil
            repeat_end_cell.repeatEndView.text = "Never"
        } else {
            repeat_end_time = data["date"] as! NSDate
            repeat_end_cell.repeatEndView.text = NSDateFormatter.localizedStringFromDate(repeat_end_time, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        }
    }
    
    func setNotify(data: NSDictionary){
        if (data["section"] as! Int) == 0{
            notify_time = nil
            notify_cell.notifyView.text = self.appDelegate.data_manager!.notify_none_options[(data["row"] as! Int)]
        } else {
            notify_time = getAlarmTime((data["row"] as! Int))
            notify_cell.notifyView.text = self.appDelegate.data_manager!.notify_options[(data["row"] as! Int)]
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // When preparing for the segue, have viewController1 provide a closure for
        // onDataAvailable
        if let viewController = segue.destinationViewController as? RepeatSettingViewController {
            viewController.onDataAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    weakSelf.setRepeat(data)
                }
            }
        } else if let viewController = segue.destinationViewController as? RepeatEndsViewController {
            viewController.onDate = repeat_end_time
            viewController.onDataAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    weakSelf.setRepeatEnds(data)
                }
            }
        } else if let viewController = segue.destinationViewController as? NotifyViewController {
            viewController.onDataAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    weakSelf.setNotify(data)
                }
            }
        }
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
                return 7
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
                    title_cell = cell as! TitleCell
                }
                // Location
                else {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_location_cell_identifier) as? LocationCell
                    loc_cell = cell as! LocationCell
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
                    repeat_cell = cell as! RepeatCell
                } else if indexPath.row == 5{
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_repeat_end_cell_identifier) as? RepeatEndCell
                    repeat_end_cell = cell as! RepeatEndCell
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_notify_cell_identifier) as? NotifyCell
                    notify_cell = cell as! NotifyCell
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
                return 160
            }
        } else if row == Row.EndDatePicker {
            if endDatePickerHidden {
                return 0
            } else {
                return 160
            }
        } else if row == Row.RepeatEnd && repeatEndHidden{
            return 0
        }
        
        return 44
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = Row(indexPath: indexPath)
        
        if row != Row.Title && row != Row.Location{
            title_cell.titleTextField.endEditing(true)
            loc_cell.locationTextField.endEditing(true)
        }
        
        // close date picker if opened
        if row != Row.StartDate && !startDatePickerHidden{
            toggleStartDatePicker()
        }
        if row != Row.EndDate && !endDatePickerHidden{
            toggleEndDatePicker()
        }
        
        // open date picker
        if row == Row.StartDate{
            toggleStartDatePicker()
        }
        if row == Row.EndDate{
            toggleEndDatePicker()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        title_cell.titleTextField.endEditing(true)
        loc_cell.locationTextField.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    private func getAlarmTime(index : Int) -> NSDate? {
        let start_time = start_date_picker_cell.datePicker.date
        
        switch index {
        case 0:
            return start_time
        case 1:
            var min_dec = -5
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMinute, value: min_dec, toDate: start_time, options: nil)!
        case 2:
            var min_dec = -10
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMinute, value: min_dec, toDate: start_time, options: nil)!
        case 3:
            var min_dec = -15
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMinute, value: min_dec, toDate: start_time, options: nil)!
        case 4:
            var min_dec = -30
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMinute, value: min_dec, toDate: start_time, options: nil)!
        case 5:
            var hr_dec = -1
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitHour, value: hr_dec, toDate: start_time, options: nil)!
        case 6:
            var hr_dec = -2
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitHour, value: hr_dec, toDate: start_time, options: nil)!
        case 7:
            var day_dec = -1
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: day_dec, toDate: start_time, options: nil)!
        case 8:
            var day_dec = -2
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: day_dec, toDate: start_time, options: nil)!
        case 9:
            var day_dec = -7
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: day_dec, toDate: start_time, options: nil)!
        default:
            return nil
        }
    }
    
    private func getRecurStructure() -> NSDictionary? {
        if repeat_option == nil{
            return nil
        }
        
        let start_time = start_date_picker_cell.datePicker.date
        let start_components = NSCalendar.currentCalendar().components(flags, fromDate: start_time)
        
        var base : String!
        var every_other = 1
        var days_of_week : Array<NSDictionary>? = Array<NSDictionary>()
        var days_of_month: Array<Int>? = Array<Int>()

        if (repeat_option["row"] as! Int) == 0 {
            base = "daily"
            days_of_week = nil
            days_of_month = nil
        } else if (repeat_option["row"] as! Int) == 1 {
            base = "weekly"
            var day_of_week : NSMutableDictionary! = NSMutableDictionary()
            day_of_week.setObject(start_components.weekday, forKey: "day")
            days_of_week!.append(day_of_week)
        } else if (repeat_option["row"] as! Int) == 2 {
            base = "weekly"
            every_other = 2
            var day_of_week : NSMutableDictionary! = NSMutableDictionary()
            day_of_week.setObject(start_components.weekday, forKey: "day")
            days_of_week!.append(day_of_week)
        } else if (repeat_option["row"] as! Int) == 3 {
            base = "montly"
            days_of_month!.append(start_components.day)
        } else {
            base = "yearly"
        }
        
        
        var recur_option = NSMutableDictionary()
        recur_option.setObject(base, forKey: "base")
        recur_option.setObject(every_other, forKey: "every_other")
        if days_of_week != nil {
            recur_option.setObject(days_of_week!, forKey: "days_of_week")
        }
        if days_of_month != nil {
            recur_option.setObject(days_of_month!, forKey: "days_of_month")
        }
        
        return recur_option
    }
    
    private enum Row: Int {
        case Title
        case Location
        case StartDate
        case StartDatePicker
        case EndDate
        case EndDatePicker
        case Repeat
        case RepeatEnd
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
                row = Row.RepeatEnd
            case (1, 6):
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
