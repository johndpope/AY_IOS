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
    @NSManaged var name: String
    @NSManaged var parent: AyUser
    
    
    convenience init() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let entityDescription = NSEntityDescription.entityForName("FamilyMember", inManagedObjectContext: appDelegate.managedObjectContext!)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: appDelegate.managedObjectContext!)
    }
    
    let color_strs = ["blue", "green", "yellow", "gray", "orange", "purple"]
    let colors = [UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.grayColor(), UIColor.orangeColor(), UIColor.purpleColor()]
    
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


}
