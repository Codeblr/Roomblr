//
//  Post.swift
//  Roomblr
//
//  Created by Jasen Salcido on 9/30/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

class Post: NSObject {
    var idString: String?
    var blogName: String?
    var tags: [String]?
    var content: String?
    var type: String?
    var reblogKey: String?
    var dateString: String?
    
    var dic: NSDictionary
    
    init(dic: NSDictionary) {
        self.dic = dic
        idString = String(dic["id"])
        blogName = dic["blog_name"] as! String
        tags = dic["tags"] as! [String]
        dateString = dic["date"] as! String
        type = dic["type"] as! String
        reblogKey = dic["reblog_key"] as! String
    }
    
}