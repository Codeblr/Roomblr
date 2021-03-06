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
    var photoRatio: Double?
    var blogAvatarUrl: String?
    var body: String?
    var liked: Bool?
    var followed: Bool?

    
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
        followed = dic["followed"] as! Bool
        
        if type == "photo" {
            var photos = dic["photos"] as! Array<AnyObject>
            var altSizes = photos[0]["alt_sizes"]  as! Array<AnyObject>
            for p in altSizes {
                if p["width"] as! NSNumber == 250 {
                    photoUrl = p["url"] as! String
                    var width = p["width"] as! Double
                    var height = p["height"] as! Double
                    photoRatio =  (width / height) as! Double
                }
            }
            
            if photoUrl == nil {
                var photo = altSizes[0]
                var width = photo["width"] as! Double
                var height = photo["height"] as! Double
                photoUrl = photo["url"] as! String
                photoRatio =  (width / height) as! Double
            }
        } else if type == "text" {
            body = dic["body"] as! String
        }
    }
    
}