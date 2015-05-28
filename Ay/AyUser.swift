
//
//  AyUser.swift
//  Ay
//
//  Created by Do Kwon on 5/27/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import Foundation
import CoreData

class AyUser: NSManagedObject {

    @NSManaged var first_name: String
    @NSManaged var last_name: String
    @NSManaged var object_id: String
    @NSManaged var familyMembers: NSMutableSet

    
    convenience init() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let entityDescription = NSEntityDescription.entityForName("AyUser", inManagedObjectContext: appDelegate.managedObjectContext!)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: appDelegate.managedObjectContext!)
    }
    
    
    func getFullName() -> String! {
        return self.first_name + " " + self.last_name
    }
}
