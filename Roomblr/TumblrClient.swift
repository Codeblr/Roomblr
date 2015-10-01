//
//  TumblrClient.swift
//  Roomblr
//
//  Created by Tang Zhang on 9/28/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

let tumblrConsumerKey = "aBG4xaLZYf9OvaTuf8iDF6hEcuYuUA4qp75D4C418ZjSz0SnyY"
let tumblrConsumerSecret =  "Wpl1fFZYQTJ3vm7BMZzoLCFPyLc8pN7XsIz7jSq5JRbZxheNa9"
let tumblrBaseUrl = NSURL(string: "https://api.tumblr.com")

class TumblrClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, err: NSError?) -> Void)?
    
    class var sharedInstance: TumblrClient {
        struct Static {
            static let instance = TumblrClient(baseURL: tumblrBaseUrl, consumerKey: tumblrConsumerKey, consumerSecret: tumblrConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, err: NSError?) -> Void) {
        loginCompletion = completion
        
        // fetch request token and redirect to auth page
        TumblrClient.sharedInstance.requestSerializer.removeAccessToken()
        TumblrClient.sharedInstance.fetchRequestTokenWithPath("https://www.tumblr.com/oauth/request_token", method: "GET", callbackURL: NSURL(string: "roomblr://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("get the request token")
            var authURL = NSURL(string: "https://www.tumblr.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (err: NSError!) -> Void in
                print("request token err")
                self.loginCompletion?(user: nil, err: err)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("https://www.tumblr.com/oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            print("get access token")
            
            TumblrClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            // fetch the user info
            TumblrClient.sharedInstance.GET("v2/user/info", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                print("get user \(response)")
                let responseObj = response["response"] as! NSDictionary
                var user = User(dic: responseObj["user"] as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, err: nil)
                
                }, failure: { (operation: AFHTTPRequestOperation!, err: NSError!) -> Void in
                    print("err getting current usr")
                    self.loginCompletion?(user: nil, err: err)
            })
            
            
            }, failure: { (err: NSError!) -> Void in
                print("failed to get access token")
                self.loginCompletion?(user: nil, err: err)
        })
    }
    
    // return the last 20 posts liked from this blog
    func getBlogLikesPosts(blogName: String, completion:(posts: [Post]?, error: NSError?) -> ()) {
        TumblrClient.sharedInstance.GET("v2/blog/\(blogName).tumblr.com/likes?api_key=\(tumblrConsumerKey)", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var posts = [Post]()
                let responseObj = response["response"] as! NSDictionary
                let likedPosts = responseObj["liked_posts"] as! [AnyObject]
                var i = 0
                for (i; i < likedPosts.count; i++) {
                    var post = Post(dic: likedPosts[i] as! NSDictionary)
                    posts.append(post)
                }
                completion(posts: posts, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error getting liked posts")
                completion(posts: nil, error: error)
        })
    }
    
    func searchPostsWithTags(tag: String, completion: (posts: [Post]?, error: NSError?) -> ()) {
        TumblrClient.sharedInstance.GET("/v2/tagged?tag=\(tag)", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var posts = [Post]()
                let postsResponse = response["response"] as! [AnyObject]
                var i = 0
                for (i; i < postsResponse.count; i++ ) {
                    var post = Post(dic: postsResponse[i] as! NSDictionary)
                    posts.append(post)
                }
                completion(posts: posts, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error getting searched posts")
                completion(posts: nil, error: error)
        })
    }
}
