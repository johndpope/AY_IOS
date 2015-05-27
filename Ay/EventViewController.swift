
//
//  AddEventViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/18/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTitleView: UILabel!
    
    var cur_date : CVDate?
    
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
    
    private var repeat_option : NSMutableDictionary!
    private var repeat_end_time: NSDate!
    private var notify_time: NSDate!
    private var target: String!
    
    private var first_load = true
    
    let flags: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday
    
    var onDataAvailable : ((data: String) -> ())?
    var event_id: String?
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func completePressed(sender: AnyObject) {
        
        if title_cell.titleTextField.text == ""  {
            let alertController = UIAlertController(title: "Incomplete", message: "You need to fill in all the required fields.", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                self.dismissViewControllerAnimated(true, completion:nil)
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        } else if end_date_picker_cell.datePicker.date.compare(start_date_picker_cell.datePicker.date) == NSComparisonResult.OrderedAscending{
            end_date_picker_cell.datePicker.date = start_date_picker_cell.datePicker.date
            let alertController = UIAlertController(title: "Time Error", message: "Starting time must occur prior to Ending time.", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                self.dismissViewControllerAnimated(true, completion:nil)
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }

        } else {
            // TODO : add event to global or local array
            var recur_freq = getRecurStructure()
            if event_id == nil {
                ParseCoreService().createEvent(target, title: title_cell.titleTextField.text, start: start_date_picker_cell.datePicker.date, end: end_date_picker_cell.datePicker.date, alarm: notify_time, recur_end: repeat_end_time, recur_freq: recur_freq, recur_occur: 0)
            } else {
                ParseCoreService().updateEvent(event_id!, target: target, title: title_cell.titleTextField.text, start: start_date_picker_cell.datePicker.date, end: end_date_picker_cell.datePicker.date, alarm: notify_time, recur_end: repeat_end_time, recur_freq: recur_freq, recur_occur: 0)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        initializeDatePickers()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addEventSuccess:", name: notification_event_created, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateEventSuccess:", name: notification_event_updated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deleteEventSuccess:", name: notification_event_deleted, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if event_id == nil {
            viewTitleView.text = "Add Event"
            var date_picker = UIDatePicker()
            start_date_cell.dateView.text = NSDateFormatter.localizedStringFromDate(date_picker.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
            end_date_cell.dateView.text = NSDateFormatter.localizedStringFromDate(date_picker.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        } else {
            viewTitleView.text = "Update Event"
            if first_load{
                populateTableView()
                first_load = false
            }
        }

    }
    
    func populateTableView(){
        // Force table to update its contents
        tableView.beginUpdates()
        
        var cur_event = self.appDelegate.data_manager!.getEvent(event_id!)
        title_cell.titleTextField.text = cur_event.title
        start_date_picker_cell.datePicker.date = cur_event.start_time!
        start_date_cell.dateView.text = NSDateFormatter.localizedStringFromDate(cur_event.start_time!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        end_date_picker_cell.datePicker.date = cur_event.end_time!
        end_date_cell.dateView.text = NSDateFormatter.localizedStringFromDate(cur_event.end_time!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        
        var recur_freq = cur_event.recur_freq as NSDictionary!
        if recur_freq == nil {
            repeat_cell.repeatView.text = self.appDelegate.data_manager!.repeat_none_options[0]
            repeatEndHidden = true
        } else {
            var row: Int = 0
            var base = recur_freq["base"] as! String
            if base == "daily"{
                row = 0
            } else if base == "weekly"{
                row = 1
                if (recur_freq["every_other"] as! Int) == 2 {
                    row = 2
                }
            } else if base == "monthly"{
                row = 3
            } else if base == "yearly"{
                row = 4
            }
            if repeat_option == nil {
                repeat_option = NSMutableDictionary()
            }
            repeat_option.setObject(1, forKey: "section")
            repeat_option.setObject(row, forKey: "row")
            repeat_cell.repeatView.text = self.appDelegate.data_manager!.repeat_options[row]
            repeatEndHidden = false
            
            repeat_end_time = cur_event.recur_end as NSDate!
            if repeat_end_time == nil {
                repeat_end_cell.repeatEndView.text = "Never"
            } else {
                repeat_end_cell.repeatEndView.text = NSDateFormatter.localizedStringFromDate(repeat_end_time, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
            }
        }
        
        notify_time = cur_event.alarm_time
        if notify_time == nil {
            notify_cell.notifyView.text = self.appDelegate.data_manager!.notify_none_options[0]
        } else {
            for var i = 0; i < self.appDelegate.data_manager!.notify_options.count; ++i {
                var alarm_time = getAlarmTime(cur_event.start_time!, index: i)
                if notify_time.timeIntervalSinceDate(alarm_time!) == 0 {
                    notify_cell.notifyView.text = self.appDelegate.data_manager!.notify_options[i]
                    break
                }
            }
        }
        
        target = cur_event.target_name
        
        tableView.endUpdates()
    }
    
    func initializeDatePickers(){
        toggleStartDatePicker()
        toggleEndDatePicker()
    }
    
    func addEventSuccess(notification: NSNotification){
        self.onDataAvailable?(data: "success")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateEventSuccess(notification: NSNotification){
        self.onDataAvailable?(data: "success")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func deleteEventSuccess(notification: NSNotification){
        self.onDataAvailable?(data: "success")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setRepeat(data: NSDictionary){
        if (data["section"] as! Int) == 0{
            repeat_option = nil
            repeat_cell.repeatView.text = self.appDelegate.data_manager!.repeat_none_options[(data["row"] as! Int)]
            repeatEndHidden = true
            repeat_end_cell.repeatEndView.text = "Never"
        } else {
            repeat_option = data as! NSMutableDictionary
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
            notify_time = getAlarmTime(start_date_picker_cell.datePicker.date, index: (data["row"] as! Int))
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
        return 4
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0 :
                return 2
            case 1 :
                return 7
            case 2 :
                return 1
            case 3 :
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
                } else if indexPath.row == 1 {
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_start_time_picker_cell_identifier) as? StartTimePickerCell
                    start_date_picker_cell = cell as! StartTimePickerCell
                } else if indexPath.row == 2{
                    cell = tableView.dequeueReusableCellWithIdentifier(add_event_end_cell_identifier) as? EndDateCell
                    end_date_cell = cell as! EndDateCell
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
                    var family_member_list = self.appDelegate.data_manager!.cur_user?.family_members as [NSDictionary]?
                    for var i = 0; i < family_member_list!.count; ++i{
                        var member = family_member_list![i]
                        var member_image = UIImageView(frame: CGRectMake(CGFloat(30 + 80 * i), 50, 50, 50))
                        member_image.layer.borderWidth = 1
                        member_image.layer.borderColor = member["Color"] as! CGColorRef
                        member_image.layer.cornerRadius = member_image.frame.height / 2
                        member_image.clipsToBounds = true
                        member_image.userInteractionEnabled = true
                        
                        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("memberTapped:"))
                        member_image.addGestureRecognizer(tapRecognizer)
                        
                        cell?.addSubview(member_image)
                    }
                }
            
            case 3 :
            
                if indexPath.row == 0{
                    cell = tableView.dequeueReusableCellWithIdentifier(event_delete_cell_identifier) as? UITableViewCell
                }
            
            default :
                // Should never get here...
                cell = UITableViewCell()
            
        }
        
        return cell!
    }
    
    func memberTapped(gestureRecognizer: UITapGestureRecognizer){
        let tappedImageView = gestureRecognizer.view!
        var family_member_list = self.appDelegate.data_manager!.cur_user?.family_members
        for var i = 0; i < family_member_list!.count; ++i{
            var member = family_member_list![i]
            if CGColorEqualToColor(tappedImageView.layer.borderColor, member["Color"] as! CGColorRef){
                target = member["First_Name"] as! String
            }
        }
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
        } else if row == Row.Participants && self.appDelegate.data_manager!.cur_user?.family_members.count > 0 {
            return 120
        } else if row == Row.Delete && event_id == nil {
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
        
        if row == Row.Delete{
            ParseCoreService().deleteEvent(event_id!)
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
    
    private func getAlarmTime(start_time: NSDate, index : Int) -> NSDate? {
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
        case Delete
        
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
            case (3, 0):
                row = Row.Delete
            default:
                ()
            }
            
            assert(row != Row.Unknown)
            
            self = row
        }
    }
}
