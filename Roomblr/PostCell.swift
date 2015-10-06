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
    
    var post: Post? {
        didSet {
            blogNameLabel.text = post?.blogName
//            postBodyLabel.text = post?.body
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
