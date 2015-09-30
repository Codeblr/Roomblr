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
    
    /*********************** PF USER **************************/
    
    // query PFUser table with user blogname
    func checkIfUserExists(user: User, completion: (pfUser: PFUser?, error: NSError?) -> ()) {
        var query = PFQuery(className: "PFUser")
        query.whereKey("username", equalTo: user.blogName! as String)
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            var pfUser: PFUser?
            if error == nil {
                // if there is at least one object, assume the only item in here should be the user we are looking for
                if objects!.count > 0 {
                    pfUser = objects![0] as! PFUser
                }
                completion(pfUser: pfUser, error: nil)
            } else {
                print("ERROR: Could not query for PFUser")
                completion(pfUser: nil, error: error)
            }
        }
    }
    
    // log in the pfUser
    func logInPFUser(user: PFUser, completion: (pfUser: PFUser?, error: NSError?) -> ()) {
        
        // set user
        PFUser.logInWithUsernameInBackground(user.username!, password: "12345678") { (pfUser: PFUser?, error: NSError?) -> Void in
            if error == nil {
                completion(pfUser: pfUser, error: nil)
            } else {
                print("ERROR: Could not log in PFUser")
                completion(pfUser: nil, error: error)
            }
        }
    }
    
    // create pfUser
    func createPFUser(user: User, completion: (pfUser: PFUser?, error: NSError?) -> ()) {
        var pfUser = PFUser()
        pfUser.username = user.blogName!
        pfUser.email = user.blogName
        pfUser.password = "12345678"
        
        pfUser.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                completion(pfUser: pfUser, error: nil)
            } else {
                print("ERROR: Could not create PFUser")
                completion(pfUser: nil, error: error)
            }
        }
    }

    // first check if user exists
    // if it does log that user in 
    // otherwise return a newly created user
    // we use the logged in user blog from tumblr and the password can be hardcoded
    func setLoggedInPFUser(user: User, completion: (user: User, error: NSError?) -> ()) {
        // check if user exists in parse
        checkIfUserExists(user) { (pfUser, error) -> () in
            if error == nil {
                // user exists in parseDB
                if pfUser != nil {
                    // log the user in
                    self.logInPFUser(pfUser!, completion: { (pfUser, error) -> () in
                        if error == nil {
                            user.pfUser = pfUser
                            completion(user: user, error: nil)
                        } else {
                            print("WARNING: Did not login user")
                            completion(user: user, error: error)
                        }
                    })
                // user doesn't exist in parseDB, so create it
                } else {
                    // create the user and return it
                    self.createPFUser(user, completion: { (pfUser, error) -> () in
                        if error == nil {
                            user.pfUser = pfUser
                            completion(user: user, error: nil)
                        } else {
                            print("WARNING: Did not create user")
                            completion(user: user, error: error)
                        }
                    })
                }
            } else {
                print("WARNING: Did not create or login user")
                completion(user: user, error: error)
            }
        }
    }
    
    /*********************** PARSE USER **************************/

    // Find a ParseUser by the users blogName
    func getParseUser(user: User, completion: (parseUser: ParseUser?, error: NSError?) -> ()) {
        var query = PFQuery(className: "ParseUser")
        query.whereKey("blogName", equalTo: user.blogName! as String)

        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            var parseUser: ParseUser?
            if error == nil {
                if objects!.count > 0 {
                    // assume the item is in here
                    parseUser = objects![0] as! ParseUser
                }
                completion(parseUser: parseUser, error: nil)
            } else {
                print("ERROR: Could not get query ParseUser")
                completion(parseUser: nil, error: error)
            }
        }
    }
    
    // first check if parseUser is already in the ParseDB
    // if it does return the parseUser
    // otherwise create and save the parseUser
    func saveParseUser(user: User, completion: (parseUser: ParseUser?, error: NSError?) -> ()) {
        getParseUser(user) { (parseUser, error) -> () in
            if error == nil {
                // parseUser exists in DB, just return it then
                if parseUser != nil {
                    completion(parseUser: parseUser, error: nil)
                } else {
                // parseUser doesn't exist in DB, so lets create it and return it
                    var createParseUser = ParseUser()
                    createParseUser.blogName = user.blogName!
                    createParseUser.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                        if succeeded {
                            completion(parseUser: createParseUser, error: nil)
                        } else {
                            print("ERROR: Could not save parseUser in Parse")
                            completion(parseUser: nil, error: error)
                        }
                    })
                }
                
            } else {
                completion(parseUser: nil, error: error)
            }
        }
    }
    
    
    
    
    
}