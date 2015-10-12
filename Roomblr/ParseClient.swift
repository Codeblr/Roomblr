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
        var query = PFUser.query()
        query!.whereKey("username", equalTo: user.blogName! as String)
        
        query!.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            var pfUser: PFUser?
            if error == nil {
                // if there is a user found
                if objects != nil && objects!.count > 0 {
                    pfUser = objects![0] as! PFUser
                    completion(pfUser: pfUser, error: nil)
                } else {
                    // if there is no user found
                    // not sure whether the error should be nil here
                    completion(pfUser: nil, error: nil)
                }
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
        pfUser.username = user.blogName
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
    
    // return all PFUsers from Parse
    func fetchAllPFUseres(completion: (pfUsers: [PFUser]?, error: NSError?) -> ()) {
        var query = PFUser.query()
        
        query!.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // assume [PFObject] are PFUsers
                var pfUsers = objects as! [PFUser]
                completion(pfUsers: pfUsers, error: nil)
            } else {
                print("ERROR: Could not query for PFUsers")
                completion(pfUsers: nil, error: error)
            }
        }
    }
    
    
    /*********************** Parse User Info **************************/
    
    func saveParseUserInfo(user: User, completion: (error: NSError?) -> ()) {
        var userInfo = ParseUserInfo()
        userInfo.blogName = user.blogName!
        userInfo.likes = user.likes!
        userInfo.following = user.following!
        
        userInfo.saveInBackgroundWithBlock { (completed: Bool, error: NSError?) -> Void in
            if completed {
                completion(error: nil)
            } else {
                completion(error: error)
            }
        }
    }
    
    func getParseUsersInfo(completion: (parseUserInfos: [ParseUserInfo]?, error: NSError?) -> ()) {
        var query = PFQuery(className: "ParseUserInfo")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                var parseUserInfos = [ParseUserInfo]()
                for object in objects! {
                    parseUserInfos.append(object as! ParseUserInfo)
                }
                completion(parseUserInfos: parseUserInfos, error: nil)
            } else {
                completion(parseUserInfos: nil, error: error)
            }
        }
    }
    
    
}