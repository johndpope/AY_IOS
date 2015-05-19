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
    var target_name : String = ""
    var start_time : NSDate?
    var end_time : NSDate?
    var title : String = ""
    var alarm_time : NSDate?
    var recur_end : NSDate?
    var recur_freq : NSDictionary?
    var recur_occur : Int
    
    init(id: String, target_name: String, start: NSDate, end: NSDate, title: String, alarm: NSDate?, recur_end: NSDate?, recur_freq: NSDictionary?, recur_occur: Int){
        self.id = id
        self.target_name = target_name
        self.start_time = start
        self.end_time = end
        self.title = title
        self.alarm_time = alarm
        self.recur_end = recur_end
        self.recur_freq = recur_freq
        self.recur_occur = recur_occur
    }
}