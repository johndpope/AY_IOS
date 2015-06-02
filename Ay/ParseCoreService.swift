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
    
    func createUser(first_name : String, last_name : String, family_members: NSMutableSet) {
        let params = NSMutableDictionary()
        params.setObject(first_name, forKey: "First_Name" )
        params.setObject(last_name, forKey: "Last_Name" )
        var family_json_array = Array<NSDictionary>()
        for object in family_members.allObjects{
            family_json_array.append((object as! FamilyMember).toDictionary())
        }
        params.setObject(family_json_array, forKey: "Fam_Members" )
        let installation = PFInstallation.currentInstallation()
        params.setObject(installation.installationId, forKey: "Installation_Id")
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
    
    func updateUser(first_name : String, last_name : String, family_members: NSMutableSet) {
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.object_id, forKey: "objectId" )
        params.setObject(first_name, forKey: "First_Name" )
        params.setObject(last_name, forKey: "Last_Name" )
        var family_json_array = Array<NSDictionary>()
        for object in family_members.allObjects{
            family_json_array.append((object as! FamilyMember).toDictionary())
        }
        params.setObject(family_json_array, forKey: "Fam_Members" )
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
    
    func createEvent(participants: NSMutableSet?, title: String, start: NSDate, end: NSDate, alarm: NSDate?, recur_end: NSDate?, recur_freq: NSDictionary?, recur_occur: Int?, location: String?, type: String?){
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.object_id, forKey: "User_Id" )
        if participants != nil {
            var participants_json_array = Array<NSDictionary>()
            for object in participants!.allObjects{
                participants_json_array.append((object as! FamilyMember).toDictionary())
            }
            params.setObject(participants_json_array, forKey: "Participants" )
        }
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
        if location != nil {
            params.setObject(location!, forKey: "Location")
        }
        if type != nil {
            params.setObject(type!, forKey: "Type")
        }
        PFCloud.callFunctionInBackground("createEvent", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                let data = result as! NSDictionary
                
                // Update channels
                let cur_install = PFInstallation.currentInstallation()
                let channel_dict = data["channels"] as? NSDictionary
                var channels: [String]?
                if channel_dict != nil {
                    channels = channel_dict!.allKeys as! [String]
                }
                if channels != nil {
                    for channel in channels!{
                        cur_install.addUniqueObject(channel, forKey: "channels")
                    }
                    cur_install.saveInBackground()
                }
                
                // Create new event locally
                let new_id = data["event_id"] as! String
                var new_event = AyEvent(id: new_id, participants: participants, start: start, end: end, title: title, alarm: alarm, recur_end: recur_end, recur_freq: recur_freq, recur_occur: recur_occur, location: location, type: type)
                self.appDelegate.data_manager!.events.append(new_event)
                NSNotificationCenter.defaultCenter().postNotificationName(notification_event_created, object: self)
                
                if channels != nil {
                    let params = NSMutableDictionary()
                    params.setObject(channels!, forKey: "Channels" )
                    PFCloud.callFunctionInBackground("getPush", withParameters: params as [NSObject : AnyObject], block: {
                        (result: AnyObject?, error: NSError?) -> Void in
                        if ( error == nil) {
                        
                        }
                    })
                }
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
    
    func updateEvent(event_id: String, participants: NSMutableSet?, title: String, start: NSDate, end: NSDate, alarm: NSDate?, recur_end: NSDate?, recur_freq: NSDictionary?, recur_occur: Int?, location: String?, type: String?){
        let params = NSMutableDictionary()
        params.setObject(event_id, forKey: "objectId" )
        if participants != nil {
            var participants_json_array = Array<NSDictionary>()
            for object in participants!.allObjects{
                participants_json_array.append((object as! FamilyMember).toDictionary())
            }
            params.setObject(participants_json_array, forKey: "Participants" )
        }
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
        if location != nil {
            params.setObject(location!, forKey: "Location" )
        } else {
            params.setObject(NSNull(), forKey: "Location" )
        }
        if type != nil {
            params.setObject(type!, forKey: "Type")
        } else {
            params.setObject(NSNull(), forKey: "Type")
        }
        PFCloud.callFunctionInBackground("updateEvent", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                var update_index: Int?
                let update_id = result as! String
                for (index,event) in enumerate(self.appDelegate.data_manager!.events){
                    if event.id == update_id {
                        event.participants = participants
                        event.title = title
                        event.start_time = start
                        event.end_time = end
                        event.alarm_time = alarm
                        event.recur_end = recur_end
                        event.recur_freq = recur_freq
                        event.recur_occur = recur_occur!
                        event.location = location
                        event.type = type
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
                    var participants : NSMutableSet?
                    if event["Participants"] != nil {
                        participants = NSMutableSet()
                        for object in (event["Participants"] as! Array<NSDictionary>){
                            var dict_obj = object as NSDictionary
                            var participant = FamilyMember()
                            participant.age = dict_obj["age"] as! NSNumber
                            participant.color = dict_obj["color"] as! String
                            participant.gender = dict_obj["gender"] as! NSNumber
                            participant.interests = dict_obj["interests"] as! String
                            participant.name = dict_obj["name"] as! String
                            participants?.addObject(participant)
                        }
                    }
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
                    var location : String?
                    if event["Location"] != nil {
                        location = event["Location"] as? String
                    }
                    var type : String?
                    if event["Type"] != nil {
                        type = event["Type"] as? String
                    }
                    var new_event = AyEvent(id: new_id, participants: participants, start: start, end: end, title: title, alarm: alarm, recur_end: recur_end, recur_freq: recur_freq, recur_occur: recur_occur!, location: location, type : type)
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