//
//  PostDetailsViewController.swift
//  Roomblr
//
//  Created by Jasen Salcido on 10/19/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController {
    var post: Post?
    
    @IBOutlet weak var blogAvatarImage: UIImageView!
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var textPostLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        blogNameLabel.text = post?.blogName
        
        if post?.type == "photo" {
            if let urlString = (post?.photoUrl) {
                let photoUrl = NSURL(string: urlString)
                postImage.setImageWithURL(photoUrl!)
                postImage.alpha = 1.0
                textPostLabel.alpha = 0
            }
        } else if post?.type == "text" {
            textPostLabel.text = post!.body
            postImage.alpha = 0.0
            textPostLabel.alpha = 1.0
        }
        
        // retreive blog avatarURL
        if post?.blogAvatarUrl != nil {
            var url = NSURL(string: (post?.blogAvatarUrl)!)
            self.blogAvatarImage.setImageWithURL(url)
        }        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
