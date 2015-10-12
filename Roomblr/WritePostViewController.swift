//
//  WritePostViewController.swift
//  Roomblr
//
//  Created by Tang Zhang on 10/11/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

class WritePostViewController: UIViewController {
    
    var rebloggedPost: Post?
    
    @IBOutlet weak var newPostTextLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onPost(sender: AnyObject) {
        
        if rebloggedPost != nil { // reblog a post
            
        } else { // create a new post
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
