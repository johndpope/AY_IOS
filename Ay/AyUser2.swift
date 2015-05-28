//
//  AyUser.swift
//  Ay
//
//  Created by Do Kwon on 5/25/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import Foundation

/* Singleton class definition for Ay current user. Singleton instance contained in
* AppDelegate
*/
class AyUser2 {
    var Object_Id: String = ""
    var email : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var birth_date  : NSDate? = nil
    var family_members : Array<NSDictionary>? = []
    
    init (id: String, email: String, password: String, first_name:String, last_name:String, birth_date: NSDate, family_members: Array<NSDictionary>) {
        self.Object_Id = id
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.birth_date = birth_date
        self.family_members = family_members
    }
    
    required init!(coder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getFullName() -> String! {
        return self.first_name + " " + self.last_name
    }

    
    let color_strs = ["blue", "green", "yellow", "gray", "orange", "purple"]
    let colors = [UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.grayColor(), UIColor.orangeColor(), UIColor.purpleColor()]
    
    func color_for_family_member(member : NSDictionary) -> UIColor {
        switch member["color"] as! String {
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
