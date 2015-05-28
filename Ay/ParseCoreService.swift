//
//  ParseCoreService.swift
//  Ay
//
//  Created by Ki Suk Jang on 5/9/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import Foundation

class ParseCoreService {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func createUser(email: String, password: String, first_name : String, last_name : String, birth : NSDate, family_members: Array<NSDictionary>) {
        let params = NSMutableDictionary()
        params.setObject(email, forKey: "Email" )
        params.setObject(password, forKey: "Password" )
        params.setObject(first_name, forKey: "First_Name" )
        params.setObject(last_name, forKey: "Last_Name" )
        params.setObject(birth, forKey: "Birth_Date" )
        params.setObject(family_members, forKey: "Fam_Members" )
        let installation = PFInstallation.currentInstallation()
        params.setObject(installation.installationId, forKey: "Device_Token")
        PFCloud.callFunctionInBackground("createUser", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                let new_id = result as! String
                let new_user = AyUser()
                new_user.object_id = new_id
                new_user.first_name = first_name
                new_user.last_name  = last_name
                self.appDelegate.data_manager!.cur_user = new_user
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func updateUser(first_name : String, last_name : String, birth: NSDate, family_members: NSMutableSet) {
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.object_id, forKey: "objectId" )
        params.setObject(first_name, forKey: "First_Name" )
        params.setObject(last_name, forKey: "Last_Name" )
        params.setObject(birth, forKey: "Birth_Date" )
        params.setObject(family_members, forKey: "Fam_Members" )
        PFCloud.callFunctionInBackground("updateUser", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                var curr_user = self.appDelegate.data_manager!.cur_user!
                curr_user.first_name = first_name
                curr_user.last_name = last_name
                curr_user.familyMembers = family_members
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func deleteUser(){
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.object_id, forKey: "objectId" )
        PFCloud.callFunctionInBackground("deleteUser", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                self.appDelegate.data_manager!.cur_user = nil
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func createEvent(target: String, title: String, start: NSDate, end: NSDate, alarm: NSDate?, recur_end: NSDate?, recur_freq: NSDictionary?, recur_occur: Int?){
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.object_id, forKey: "User_Id" )
        params.setObject(target, forKey: "Target_Name" )
        params.setObject(title, forKey: "Title" )
        params.setObject(start, forKey: "Start_Time" )
        params.setObject(end, forKey: "End_Time" )
        if alarm != nil {
            params.setObject(alarm!, forKey: "Alarm_Time" )
        }
        if recur_end != nil{
            params.setObject(recur_end!, forKey: "Recur_End" )
        }
        if recur_freq != nil {
            params.setObject(recur_freq!, forKey: "Recur_Freq" )
        }
        if recur_occur != nil {
            params.setObject(recur_occur!, forKey: "Recur_Occur" )
        }
        PFCloud.callFunctionInBackground("createEvent", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                let new_id = result as! String
                var new_event = AyEvent(id: new_id, target_name: target, start: start, end: end, title: title, alarm: alarm, recur_end: recur_end, recur_freq: recur_freq, recur_occur: recur_occur)
                self.appDelegate.data_manager!.events.append(new_event)
                NSNotificationCenter.defaultCenter().postNotificationName(notification_event_created, object: self)
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func deleteEvent(event_id: String){
        let params = NSMutableDictionary()
        params.setObject(event_id, forKey: "objectId" )
        PFCloud.callFunctionInBackground("deleteEvent", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                var del_index: Int?
                let del_id = result as! String
                for (index,event) in enumerate(self.appDelegate.data_manager!.events){
                    if event.id == del_id {
                        del_index = index
                        break
                    }
                }
                if(del_index != nil){
                    self.appDelegate.data_manager!.events.removeAtIndex(del_index!)
                    NSNotificationCenter.defaultCenter().postNotificationName(notification_event_deleted, object: self)
                }
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func updateEvent(event_id: String, target: String, title: String, start: NSDate, end: NSDate, alarm: NSDate?, recur_end: NSDate?, recur_freq: NSDictionary?, recur_occur: Int?){
        let params = NSMutableDictionary()
        params.setObject(event_id, forKey: "objectId" )
        params.setObject(target, forKey: "Target_Name" )
        params.setObject(title, forKey: "Title" )
        params.setObject(start, forKey: "Start_Time" )
        params.setObject(end, forKey: "End_Time" )
        if alarm != nil {
            params.setObject(alarm!, forKey: "Alarm_Time" )
        } else {
            params.setObject(NSNull(), forKey: "Alarm_Time" )
        }
        if recur_end != nil{
            params.setObject(recur_end!, forKey: "Recur_End" )
        } else {
            params.setObject(NSNull(), forKey: "Recur_End" )
        }
        if recur_freq != nil {
            params.setObject(recur_freq!, forKey: "Recur_Freq" )
        } else {
            params.setObject(NSNull(), forKey: "Recur_Freq" )
        }
        if recur_occur != nil {
            params.setObject(recur_occur!, forKey: "Recur_Occur" )
        } else {
            params.setObject(NSNull(), forKey: "Recur_Occur" )
        }
        PFCloud.callFunctionInBackground("updateEvent", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                var update_index: Int?
                let update_id = result as! String
                for (index,event) in enumerate(self.appDelegate.data_manager!.events){
                    if event.id == update_id {
                        event.target_name = target
                        event.title = title
                        event.start_time = start
                        event.end_time = end
                        event.alarm_time = alarm
                        event.recur_end = recur_end
                        event.recur_freq = recur_freq
                        event.recur_occur = recur_occur!
                    }
                }
                NSNotificationCenter.defaultCenter().postNotificationName(notification_event_updated, object: self)
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func getEvents(){
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.object_id, forKey: "User_Id" )
        PFCloud.callFunctionInBackground("getEvents", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                self.appDelegate.data_manager!.events = []
                
                var event_list = result as! NSArray
                for (var i = 0; i < event_list.count; i++){
                    var event = event_list[i] as! PFObject
                    var new_id = event.objectId!
                    var target = event["Target_Name"] as! String
                    var start = event["Start_Time"] as! NSDate
                    var end = event["End_Time"] as! NSDate
                    var title = event["Title"] as! String
                    var alarm : NSDate?
                    if event["Alarm_Time"] != nil {
                        alarm = event["Alarm_Time"] as? NSDate
                    }
                    var recur_end : NSDate?
                    if event["Recur_End"] != nil {
                        recur_end = event["Recur_End"] as? NSDate
                    }
                    var recur_freq : NSDictionary?
                    if event["Recur_Freq"] != nil {
                        recur_freq = event["Recur_Freq"] as? NSDictionary
                    }
                    var recur_occur : Int?
                    if event["Recur_Occur"] != nil {
                        recur_occur = event["Recur_Occur"] as? Int
                    }
                    var new_event = AyEvent(id: new_id, target_name: target, start: start, end: end, title: title, alarm: alarm, recur_end: recur_end, recur_freq: recur_freq, recur_occur: recur_occur!)
                    self.appDelegate.data_manager!.events.append(new_event)
                }
                NSNotificationCenter.defaultCenter().postNotificationName(notification_events_fetched, object: self)
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
            
            
        })
    }
}