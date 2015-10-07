//
//  Post.swift
//  Roomblr
//
//  Created by Jasen Salcido on 9/30/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

class Post: NSObject {
    var id: Int?
    var blogName: String?
    var tags: [String]?
    var content: String?
    var type: String?
    var reblogKey: String?
    var dateString: String?
    var photoUrl: String?
    var blogAvatarUrl: String?
    var body: String?
    var liked: Bool?

    
    var dic: NSDictionary
    
    init(dic: NSDictionary) {
        self.dic = dic
        id = dic["id"] as! Int
        blogName = dic["blog_name"] as! String
        tags = dic["tags"] as! [String]
        dateString = dic["date"] as! String
        type = dic["type"] as! String
        reblogKey = dic["reblog_key"] as! String
        liked = dic["liked"] as! Bool
        
        if type == "photo" {
            var photos = dic["photos"] as! Array<AnyObject>
            var altSizes = photos[0]["alt_sizes"]  as! Array<AnyObject>
            for p in altSizes {
                if p["width"] as! NSNumber == 250 {
                    photoUrl = p["url"] as! String
                }
            }
        } else if type == "text" {
            body = dic["body"] as! String
        }
    }
    
}