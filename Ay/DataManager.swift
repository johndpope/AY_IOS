//
//  DataManager.swift
//  Ay
//
//  Created by Do Kwon on 5/9/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import Foundation
import CoreData


class DataManager {
    var events : [AyEvent] = [AyEvent]()
    // Initialize cur_user on CoreData access/ login
    var cur_user : AyUser?
    let flags: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday
    
    let weekday_list : [String] = ["Sunday", "Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday"]
    
    
    /*func saveCurrentUser(id:String, first_name : String, last_name : String, email :String) {
        let app_delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = app_delegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("AyUser", inManagedObjectContext: managedContext)
        
        let user = NSManagedObject(entity : entity!, insertIntoManagedObjectContext:managedContext)
        
        user.setValue(first_name, forKey: "first_name")
        user.setValue(last_name, forKey: "last_name")
        user.setValue(email, forKey: "email")
        user.setValue(id, forKey: "id")
        
        var error : NSError?
        if !managedContext.save(&error) {
            println ("Could not save \(error), \(error?.userInfo)")
        } else {
            self.cur_user!.first_name = first_name
            self.cur_user!.last_name = last_name
            self.cur_user!.email = email
            self.cur_user!.Object_Id = id
            println ("Current user successfully saved.")
        }
    }*/
    
    
    
    func getFamilyMembers () {
        let app_delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = app_delegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"FamilyMember")
        
        var error : NSError?
        
        let fetched_results = managedContext.executeFetchRequest(fetchRequest, error:&error) as? [NSManagedObject]
        
        if let results = fetched_results {
            
            if results.count == 0 {
                return
            }
            for member in results {
                 self.cur_user!.familyMembers.addObject(member)
            }
            
        } else {
            println ("Could not fetch \(error), \(error?.userInfo)")
        }
    }
    
        
    
    func getCurrentUser() -> AyUser? {
        let app_delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = app_delegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"AyUser")
        
        var error : NSError?
        
        let fetched_results = managedContext.executeFetchRequest(fetchRequest, error:&error) as? [NSManagedObject]
        
        if let results = fetched_results {
            
            if results.count == 0 {
                return nil
            }
            self.cur_user = results[0] as? AyUser
            getFamilyMembers()
            
        } else {
            println ("Could not fetch \(error), \(error?.userInfo)")
        }
        return self.cur_user
    }
    
    var repeat_none_options: [String] = ["Never"]
    var repeat_options: [String] = ["Every Day", "Every Week", "Every Other Week", "Every Month", "Every Year"]
    var notify_none_options: [String] = ["None"]
    var notify_options: [String] = ["At the time of event", "5 minutes before", "10 minutes before", "15 minutes before", "30 minutes before", "1 hour before", "2 hours before", "1 day before", "2 days before", "1 week before"]
    
    func getEvent(event_id : String) -> AyEvent {
        for event in events{
            if event.id == event_id{
                return event
            }
        }
        return AyEvent()
    }
    
    func getMonthlySchedule(month: Int, year: Int) -> NSMapTable {
        var monthly_schedule = NSMapTable()
        for event in events{
            let start_components = NSCalendar.currentCalendar().components(flags, fromDate: event.start_time!)
            let end_components = NSCalendar.currentCalendar().components(flags, fromDate: event.end_time!)
            
            // Event has no recurrance
            if event.recur_freq == nil {
                if isInThisMonth(start_components, end_components: end_components, month: month, year: year) {
                    monthly_schedule = addEvent(monthly_schedule, new_event: event)
                }
            
            // Event has recurrance
            } else {
                
                // Event starts before or during this month
                if start_components.year < year || (start_components.year == year && start_components.month <= month) {
                    
                    // Add event if it starts this month
                    if isInThisMonth(start_components, end_components: end_components, month: month, year: year) {
                        monthly_schedule = addEvent(monthly_schedule, new_event: event)
                    }
                    
                    // Event has occurance limit
                    if event.recur_end == nil {
                        var index = 1
                        var next_start_date = event.start_time!
                        var next_end_date = event.end_time!
                        while (event.recur_occur > 0 && event.recur_occur > index) || (event.recur_occur == 0 && index == 1) {
                            next_start_date = getNextOccurance(next_start_date, freq_dict: event.recur_freq!)
                            next_end_date = getNextOccurance(next_end_date, freq_dict: event.recur_freq!)
                            var next_start_components = NSCalendar.currentCalendar().components(flags, fromDate: next_start_date)
                            var next_end_components = NSCalendar.currentCalendar().components(flags, fromDate: next_end_date)
                            
                            // next event belongs to this month
                            if isInThisMonth(next_start_components, end_components: next_end_components, month: month, year: year) {
                                var schedule = AyEvent(id: event.id, participants: event.participants, start: next_start_date, end: next_end_date, title: event.title, alarm: event.alarm_time, recur_end: event.recur_end, recur_freq: event.recur_freq, recur_occur: event.recur_occur, latitude: event.latitude, longitude: event.longitude)
                                    monthly_schedule = addEvent(monthly_schedule, new_event: schedule)
                            
                            // next event pass this month
                            } else if next_start_components.year > year || (next_start_components.year == year && next_start_components.month > month) {
                                if event.recur_occur > 0 {
                                    index = event.recur_occur
                                } else {
                                    index++
                                }
                            }
                            
                            // increment index for limited occurance
                            if event.recur_occur > 0 {
                                index++
                            }

                        }
                    
                    // Event has limit date
                    } else {
                        let recur_components = NSCalendar.currentCalendar().components(flags, fromDate: event.recur_end!)
                        if recur_components.year > year || (recur_components.year == year && recur_components.month >= month){
                            var next_start_date = event.start_time!
                            var next_end_date = event.end_time!
                            var next_start_components = NSCalendar.currentCalendar().components(flags, fromDate: next_start_date)
                            var next_end_components = NSCalendar.currentCalendar().components(flags, fromDate: next_end_date)
                            //Loop while under recurrence end date
                            while recur_components.year > next_start_components.year || (recur_components.year == next_start_components.year && recur_components.month > next_start_components.month) || (recur_components.year == next_start_components.year && recur_components.month == next_start_components.month && recur_components.day >= next_start_components.day){
                                next_start_date = getNextOccurance(next_start_date, freq_dict: event.recur_freq!)
                                next_end_date = getNextOccurance(next_end_date, freq_dict: event.recur_freq!)
                                next_start_components = NSCalendar.currentCalendar().components(flags, fromDate: next_start_date)
                                next_end_components = NSCalendar.currentCalendar().components(flags, fromDate: next_end_date)
                                
                                // next event belongs to this month
                                if isInThisMonth(next_start_components, end_components: next_end_components, month: month, year: year){
                                    var schedule = AyEvent(id: event.id, participants: event.participants, start: next_start_date, end: next_end_date, title: event.title, alarm: event.alarm_time, recur_end: event.recur_end, recur_freq: event.recur_freq, recur_occur: event.recur_occur, latitude: event.latitude, longitude: event.longitude)
                                    monthly_schedule = addEvent(monthly_schedule, new_event: schedule)
                                    
                                // next event pass this month
                                } else if next_start_components.year > year || (next_start_components.year == year && next_start_components.month > month) {
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
        return monthly_schedule
    }
    
    func isInThisMonth(start_components: NSDateComponents, end_components: NSDateComponents, month: Int, year: Int) -> Bool{
        if (start_components.year < year || (start_components.year == year && start_components.month <= month)) && (end_components.year > year || (end_components.year == year && end_components.month >= month)) {
            return true
        }
        return false
    }
    
    func getNextOccurance(start_date: NSDate, freq_dict: NSDictionary) ->NSDate {
        var components = NSCalendar.currentCalendar().components(flags, fromDate: start_date)
        var base = freq_dict["base"] as! String
        if base == "daily"{
            var inc = 1
            if freq_dict["every_other"] != nil {
                inc = freq_dict["every_other"] as! Int
            }
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: inc, toDate: start_date, options: nil)!
        } else if base == "weekly"{
            var day_list = freq_dict["days_of_week"] as! Array<NSDictionary>
            for var index = 0; index < day_list.count-1; ++index{
                if components.weekday == (day_list[index]["day"] as! Int){
                    var inc = (day_list[index+1]["day"] as! Int) - (day_list[index]["day"] as! Int)
                    return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: inc, toDate: start_date, options: nil)!
                }
            }
            
            // currently last day of day_list
            var inc = 0
            if freq_dict["every_other"] != nil {
                inc = 7 * ((freq_dict["every_other"] as! Int) - 1)
            }
            var next_day = day_list[0]["day"] as! Int
            var last_day = day_list[0]["day"] as! Int
            if day_list.count > 1 {
                last_day = day_list[day_list.count - 1]["day"] as! Int
            }
            inc += (7 - last_day) + next_day
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: inc, toDate: start_date, options: nil)!
        } else if base == "monthly" {
            var month_inc = 1
            if freq_dict["every_other"] != nil {
                month_inc = freq_dict["every_other"] as! Int
            }
            
            if freq_dict["days_of_week"] != nil {
                //Get first day of month
                var first_date = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMonth, value: month_inc, toDate: start_date, options: nil)!
                var first_components = NSCalendar.currentCalendar().components(flags, fromDate: first_date)
                first_components.day = 1
                first_date = NSCalendar.currentCalendar().dateFromComponents(first_components)!
                first_components = NSCalendar.currentCalendar().components(flags, fromDate: first_date)
                
                var day_list = freq_dict["days_of_week"] as! Array<NSDictionary>
                var target_day_obj = day_list[0]
                var target_week = target_day_obj["week"] as! Int
                var target_day = target_day_obj["day"] as! Int
                var day_inc: Int
                if target_day > first_components.weekday{
                    day_inc = target_day - first_components.weekday
                } else {
                    day_inc = (7 - first_components.weekday) + target_day
                }
                var week_inc = target_week - 1
                var next_date = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: day_inc + week_inc * 7, toDate: first_date, options: nil)!
                var next_components = NSCalendar.currentCalendar().components(flags, fromDate: next_date)
                if next_components.month == first_components.month{
                    return next_date
                } else {
                    return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: day_inc + (week_inc-1) * 7, toDate: first_date, options: nil)!
                }

            } else {
                var day_list = freq_dict["days_of_month"] as! Array<Int>
                for var index = 0; index < day_list.count-1; ++index{
                    if components.day == day_list[index]{
                        var day_inc = day_list[index+1] - day_list[index]
                        return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: day_inc, toDate: start_date, options: nil)!
                    }
                }
                
                var next_date = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMonth, value: month_inc, toDate: start_date, options: nil)!
                
                // Change day if needed
                if day_list.count > 1{
                    var next_components = NSCalendar.currentCalendar().components(flags, fromDate: next_date)
                    next_components.day = day_list[0]
                    next_date = NSCalendar.currentCalendar().dateFromComponents(next_components)!
                }
                return next_date
            }
        } else {
            var year_inc = 1
            if freq_dict["every_other"] != nil {
                year_inc = freq_dict["every_other"] as! Int
            }
            return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitYear, value: year_inc, toDate: start_date, options: nil)!
        }
    }
    
    func addEvent(event_map : NSMapTable, new_event: AyEvent) -> NSMapTable{
        var date_components = NSCalendar.currentCalendar().components(flags, fromDate: new_event.start_time!)
        var date = date_components.year * 10000 + date_components.month * 100 + date_components.day
        //var date = NSDateFormatter.localizedStringFromDate(new_event.start_time!, dateStyle: .ShortStyle, timeStyle: .NoStyle) as String
        var event_list = event_map.objectForKey(date) as? Array<AyEvent>
        if event_list == nil {
            event_list = Array<AyEvent>()
        }
        event_list!.append(new_event as AyEvent)
        event_map.setObject(event_list!, forKey: date)
        return event_map
    }

}