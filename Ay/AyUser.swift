
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
    var email : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var birth_date  : NSDate? = nil
    var family_members : Array<NSDictionary>!
        
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
}