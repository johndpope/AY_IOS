//
//  SyncCalendarViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/23/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit
import EventKit

class SyncCalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var importTableView: UITableView!
    var events_access_granted : Bool = false
    
    @IBAction func facebook_sync_pressed(sender: AnyObject) {
    }
    @IBAction func sync_paper_cal_pressed(sender: AnyObject) {
    }
    @IBAction func sync_gcal_pressed(sender: AnyObject) {
    }
    func sync_ical_pressed() {
        // Ask for user permission first
        
        let event_defaults_key = "eventkit_events_access_granted"
        
        let event_store = EKEventStore()
        
        let user_defaults = NSUserDefaults.standardUserDefaults()
        
        if user_defaults.valueForKey( event_defaults_key) != nil {
            
            println("Debug!!")
            self.events_access_granted = user_defaults.valueForKey(event_defaults_key) as! Bool
        }
        
        var schedules = NSMutableDictionary()
        
        
        

        
        // Ask for permission again for some other crap
        event_store.requestAccessToEntityType(EKEntityTypeEvent, completion:{
            granted, error in
            if error == nil {
                self.events_access_granted = granted
                
                // Set permission in user defaults
                user_defaults.setValue(NSNumber(bool: self.events_access_granted), forKey: event_defaults_key)
                
                // get calendars
                let all_calendars = event_store.calendarsForEntityType(EKEntityTypeEvent)
                
                
                let start_date = NSCalendar.currentCalendar().dateByAddingUnit(
                    NSCalendarUnit.CalendarUnitYear,
                    value: -1,
                    toDate: NSDate(),
                    options: NSCalendarOptions.WrapComponents)
                let end_date = NSCalendar.currentCalendar().dateByAddingUnit(
                    NSCalendarUnit.CalendarUnitYear,
                    value: +1,
                    toDate: NSDate(),
                    options: NSCalendarOptions.WrapComponents)
                
                let predicate = event_store.predicateForEventsWithStartDate(start_date, endDate: end_date, calendars: all_calendars)
                
                event_store.enumerateEventsMatchingPredicate(predicate, usingBlock:{
                    (event:EKEvent!, stop:UnsafeMutablePointer<ObjCBool>) in
                    
                    if (event.title != nil
                        && event.calendar != nil
                        
                        && event.calendar.calendarIdentifier != nil
                        && event.lastModifiedDate != nil
                        ){
                            println (event)
                            var new_event = AyEvent()
                            
                            
                            new_event.title = event.title
                            
                            if event.alarms != nil {
                                
                            }
                            /*if event.location != nil {
                                new_event.location = event.location
                            }*/
                            
                            if event.startDate != nil {
                                new_event.start_time = event.startDate
                            }
                            if event.endDate != nil {
                                new_event.end_time = event.endDate
                            }
                            
                            
                            
                            
                            /*id : String = ""
                            var target_name : String = ""
                            var start_time : NSDate?
                            var end_time : NSDate?
                            var title : String = ""
                            var alarm_time : NSDate?
                            var recur_end : NSDate?
                            var recur_freq : NSDictionary?
                            var recur_occur : Int
                            var participants : NSMutableSet?
                            var type : String?*/
                            
                            ParseCoreService().createEvent(new_event.target_name, title: new_event.title, start: new_event.start_time!, end: new_event.end_time!, alarm: nil, recur_end: nil, recur_freq: nil, recur_occur: 0)
                            
                            
                    }
                    
                    //......
                })// end block
                /*
                // Start date of schedules to be imported ; for now, we just do a year prior.
                let start_date = NSCalendar.currentCalendar().dateByAddingUnit(
                    NSCalendarUnit.CalendarUnitYear,
                    value: -1,
                    toDate: NSDate(),
                    options: NSCalendarOptions.WrapComponents)
                let end_date = NSCalendar.currentCalendar().dateByAddingUnit(
                    NSCalendarUnit.CalendarUnitYear,
                    value: +1,
                    toDate: NSDate(),
                    options: NSCalendarOptions.WrapComponents)
                
                
                
                
                
                //println (all_calendars)
                let current = NSDate(timeInterval: 0, sinceDate: start_date!)
                
                // enumerate events by one year segment because ios does not support predicate longer than 4 years
                while (current.compare(end_date!) == NSComparisonResult.OrderedAscending) {
                    
                    let num_days_in_year = NSCalendar.currentCalendar().rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitYear, forDate: current)
                    let seconds_in_year = 60 * 60 * Int(num_days_in_year)
                    
                    
                    let predicate = event_store.predicateForEventsWithStartDate(current, endDate: end_date, calendars: all_calendars)
                    
                    event_store.enumerateEventsMatchingPredicate(predicate, usingBlock:{
                        (event:EKEvent!, stop:UnsafeMutablePointer<ObjCBool>) in
                        if event != nil {
                            schedules.addObject(event, forKey: event.eventIdentifier)
                        }
                        println(event)
                    
                    })
                    
                    current = NSDate(timeInterval: seconds_in_year + 1, sinceDate: start_date!)
                }
                
                
             */

                
            } else {
                println (error.localizedDescription)
            }
        })
        
        
        
        
        
        
        /*let event_store = EKEventStore()
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
        case .Authorized :
            insertEvent(event_store)
        case .Denied:
            
        case .Notdetermined:
            
        }*/
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.importTableView.delegate = self
        self.importTableView.dataSource = self
        
        // Add to db using parsecoreservice
        ParseCoreService().createUser("", last_name : "", family_members: NSMutableSet())
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
        return 5
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(import_ical_cell_identifier) as? UITableViewCell
        } else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier(import_google_cal_cell_identifier) as? UITableViewCell
        } else if indexPath.row == 2{
            cell = tableView.dequeueReusableCellWithIdentifier(import_paper_cell_identifier) as? UITableViewCell
        } else if indexPath.row == 3 {
            cell = tableView.dequeueReusableCellWithIdentifier(import_facebook_cell_identifier) as? UITableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(import_none_cell_identifier) as? UITableViewCell
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            // ICAL
            sync_ical_pressed()
            
        } else if indexPath.row == 1 {
            // GCAL
        } else if indexPath.row == 2{
            // PAPER
        } else if indexPath.row == 3 {
            // FACEBOOK
            
        } else {
            // DO NOTHING
        }

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
