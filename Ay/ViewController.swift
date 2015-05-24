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

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBAction func settingsPressed(sender: AnyObject) {
    }
   
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var dateLabel: UILabel!
    private var schedules = NSMapTable()
    private var section_index_to_date = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.delegate   = self
        scheduleTableView.dataSource = self
        
        calendarView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshSchedule:", name: notification_events_fetched, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let app_delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // User data is already initialized
        if app_delegate.data_manager!.cur_user == nil && app_delegate.data_manager!.getCurrentUser() == nil {
            // Do login procedure
            self.performSegueWithIdentifier(login_segue_identifier, sender: self)
        } else {
            // Load the calendar view
            self.calendarView.commitCalendarViewUpdate()
            self.menuView.commitMenuViewUpdate()
            
           self.dateLabel.text = self.calendarView.presentedDate?.description_str()
            
            setBgColor(self.calendarView.presentedDate!)
        }
    }
    
    func refreshSchedule(notification: NSNotification){
        var new_schedules = self.appDelegate.data_manager!.getMonthlySchedule(5, year: 2015)
        
        scheduleTableView.beginUpdates()

        // Add sections to table view
        var temp_schedule = addSchedule(new_schedules)
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
        while let date: String = enumerator.nextObject() as? String {
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
        while let date: String = enumerator.nextObject() as? String {
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
        return 44
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
        cell!.timeView.text = NSDateFormatter.localizedStringFromDate(event.start_time!, dateStyle: .NoStyle, timeStyle: .ShortStyle) + " - " + NSDateFormatter.localizedStringFromDate(event.end_time!, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 23
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var dateView = UILabel(frame: CGRect(x: 15, y: 0, width: 200, height: 23))
        dateView.text = section_index_to_date[section]
        dateView.textAlignment = NSTextAlignment.Left
        dateView.textColor = UIColor.blackColor()
        var headerView = UIView()
        headerView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        headerView.addSubview(dateView)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*println ("NOT IMPLEMENTED YET")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(deal_detail_segue_identifer, sender: tableView)
        let row = indexPath.row*/
    }
    
    
    func addSchedule(new_schedule_map: NSMapTable) -> NSMapTable{
        var temp_schedule = schedules.copy() as! NSMapTable
        var enumerator = new_schedule_map.keyEnumerator()
        while let date: String = enumerator.nextObject() as? String {
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
        return false
    }
    
    /* Notifies the delegate when a specific day view is touched. */
    func didSelectDayView(dayView: CVCalendarDayView) {
        // TODO : Add individual schedules
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
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
     /* Determines a color for dot marker for a specific day view. */
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> UIColor {
        return UIColor.clearColor()
    }
}

