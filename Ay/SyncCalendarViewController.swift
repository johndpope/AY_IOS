//
//  SyncCalendarViewController.swift
//  Ay
//
//  Created by Do Kwon on 5/23/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import UIKit
import EventKit

class SyncCalendarViewController: UIViewController {

    var events_access_granted : Bool = false
    
    @IBAction func facebook_sync_pressed(sender: AnyObject) {
    }
    @IBAction func sync_paper_cal_pressed(sender: AnyObject) {
    }
    @IBAction func sync_gcal_pressed(sender: AnyObject) {
    }
    @IBAction func sync_ical_pressed(sender: AnyObject) {
        // Ask for user permission first
        
        let event_defaults_key = "eventkit_events_access_granted"
        
        let event_store = EKEventStore()
        
        let user_defaults = NSUserDefaults.standardUserDefaults()
        
        if user_defaults.valueForKey( event_defaults_key) != nil {
            self.events_access_granted = (user_defaults.valueForKey(event_defaults_key) as! String).toInt() == 1 ? true : false
        }
        
        // Ask for permission again for some other crap
        event_store.requestAccessToEntityType(EKEntityTypeEvent, completion:{
            granted, error in
            if error == nil {
                self.events_access_granted = granted
            } else {
                println (error.localizedDescription)
            }
        })
        
        // Set permission in user defaults
        user_defaults.setValue(NSNumber(bool: events_access_granted), forKey: event_defaults_key)
        
        // get calendars
        let all_calendars = event_store.calendarsForEntityType(EKEntityTypeEvent)
        
        println (all_calendars)
        
        
        
        
        
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
        
        // Add to db using parsecoreservice
        ParseCoreService().createUser("", password: "", first_name : "PlaceHolder", last_name : "", birth : NSDate(), family_members: Array<NSDictionary>())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
