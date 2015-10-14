//
//  WritePostViewController.swift
//  Roomblr
//
//  Created by Tang Zhang on 10/11/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

class WritePostViewController: UIViewController {
    
    
    @IBOutlet weak var createPostView: UIView!
    
    @IBOutlet weak var createPostViewLeftConstraint: NSLayoutConstraint!    
    @IBOutlet weak var createPostViewRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var tagsTextField: UITextField!
    
    
    //============
    
   
    @IBOutlet weak var currentUserAvartar: UIImageView!
    @IBOutlet weak var rebloggedUserAvatar: UIImageView!
    
    @IBOutlet weak var rebloggedPhotoView: UIImageView!
    @IBOutlet weak var rebloggedTextView: UITextView!
    
    var rebloggedPost: Post? {
        didSet {
            view.layoutIfNeeded()
            if rebloggedPost?.type == "photo" {
                if let urlString = (rebloggedPost?.photoUrl) {
                    if let photoUrl = NSURL(string: urlString) {
                        rebloggedPhotoView.setImageWithURL(photoUrl)
                        rebloggedPhotoView.alpha = 1.0
                        rebloggedTextView.alpha = 0
                    }
                }
            } else if rebloggedPost?.type == "text" {
                rebloggedTextView.text = rebloggedPost!.body
                rebloggedPhotoView.alpha = 0
                rebloggedTextView.alpha = 1.0
            }
            
            if rebloggedPost?.blogAvatarUrl != nil {
                let url = NSURL(string: (rebloggedPost?.blogAvatarUrl)!)
                self.rebloggedUserAvatar.setImageWithURL(url)
            }

        }
    }
    
    
    @IBOutlet weak var newPostTextLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if rebloggedPost == nil { // create a new post
            titleTextField.becomeFirstResponder()
            bodyTextView.layer.borderWidth = 1.0
            bodyTextView.layer.cornerRadius = 3.0
        } else { // reblog a post
            createPostView.alpha = 0
            newPostTextLabel.becomeFirstResponder()
            TumblrClient.sharedInstance.getBlogAvatar(User.currentUser!.blogName!, size: nil) { (url, error) -> () in
                if (error == nil) {
                    if let imageUrl = NSURL(string: url!) {
                        self.currentUserAvartar.setImageWithURL(imageUrl)
                    }
                } else {
                    print(error)
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPost(sender: AnyObject) {
        
        if rebloggedPost != nil { // reblog a post
            print("got the rebloggedPost \(rebloggedPost)")
            if (newPostTextLabel.text != "") {
                TumblrClient.sharedInstance.reblogPost(User.currentUser!.blogName!, id: rebloggedPost!.id!, reblogKey: rebloggedPost!.reblogKey!, comment: newPostTextLabel.text, completion: { (error) -> () in
                    if (error == nil) {
                        print("reblog post success!!")
                    } else {
                        print("\(error)")
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        } else { // create a new post
            TumblrClient.sharedInstance.createTextPost(User.currentUser!.blogName!, title: titleTextField.text!, body: bodyTextView.text!, tags: tagsTextField.text!, completion: { (error) -> () in
                if (error == nil) {
                    print("created new post!!")
                } else {
                    print(error)
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }    
    }
    
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
