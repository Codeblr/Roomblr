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
                // perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // display err
            }
        }
    }

}

