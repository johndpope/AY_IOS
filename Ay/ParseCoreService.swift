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
    
    func createUser(email: String, password: String, first_name : String, last_name : String, birth : String, family_members: NSDictionary) {
        let params = NSMutableDictionary()
        params.setObject(email, forKey: "User_Id" )
        params.setObject(first_name, forKey: "First_Name" )
        params.setObject(last_name, forKey: "Last_Name" )
        params.setObject(birth, forKey: "Birth_Date" )
        params.setObject(family_members, forKey: "Fam_Members" )
        PFCloud.callFunctionInBackground("createUser", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                NSLog("success: \(result) ")
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func updateUser(first_name : String, last_name : String) {
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.Object_Id, forKey: "objectId" )
        params.setObject(first_name, forKey: "First_Name" )
        params.setObject(last_name, forKey: "Last_Name" )
        PFCloud.callFunctionInBackground("updateUser", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                NSLog("success: \(result) ")
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func deleteUser(){
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.Object_Id, forKey: "objectId" )
        PFCloud.callFunctionInBackground("deleteUser", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                NSLog("success: \(result) ")
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func addFamily(member_list: [String]){
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.Object_Id, forKey: "objectId" )
        params.setObject(member_list, forKey: "Fam_Members" )
        PFCloud.callFunctionInBackground("addFamily", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                NSLog("success: \(result) ")
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func getFamily(){
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.Object_Id, forKey: "objectId" )
        PFCloud.callFunctionInBackground("getFamily", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                NSLog("success: \(result) ")
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func createEvent(target: String, title: String, start: NSDate, end: NSDate, alarm: NSDate, recur_end: NSDate, recur_int: NSDictionary, recur_days: Array<Int>){
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.Object_Id, forKey: "User_Id" )
        params.setObject(target, forKey: "Target_Name" )
        params.setObject(title, forKey: "Title" )
        params.setObject(start, forKey: "Start_Time" )
        params.setObject(end, forKey: "End_Time" )
        params.setObject(alarm, forKey: "Alarm_Time" )
        params.setObject(recur_end, forKey: "Recur_End" )
        params.setObject(recur_int, forKey: "Recur_Int" )
        params.setObject(recur_days, forKey: "Recur_Days" )
        PFCloud.callFunctionInBackground("createEvent", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                NSLog("success: \(result) ")
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
                NSLog("success: \(result) ")
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func updateEvent(target: String, title: String, start: NSDate, end: NSDate, alarm: NSDate, recur_end: NSDate, recur_int: NSDictionary, recur_days: Array<Int>){
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.Object_Id, forKey: "User_Id" )
        params.setObject(target, forKey: "Target_Name" )
        params.setObject(title, forKey: "Title" )
        params.setObject(start, forKey: "Start_Time" )
        params.setObject(end, forKey: "End_Time" )
        params.setObject(alarm, forKey: "Alarm_Time" )
        params.setObject(recur_end, forKey: "Recur_End" )
        params.setObject(recur_int, forKey: "Recur_Int" )
        params.setObject(recur_days, forKey: "Recur_Days" )
        PFCloud.callFunctionInBackground("updateEvent", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                NSLog("success: \(result) ")
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
    
    func getEvents(){
        let params = NSMutableDictionary()
        params.setObject(appDelegate.data_manager!.cur_user!.Object_Id, forKey: "User_Id" )
        PFCloud.callFunctionInBackground("getEvents", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            if ( error == nil) {
                NSLog("success: \(result) ")
            }
            else if (error != nil) {
                NSLog("error: \(error!.userInfo)")
            }
        })
    }
}