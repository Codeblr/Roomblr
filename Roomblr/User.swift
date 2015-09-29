//
//  User.swift
//  Roomblr
//
//  Created by Tang Zhang on 9/28/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "CurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var dic: NSDictionary
    
    init(dic: NSDictionary) {
        self.dic = dic
        name = dic["name"] as? String
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do {
                        var dic = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        _currentUser = User(dic: dic)
                    }catch let error as NSError {
                        print(error)
                    }
            
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                do {
                    var data = try NSJSONSerialization.dataWithJSONObject(user!.dic, options: NSJSONWritingOptions.init())
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                }catch let error as NSError {
                    print(error)
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func logout() {
        User.currentUser = nil
        TumblrClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }

}
