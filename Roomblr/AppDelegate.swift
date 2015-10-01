//
//  AppDelegate.swift
//  Roomblr
//
//  Created by Matt Rucker on 9/23/15.
//  Copyright (c) 2015 tumblr. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)
        
        // set up parse
        ParseUser.registerSubclass()
        Parse.setApplicationId("FwMbRpjZl9IVEzHut2U0WKbFnSVZIL0VQSJWMhUg", clientKey: "qeTh8ZXjNAxQc7YlbaprYXM6AfW8Ktrc3U2YcECC")
        if User.currentUser != nil {
            // we need to make sure the PFUser exists
            ParseClient.sharedInstance.setLoggedInPFUser(User.currentUser!, completion: { (user: User, error: NSError?) -> () in
                if error == nil {
                    print("Cached User successfully logged in")
                    User.currentUser = user
                    // go to loggedin screen
                    let vc = self.storyboard.instantiateViewControllerWithIdentifier("GroupNavController") as! UINavigationController
                    self.window?.rootViewController = vc
                } else {
                    // not sure what to do here
                }
            })
        }
        return true
    }
    
    
    func userDidLogout() {
        let vc = storyboard.instantiateInitialViewController()
        window?.rootViewController = vc
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        TumblrClient.sharedInstance.openURL(url)
        
        return true
    }


}

