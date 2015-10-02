//
//  RoomblrUtility.swift
//  Roomblr
//
//  Created by Jasen Salcido on 10/1/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

let NUMBER_OF_TOP_TAGS = 1

class RoomblrUtility {
    
    class var sharedInstance: RoomblrUtility {
        struct Static {
            static let instance = RoomblrUtility()
        }
        return Static.instance
    }
    
    // get top x tags from liked posts
    func getTopTagsFromPosts(completion: (tags: [String]?, error: NSError?) -> ()) {
        var tagDictionary = [String: Int]()
        // get all the PFUsers
        ParseClient.sharedInstance.fetchAllPFUseres { (pfUsers: [PFUser]?, error: NSError?) -> () in
            if error == nil {
                // TODO change this to get all likes from all users and collect top tags
                let randomNumber = Int(arc4random()) % (pfUsers!.count - 1)
                let pfUser = pfUsers![randomNumber]
                
                // fetch likes
                TumblrClient.sharedInstance.getBlogLikesPosts(pfUser.username!, completion: { (posts, error) -> () in
                    if error == nil {
                        for post in posts! {
                            // put tags in dictionary
                            for tag in post.tags! {
                                if tagDictionary[tag] == nil {
                                    tagDictionary[tag] = 1
                                } else {
                                    tagDictionary[tag] = tagDictionary[tag]! + 1
                                }
                            }
                        }
                        // now sort tags in an array
                        
                        let tags = self.sortMaxTags(tagDictionary) as! [String]
                        completion(tags: tags, error: nil)
                    }
                })
            } else {
                // error
            }
        }
    }
    
    // get tag posts
    // same proble as batching PFUsers so we must do this
    // right only one so going to assume tags[0] is our only tag
    func getTagPosts(tags: [String], completion: (posts: [Post]?, error: NSError?) -> ()) {
        let tag = tags[0]
        TumblrClient.sharedInstance.searchPostsWithTags(tag) { (posts, error) -> () in
            if error == nil {
                completion(posts: posts, error: nil)
            } else {
                completion(posts: nil, error: error)
            }
        }
    }
    
    // needs to sort all tags and return NUMBER_OF_TOP_TAGS tags
    // did this quick so we can make our views
    func sortMaxTags(dictionary: [String: Int]) -> [String] {
        var sorted = [String]()
        var maxTagKey = ""
        var maxTagValue = 0
        for (tagName, value) in dictionary {
            if value > maxTagValue {
                maxTagKey = tagName
                maxTagValue = value
            }
        }
        sorted.append(maxTagKey)
        return sorted
    }
    
}