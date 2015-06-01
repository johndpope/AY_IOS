//
//  ViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/9/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit
//import CVCalendar

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CVCalendarViewDelegate {

    // The titlebar pressed, shoudl return to today
    @IBAction func return_today_button_pressed(sender: AnyObject) {
        let cv_today = CVDate(date: NSDate())
        presentedDateUpdated(cv_today)
        self.calendarView.toggleMonthViewWithDate(NSDate())
        self.calendarView.commitCalendarViewUpdate()
        //self.menuView.commitMenuViewUpdate()
    }
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let flags: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday
    
    @IBOutlet weak var sectionheader: UIView!
    
    @IBOutlet weak var dateHeader: UILabel!
    
    let header_height = 25

    @IBAction func settingsPressed(sender: AnyObject) {
    }
   
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var dateLabel: UILabel!
    private var schedules = NSMapTable()
    private var section_index_to_date = Array<Int>()
    private var first_month_available : Int! // YYYYMM
    private var last_month_available : Int! // YYYYMM
    private var loading_next_month = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeDate()
        
        scheduleTableView.delegate   = self
        scheduleTableView.dataSource = self
        
        calendarView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshSchedule:", name: notification_events_fetched, object: nil)
        
        //let no_event_label =
        no_event_label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        no_event_label!.center = CGPointMake(189, (self.scheduleTableView.frame.height - no_event_label!.frame.height) / 2)
        no_event_label!.textAlignment = NSTextAlignment.Center
        no_event_label!.text = "No Events"
        self.scheduleTableView.addSubview(no_event_label!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load the calendar view
        self.menuView.commitMenuViewUpdate()
        //self.calendarView.commitCalendarViewUpdate()
        
        refreshSchedule()
        
       self.dateLabel.text = self.calendarView.presentedDate?.description_str()
        
        setBgColor(self.calendarView.presentedDate!)
    }
    
    func initializeDate(){
        //Initialize current month
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: date)
        first_month_available = components.year * 100 + components.month
        last_month_available = first_month_available
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // When preparing for the segue, have viewController1 provide a closure for
        // onDataAvailable
        if let viewController = segue.destinationViewController as? EventViewController {
            if sender is ListEventCell {
                viewController.event_id = (sender as! ListEventCell).event_id
            }
            viewController.onDataAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    if data == "success"{
                        weakSelf.refreshSchedule()
                    }
                }
            }
        }
    }

    
    // Events pulled from server
    func refreshSchedule(notification: NSNotification){
        refreshSchedule()
    }
    
    var no_event_label : UILabel?
    
    func refreshSchedule(){
        initializeDate()
        schedules.removeAllObjects()
        section_index_to_date.removeAll(keepCapacity: false)
        scheduleTableView.reloadData()
        
        addMonthlySchedule(first_month_available % 100, year: first_month_available / 100)
        
        if schedules.count != 0 {
            // Need to remove label
            no_event_label!.textColor = UIColor.clearColor()
        } else {
            /* Add UILabel that shows that there are no events at the moment */
            no_event_label!.textColor = UIColor.blackColor()
        }
        
        /* Change calendar appearance based on what we  get from server */
        self.calendarView.commitCalendarViewUpdate()
    }
    
    func addMonthlySchedule(month: Int, year: Int) {
        var new_schedules = self.appDelegate.data_manager!.getMonthlySchedule(month, year: year)
        
        scheduleTableView.beginUpdates()
        
        var temp_schedule = addSchedule(new_schedules)
        
        // Add sections to table view
        var org_section_count = section_index_to_date.count
        refreshDateSectionMap(temp_schedule)
        var index_set = NSMutableIndexSet()
        for var i = org_section_count; i < section_index_to_date.count; ++i {
            index_set.addIndex(i)
        }
        scheduleTableView.insertSections(index_set, withRowAnimation: UITableViewRowAnimation.Bottom)
        

        // Add rows to each section
        var index_path_list = Array<NSIndexPath>()
        var enumerator = new_schedules.keyEnumerator()
        while let date: Int = enumerator.nextObject() as? Int {
            let new_event_list = new_schedules.objectForKey(date) as! Array<AyEvent>
            var section_index = 0
            for var i = 0; i < section_index_to_date.count; ++i {
                if section_index_to_date[i] == date {
                    section_index = i
                    break
                }
            }
            
            let org_event_list = schedules.objectForKey(date) as? Array<AyEvent>
            var org_count = 0
            if org_event_list != nil {
                org_count = org_event_list!.count
            }
            for var i = 0; i < new_event_list.count; ++i{
                var new_index_path = NSIndexPath(forRow: org_count + i, inSection: section_index)
                index_path_list.append(new_index_path)
            }
        }
        
        schedules = temp_schedule
        scheduleTableView.insertRowsAtIndexPaths(index_path_list, withRowAnimation: UITableViewRowAnimation.Bottom)

        scheduleTableView.endUpdates()
    }
    
    func refreshDateSectionMap(new_schedule: NSMapTable){
        section_index_to_date.removeAll(keepCapacity: false)
        var enumerator = new_schedule.keyEnumerator()
        while let date: Int = enumerator.nextObject() as? Int {
            section_index_to_date.append(date)
        }
        section_index_to_date.sort({ $0 < $1 })
    }
    
    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return schedules.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = section_index_to_date[section]
        let event_list = schedules.objectForKey(date) as! Array<AyEvent>
        return event_list.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(list_event_cell_identifier, forIndexPath: indexPath) as? ListEventCell
        if (cell == nil) {
            cell = ListEventCell (style: UITableViewCellStyle.Default, reuseIdentifier: list_event_cell_identifier)
        }
        
        let date = section_index_to_date[indexPath.section]
        
        let event_list = schedules.objectForKey(date) as! Array<AyEvent>
        let event = event_list[indexPath.row]
        cell!.titleView.text = event.title
        cell!.event_id = event.id
        
        cell!.subtitle_label.text = "location"
        
        cell!.start_time_label.text = NSDateFormatter.localizedStringFromDate(event.start_time!, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
        cell!.end_time_label.text = NSDateFormatter.localizedStringFromDate(event.end_time!, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
        var family_member_list = self.appDelegate.data_manager!.cur_user?.familyMembers.allObjects
        var color: UIColor?
        if event.participants != nil {
            for member in event.participants!.allObjects{
                color = (member as! FamilyMember).assigned_color() as UIColor
                break
            }
        }
        if color != nil {
            cell!.colorImageView.backgroundColor = color
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(header_height)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        var date = dateFormatter.dateFromString(String(section_index_to_date[section]))
        var date_components = NSCalendar.currentCalendar().components(flags, fromDate: date!)
        var cal_date : String = String(date_components.month) + "/" + String(date_components.day) + "/" + String(date_components.year % 100)
        
        var weekDayView = UILabel(frame: CGRect(x: 15, y: 0, width: 200, height: header_height))
        weekDayView.text = (self.appDelegate.data_manager!.weekday_list[date_components.weekday-1]).uppercaseString
        weekDayView.textAlignment = NSTextAlignment.Left
        weekDayView.font = UIFont.boldSystemFontOfSize(16.0)
        weekDayView.textColor =  UIColor(red:0.298, green:0.564,blue:0.886,alpha:1.0)

        
        var dateView = UILabel(frame: CGRect(x: Int(weekDayView.frame.origin.x  + 90), y: 0, width: 200, height: header_height))
        dateView.text = cal_date
        dateView.textAlignment = NSTextAlignment.Left
        dateView.font = UIFont(name: dateView.font.fontName, size: 15)
        dateView.textColor = UIColor(red:0.298, green:0.564,blue:0.886,alpha:1.0)

        
        var headerView = UIView()
        headerView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        headerView.addSubview(weekDayView)
        headerView.addSubview(dateView)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.scheduleTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 40 && !loading_next_month{
            loading_next_month = true
            
            var next_month = last_month_available + 1
            if next_month % 100 == 13 {
                next_month += 88
            }
            last_month_available = next_month
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateScheduleList"), userInfo: nil, repeats: false)
            
        }
    }
    
    func updateScheduleList(){
        addMonthlySchedule(last_month_available % 100, year: last_month_available / 100)
        loading_next_month = false
    }
    
    
    func addSchedule(new_schedule_map: NSMapTable) -> NSMapTable{
        var temp_schedule = schedules.copy() as! NSMapTable
        var enumerator = new_schedule_map.keyEnumerator()
        while let date: Int = enumerator.nextObject() as? Int {
            var event_list = temp_schedule.objectForKey(date) as? Array<AyEvent>
            var new_event_list = new_schedule_map.objectForKey(date) as! Array<AyEvent>
            if event_list == nil {
                event_list = new_event_list
            } else {
                event_list! += new_event_list
            }
            temp_schedule.setObject(event_list!, forKey: date)
        }
        return temp_schedule
    }
    
    /////////////////////// Calendar delegate methods ///////////////////////
    
    
   
    
    /* Determines whether a month view should contain days out or not. 
      If the value is true then it's possible to toggle between month 
     views on selecting day out. */
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    /* Notifies the delegate when a specific day view is touched. */
    func didSelectDayView(dayView: CVCalendarDayView) {
        // TODO : Add individual schedules
        // Move to certain schedule view
    }
    
    func setBgColor(date: CVDate) {
        // Set the colors of the status bar
        var colors = [
            // January
            UIColor(red:0.11, green:0.61,blue:0.89,alpha:1.0),
            // February
            UIColor(red:0.18, green:0.78,blue:0.64,alpha:1.0),
            // March
            UIColor(red:0.31, green:0.68,blue:0.33,alpha:1.0),
            // April
            UIColor(red:0.41, green:0.73,blue:0.43,alpha:1.0),
            // May
            UIColor(red:0.99, green:0.84,blue:0.28,alpha:1.0),
            // June
            UIColor(red:0.99, green:0.75,blue:0.18,alpha:1.0),
            // July
            UIColor(red:0.99, green:0.59,blue:0.15,alpha:1.0),
            // august
            UIColor(red:0.95, green:0.21,blue:0.24,alpha:1.0),
            // September
            UIColor(red:0.95, green:0.06,blue:0.35,alpha:1.0),
            // October
            UIColor(red:0.78, green:0.12,blue:0.51,alpha:1.0),
            // November
            UIColor(red:0.61, green:0.18,blue:0.68,alpha:1.0),
            // December
            UIColor(red:0.32, green:0.39,blue:0.78,alpha:1.0)
            
        ]
        
        //self.menuView.backgroundColor = colors [date.month! - 1]
        self.view.backgroundColor = colors [date.month! - 1]
        
    }
    
    @IBAction func todayMonthView() {
        self.calendarView.toggleTodayMonthView()
    }
    
    /* Notifies the delegate when the presented date is updated so you can update CurrentMonth label. */
    func presentedDateUpdated(date: CVDate){
        self.dateLabel.text = date.description_str()
        setBgColor(date)
        
        // Add new month's schedules if needed
        let presented_month = date.year! * 100 + date.month!
        if presented_month < first_month_available {
            first_month_available = presented_month
            addMonthlySchedule(date.month!, year: date.year!)
        } else if presented_month > last_month_available {
            last_month_available = presented_month
            addMonthlySchedule(date.month!, year: date.year!)
        }
        
        // Scroll to presented Date
        if section_index_to_date.count == 0 {
            return
        }
        let nearest_section = getNearestSection(date.month!, year: date.year!)
        var nearest_index_path: NSIndexPath
        if nearest_section == section_index_to_date.count {
            nearest_index_path = NSIndexPath(forRow: 0, inSection: section_index_to_date.count-1)
            scheduleTableView.scrollToRowAtIndexPath(nearest_index_path, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        } else if nearest_section >= 0 {
            nearest_index_path = NSIndexPath(forRow: 0, inSection: nearest_section)
            scheduleTableView.scrollToRowAtIndexPath(nearest_index_path, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
    
    func getNearestSection(month: Int, year: Int) -> Int{
        var date_formatter = NSDateFormatter()
        for var i = 0; i < section_index_to_date.count; ++i {
            var date = section_index_to_date[i]
            var temp_month = (date % 10000) / 100
            var temp_year = date / 10000
            
            if temp_year >= year{
                if temp_year > year {
                    return i - 1
                } else {
                    if temp_month > month {
                        return i - 1
                    } else if temp_month == month{
                        return i
                    }
                }
            }
        }
        
        return section_index_to_date.count
    }
    
    /* Determines if a specific Day View should contain a topMarker. */
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    /* Determines if a dotMarker should move on its Day View highlighting. */
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    /* Determines whether a specific day view should be marked with dot marker or not. */
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        let date_key = dayView.date!.date_key()
        
        let event_list = schedules.objectForKey(date_key) as? Array<AyEvent>
        var family_member_list = self.appDelegate.data_manager!.cur_user?.familyMembers.allObjects
        
        let union = NSMutableSet()
        var colors : [UIColor] = []
        
        if event_list != nil {
            for event in event_list! {
                if event.participants != nil {
                    for member in event.participants!.allObjects {
                        var color = (member as! FamilyMember).assigned_color() as UIColor
                        colors.append (color)
                    }
                } else {
                    colors.append(UIColor.blueColor())
                }
                
                /*if event.participants != nil {
                    union.unionSet(event.participants! as Set<NSObject>)
                }*/
            }
            
            /*for person in union {
                colors.append (person.assigned_color())
            }*/
        }
        return colors
    }
    
     /* Determines a color for dot marker for a specific day view. */
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> UIColor {
        return UIColor.clearColor()
    }
}

