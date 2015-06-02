//
//  AyEvent.swift
//  Ay
//
//  Created by Do Kwon on 5/9/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
// 
//  Defines the Events model of Ay
//

import Foundation


class AyEvent {
    var id : String = ""
    var start_time : NSDate?
    var end_time : NSDate?
    var title : String = ""
    var location: String?
    var alarm_time : NSDate?
    var recur_end : NSDate?
    var recur_freq : NSDictionary?
    var recur_occur : Int
    
    
    // TODO: add to parsecoreservice
    var participants : NSMutableSet?
    var type : String?
    var location : String?
    
    
    init () {
        self.id = ""
        self.participants = nil
        self.start_time = nil
        self.end_time = nil
        self.title = ""
        self.alarm_time = nil
        self.recur_end = nil
        self.recur_freq = nil
        self.recur_occur = -1
        self.location = nil
    }
    
    init(id: String, participants: NSMutableSet?, start: NSDate, end: NSDate, title: String, alarm: NSDate?, recur_end: NSDate?, recur_freq: NSDictionary?, recur_occur: Int?, location: String?){
        self.id = id
        self.start_time = start
        self.end_time = end
        self.title = title
        self.alarm_time = alarm
        self.recur_end = recur_end
        self.recur_freq = recur_freq
        self.recur_occur = recur_occur!
        self.participants = participants
        self.location = location
    }
    
    
    
    func dateAsString(date : NSDate) ->String {
        return  NSDateFormatter.localizedStringFromDate(date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
    }
}