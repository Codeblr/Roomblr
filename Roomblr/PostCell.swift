//
//  PostCell.swift
//  Roomblr
//
//  Created by Tang Zhang on 10/5/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

protocol PostCellDelegate: class {
    func imageUpdated(postCell: PostCell)
}

class PostCell: UITableViewCell {
    
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    
    var postCellDelegate: PostCellDelegate?
    
    var post: Post? {
        didSet {
            blogNameLabel.text = post?.blogName
            if post?.type == "photo" {
                if let urlString = (post?.photoUrl) {
                    let photoUrl = NSURL(string: urlString)
                    photoView.setImageWithURL(photoUrl!)
                    photoView.alpha = 1.0
                    postBodyLabel.alpha = 0
                    
//                NSNotificationCenter.defaultCenter().postNotificationName("CellDidLoadImageDidLoadNotification", object: self)
                }
            } else if post?.type == "text" {
                postBodyLabel.text = post!.body
            }
            
            // retreive blog avatarURL
            if post?.blogAvatarUrl != nil {
                var url = NSURL(string: (post?.blogAvatarUrl)!)
                self.blogImageView.setImageWithURL(url)
            }
            

            if (post?.liked != nil && post!.liked!) {
                likeBtn.setImage(UIImage(named: "liked.png"), forState: .Normal)
            } else {
                likeBtn.setImage(UIImage(named: "like.png"), forState: .Normal)
            }
        }
    }
    
    @IBAction func onReblog(sender: AnyObject) {
        
    }
    
    
    @IBAction func onLike(sender: AnyObject) {
        if (post?.liked != nil && post!.liked!) {
            TumblrClient.sharedInstance.unLikePost(post!.id!, reblogKey: post!.reblogKey!) { (error) -> () in
                if error == nil {
                    print("unlike a post")
                    self.post!.liked = true
                    self.likeBtn.setImage(UIImage(named: "like.png"), forState: .Normal)
                } else {
                    print("err unliking post \(error)")
                }
            }
        } else {
            TumblrClient.sharedInstance.likePost(post!.id!, reblogKey: post!.reblogKey!) { (error) -> () in
                if error == nil {
                    print("like a post")
                    self.post!.liked = true
                    self.likeBtn.setImage(UIImage(named: "liked.png"), forState: .Normal)
                } else {
                    print("err liking post \(error)")
                }
            }
        }
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake from nib \(post)")
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
