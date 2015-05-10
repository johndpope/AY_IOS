//
//  DataManager.swift
//  Ay
//
//  Created by Do Kwon on 5/9/15.
//  Copyright (c) 2015 Do Kwon. All rights reserved.
//

import Foundation


class DataManager {
    var events : [AyEvent] = [AyEvent]()
    // Initialize cur_user on CoreData access/ login
    var cur_user : AyUser?
}