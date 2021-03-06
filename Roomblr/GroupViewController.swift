//
//  GroupViewController.swift
//  Roomblr
//
//  Created by Tang Zhang on 9/28/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PostCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getPosts()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    func reblogPost(postCell: PostCell, post: Post) {
        print("will reblog post \(post)")
        performSegueWithIdentifier("reblog", sender: post)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject) {
        getPosts()
    }
    
    func getPosts() {
        RoomblrUtility.sharedInstance.getFeedPosts(nil, completion: { (posts, error) -> () in
            if error == nil {
                self.posts = posts!
                
                for post in posts! {
                    TumblrClient.sharedInstance.getBlogAvatar(post.blogName!, size: 64, completion: { (url, error) -> () in
                        if error == nil {
                            post.blogAvatarUrl = url
                            self.tableView.reloadData()
                        }
                    })
                    
                }
//                self.tableView.reloadData()
            } else {
                print("get feed posts err \(error)")
            }
            self.refreshControl.endRefreshing()            
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        cell.postCellDelegate = self
        let post = posts[indexPath.row]
        
        
        if post.type == "photo" && post.photoRatio != nil{
            let width = tableView.frame.width
            cell.photoImageViewHeightConstraint.constant = width / CGFloat(post.photoRatio!)
        }
        cell.post = post
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "reblog" {
            if let navc = segue.destinationViewController as? UINavigationController {
                if let vc = navc.topViewController as? WritePostViewController {
                    if let post = sender as? Post {
                        vc.rebloggedPost = post
                    }
                }
            }
            
        } else if segue.identifier == "detailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            let post = posts[indexPath.row]
            let postDetailsViewController = segue.destinationViewController as! PostDetailsViewController
            postDetailsViewController.post = post
        }
    }


}
