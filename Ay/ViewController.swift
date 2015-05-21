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
        
        self.calendarView.commitCalendarViewUpdate()
        self.menuView.commitMenuViewUpdate()
        
       self.dateLabel.text = self.calendarView.presentedDate?.description_str()
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
    
    /* Notifies the delegate when the presented date is updated so you can update CurrentMonth label. */
    func presentedDateUpdated(date: CVDate){
        self.dateLabel.text = self.calendarView.presentedDate?.description_str()
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

