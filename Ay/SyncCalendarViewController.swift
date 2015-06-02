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
    
    
    @IBOutlet weak var tableView: UITableView!
    func display_beta_unavailability() {
        let alertController = UIAlertController(title: "Not ready yet!", message: "Adding this integration is not yet available in beta mode. Look for ical maybe?", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
            
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }

    }
    
    
    @IBAction func integration_sync_pressed(sender: UIButton) {
         display_beta_unavailability()
    }
    
    @IBAction func sync_paper_cal_pressed(sender: UIButton) {
         display_beta_unavailability()
    }
    @IBAction func sync_gcal_pressed(sender: UIButton) {
         display_beta_unavailability()
    }
    
    @IBAction func sync_ical_pressed(sender: UIButton) {
        importing_calendar = true
        
        let queue = NSOperationQueue()
        dark_view = UIView(frame: self.view.frame )
        
        queue.addOperationWithBlock() {
            // do something in the background
            self.download_ical()
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                // when done, update your UI and/or model on the main queue
                println ("finished with everything")
                sleep(4)
                self.dark_view!.removeFromSuperview()
                
                let alertController = UIAlertController(title: "Success!", message: "We imported your schedule from ical.", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                    
                    let selected_img = UIImage(named:"connected.png")
                    
                    sender.setImage(selected_img, forState: UIControlState.Normal)
                    sender.frame = CGRectMake(sender.frame.origin.x - (81 - 66), sender.frame.origin.y,  81 , 25)
                   sender.center = sender.superview!.center
                    sender.userInteractionEnabled = false
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
            }
        }
        
        disableUserInteraction()
        
    }
    func download_ical() {
        // Ask for user permission first
        println ("goes in here")
        let event_defaults_key = "eventkit_events_access_granted"
        
        let event_store = EKEventStore()
        
        let user_defaults = NSUserDefaults.standardUserDefaults()
        
        if user_defaults.valueForKey( event_defaults_key) != nil {
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
                            //println (event)
                            var new_event = AyEvent()
                            new_event.title = event.title
                            
                            if event.alarms != nil {
                                
                            }
                            
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
                            
                            ParseCoreService().createEvent(new_event.participants, title: new_event.title, start: new_event.start_time!, end: new_event.end_time!, alarm: nil, recur_end: nil, recur_freq: nil, recur_occur: 0, location: new_event.location, type: new_event.type)
                            
                            
                    }
                })// end block
            } else {
                println (error.localizedDescription)
            }
            println ("Finished importing ical data")
        })
        
        /*let event_store = EKEventStore()
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
        case .Authorized :
        insertEvent(event_store)
        case .Denied:
        
        case .Notdetermined:
        
        }*/
        
        self.importing_calendar = false
    }
    
  
   
    
    var importing_calendar = false
    var dark_view : UIView?

    func disableUserInteraction () {
        
        dark_view!.backgroundColor = UIColor.whiteColor()
        dark_view!.alpha = 0.1
        self.view.addSubview (dark_view!)
        
        let logo = UIImage(named : "logo.png")
        let imageView = UIImageView(image: logo)
        imageView.frame = CGRect(x :110, y: 122, width: 155, height: 186)
        imageView.alpha = 0.1
        dark_view!.addSubview (imageView)
        
        
        let loading_label = UILabel (frame : CGRectMake (100 ,400, 300, 50))
        loading_label.text = "Importing data from ical... "
        dark_view!.addSubview (loading_label)
        
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.dark_view!.alpha = 1
            imageView.alpha = 1
        })
        
        let main_queue = NSOperationQueue.mainQueue()
        while self.importing_calendar {
            println ("looping!!")
            
            
            main_queue.addOperationWithBlock() {
                // when done, update your UI and/or model on the main queue
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    imageView.alpha = 1
                })
                main_queue.addOperationWithBlock() {
                    // when done, update your UI and/or model on the main queue
                    UIView.animateWithDuration(1.0, animations: { () -> Void in
                        imageView.alpha = 0.1
                    })
                }
                
            }
            sleep(1)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.importTableView.delegate = self
        self.importTableView.dataSource = self
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        // Add to db using parsecoreservice
        ParseCoreService().createUser("", last_name : "", family_members: NSMutableSet())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Table view Datasource / delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    let integration_titles = ["Tripit", "Asana", "Wunderlist", "Todolist", "Google Tasks", "Trello", "Evernote", "Basecamp"]
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return integration_titles.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if section == 0{
            return "Calendars"
        }
        return "Other Integrations"
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier(integration_cell_identifier) as? UITableViewCell
            cell!.textLabel!.text = integration_titles [indexPath.row]
        } else {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier(import_ical_cell_identifier) as? UITableViewCell
            } else if indexPath.row == 1 {
                cell = tableView.dequeueReusableCellWithIdentifier(import_google_cal_cell_identifier) as? UITableViewCell
            } else if indexPath.row == 2{
                cell = tableView.dequeueReusableCellWithIdentifier(import_paper_cell_identifier) as? UITableViewCell
            }
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            //sync_ical_pressed(sync_ical_btn)
        } else {
            display_beta_unavailability()
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
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