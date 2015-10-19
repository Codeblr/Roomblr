//
//  ParseUserInfoCell.swift
//  Roomblr
//
//  Created by Jasen Salcido on 10/19/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

class ParseUserInfoCell: UITableViewCell {

    @IBOutlet weak var blogAvatarImage: UIImageView!
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    var parseUserInfo: ParseUserInfo? {
        
        didSet {
            // retreive blog avatarURL
            if parseUserInfo?.blogAvatarUrl != nil {
                var url = NSURL(string: (parseUserInfo?.blogAvatarUrl)!)
                self.blogAvatarImage.setImageWithURL(url)
            }

            blogNameLabel.text = parseUserInfo?.blogName
            likesLabel.text = "\(parseUserInfo!.likes) likes"
            followingLabel.text = "\(parseUserInfo!.following) blogs following"
            
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
    
    override func prepareForReuse() {
        blogAvatarImage.image = nil
    }

}
