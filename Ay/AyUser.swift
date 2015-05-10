
//
//  AyUser.swift
//  Ay
//
//  Created by Do Kwon on 5/9/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import Foundation



/* Singleton class definition for Ay current user. Singleton instance contained in  
 * AppDelegate
 */
class AyUser {
    var Object_Id: String = ""
    var User_Id : String = ""
    var First_Name : String = ""
    var Last_Name : String = ""
    var Birth_Date  : NSDate? = nil
    var Family_Members : NSDictionary? = nil
        
    init (first_name:String, last_name:String) {
        self.First_Name = first_name
        self.Last_Name = last_name
    }
    
    required init!(coder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getFullName() -> String! {
        return self.First_Name + " " + self.Last_Name
    }
}