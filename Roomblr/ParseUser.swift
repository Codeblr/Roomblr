//
//  PFUser.swift
//  Roomblr
//
//  Created by Jasen Salcido on 9/29/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

/*
    ParseUser is the current data we will store in Parse
    Currently we just need to store the blogNames of all users who have used this app
*/

class ParseUser: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "ParseUser"
    }
    
    @NSManaged var blogName: String
}