//
//  ViewController.swift
//  Roomblr
//
//  Created by Matt Rucker on 9/23/15.
//  Copyright (c) 2015 tumblr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TumblrClient.sharedInstance.loginWithCompletion(){
            (user: User?, err: NSError?) in
            if (user != nil) {
                ParseClient.sharedInstance.setLoggedInPFUser(User.currentUser!, completion: { (user, error) -> () in
                    // probably should be down somwhere else...
                    User.currentUser = user
                    if error == nil {
                        self.performSegueWithIdentifier("loginSegue", sender: self)
                    } else {
                        print("ERROR: DID NOT LOG IN PF USER")
                    }
                })
                // perform segue
            } else {
                // display err
                print("ERROR: DID NOT LOG IN TUMBLR USER")
            }
        }
    }

}

