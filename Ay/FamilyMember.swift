//
//  FamilyMember.swift
//  Ay
//
//  Created by Do Kwon on 5/27/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import Foundation
import CoreData


class FamilyMember: NSManagedObject {

    @NSManaged var age: NSNumber
    @NSManaged var color: String
    @NSManaged var gender: NSNumber
    @NSManaged var interests: String
    @NSManaged var first_name: String
    @NSManaged var last_name: String
    @NSManaged var type: String
    @NSManaged var parent: AyUser
    
    
    convenience init() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let entityDescription = NSEntityDescription.entityForName("FamilyMember", inManagedObjectContext: appDelegate.managedObjectContext!)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: appDelegate.managedObjectContext!)
    }
    
    let color_strs = ["blue", "green", "yellow", "red", "orange", "purple"]
    let colors = [UIColor(red:0.11, green:0.61,blue:0.89,alpha:1.0), UIColor(red:0.31, green:0.68,blue:0.33,alpha:1.0), UIColor(red:0.99, green:0.84,blue:0.28,alpha:1.0), UIColor(red:0.95, green:0.06,blue:0.35,alpha:1.0), UIColor(red:0.99, green:0.59,blue:0.15,alpha:1.0), UIColor(red:0.61, green:0.18,blue:0.68,alpha:1.0)]
    
    func assigned_color() -> UIColor {
        switch self.color {
        case color_strs[0] :
            return colors [0]
        case color_strs[1] :
            return colors [1]
        case color_strs[2] :
            return colors [2]
        case color_strs[3] :
            return colors [3]
        case color_strs[4] :
            return colors [4]
        case color_strs[5] :
            return colors [5]
        default :
            return colors [0]
        }
        
    }
    
    func toDictionary() -> NSDictionary {
        var dict = NSMutableDictionary()
        dict.setObject(age, forKey: "age")
        dict.setObject(color, forKey: "color")
        dict.setObject(gender, forKey: "gender")
        dict.setObject(interests, forKey: "interests")
        dict.setObject(type, forKey: "type")
        dict.setObject(first_name, forKey: "first_name")
        dict.setObject(last_name, forKey: "last_name")
        
        return dict
    }


}
