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

    @IBAction func settingsPressed(sender: AnyObject) {
    }
   
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.delegate   = self
        scheduleTableView.dataSource = self
        
        calendarView.delegate = self
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let app_delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // User data is already initialized
        if app_delegate.data_manager!.getCurrentUser() == nil {
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

    var schedules = []
    
    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(schedule_cell_identifier, forIndexPath: indexPath)as? ScheduleTableViewCell
        if (cell == nil) {
            cell = ScheduleTableViewCell (style: UITableViewCellStyle.Default, reuseIdentifier: schedule_cell_identifier)
        }
        let row = indexPath.row
        return cell!
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*println ("NOT IMPLEMENTED YET")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(deal_detail_segue_identifer, sender: tableView)
        let row = indexPath.row*/
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

