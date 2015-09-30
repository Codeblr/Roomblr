//
//  ParseClient.swift
//  Roomblr
//
//  Created by Jasen Salcido on 9/29/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit


class ParseClient {
    
    class var sharedInstance: ParseClient {
        struct Static {
            static let instance = ParseClient()
        }
        return Static.instance
    }

    // we use the logged in user blog from tumblr and the password can be hardcoded
    func setLoggedInParseUser(completion: (pfUser: PFUser?, error: NSError?) -> ()) {
        // set user
        PFUser.logInWithUsernameInBackground(User.currentUser!.blogName!, password: "12345678") { (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                User.currentUser!.parseUser = user
                completion(pfUser: user, error: nil)
            } else {
                completion(pfUser: nil, error: error)
            }
        }
    }

    func getParseUser(user: User, completition: (parseUser: ParseUser?, error: NSError?) -> ()) {
        var query = PFQuery(className: "ParseUser")
        query.whereKey("blogName", equalTo: user.blogName! as String)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let parseUsers = objects as? [ParseUser] {
                    for parseUser in parseUsers {
                        completition(parseUser: parseUser, error: nil)
                    }
                }
            } else {
                completition(parseUser: nil, error: error)
            }
        }
    }
    
    func saveParseUser(parseUser: ParseUser, completion: (parseUser: ParseUser?, error: NSError?) -> ()) {
        parseUser.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if succeeded {
                completion(parseUser: parseUser, error: nil)
            } else {
                completion(parseUser: nil, error: error)
            }
        }
    }
    
    
    
}