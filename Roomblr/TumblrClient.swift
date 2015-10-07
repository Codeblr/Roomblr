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
    
    // avatar image request
    func getBlogAvatar(blogName: String, var size: Int?, completion: (url: String?, error: NSError?) -> ()) {
        var params = [String: AnyObject]()
        let url = "v2/blog/\(blogName).tumblr.com/avatar"
        if size == nil {
            size = 64
        }
        params["size"] =  size
        
        TumblrClient.sharedInstance.GET(url, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var avatarUrl = response["avatar_url"] as! String
                completion(url: avatarUrl, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                if error.userInfo["NSErrorFailingURLKey"] != nil {
                    var url = error.userInfo["NSErrorFailingURLKey"]
                    var urlString = url?.absoluteString
                    completion(url: urlString, error: nil)
                } else {
                    print("error getting blog avatar")
                    completion(url: nil, error: error)
                }
        })        
    }
    
    // search posts with tags
    func searchPostsWithTags(tag: String, completion: (posts: [Post]?, error: NSError?) -> ()) {
        var params = [String: String]()
        params["tag"] = tag
        params["filter"] = "text"
        TumblrClient.sharedInstance.GET("/v2/tagged", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
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
    
    func followBlog(blogUrl: String, completion: (error: NSError?) -> ()) {
        var params = [String: String]()
        params["url"] = blogUrl
        
        POST("/v2/user/follow", parameters: params,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                completion(error: nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(error: error)
            }
        )
    }
    
    func unFollowBlog(blogUrl: String, completion: (error: NSError?) -> ()) {
        var params = [String: AnyObject]()
        params["url"] = blogUrl
        
        POST("/v2/user/unfollow", parameters: params,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                completion(error: nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(error: error)
            }
        )
    }
    
    func likePost(id: Int, reblogKey: String, completion: (error: NSError?) -> ()) {
        var params = [String: AnyObject]()
        params["id"] = id as! Int
        params["reblog_key"] = reblogKey
        
        POST("/v2/user/like", parameters: params,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                completion(error: nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(error: error)
            }
        )
    }
    
    func unLikePost(id: Int, reblogKey: String, completion: (error: NSError?) -> ()) {
        var params = [String: AnyObject]()
        params["id"] = id
        params["reblog_key"] = reblogKey
        
        POST("/v2/user/unlike", parameters: params,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                completion(error: nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(error: error)
            }
        )
    }
    
    func reblogPost(blogName: String, id: Int, reblogKey: String, comment: String?, completion: (error: NSError?) -> ()) {
        var params = [String: AnyObject]()
        let url = "v2/blog/\(blogName).tumblr.com/post/reblog"
        params["id"] = id
        params["reblog_key"] = reblogKey
        if comment != nil {
            params["comment"] = comment
        }
        
        POST(url, parameters: params,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                completion(error: nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(error: error)
            }
        )
    }
    
}
