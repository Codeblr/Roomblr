//
//  PostCell.swift
//  Roomblr
//
//  Created by Tang Zhang on 10/5/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var photoView: UIImageView!
    
    var post: Post? {
        didSet {
            blogNameLabel.text = post?.blogName
            if post?.type == "photo" {
                if let urlString = (post?.photoUrl) {
                    let photoUrl = NSURL(string: urlString)
                    photoView.setImageWithURL(photoUrl!)
                    photoView.alpha = 1.0
                }                
            } else if post?.type == "text" {
                postBodyLabel.text = post!.body
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
