//
//  UserDetailInformationOfAnimalViewController.swift
//  AnimalBook
//
//  Created by Dmytro Ryshchuk on 08.06.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserDetailInformationOfAnimalViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userContent = UserContent()
    var postsArray = [UserContent]()
    
    var cgs = CGSize()
    let tvc = TableViewCell()
    var postId = 0
    var statusOfPost = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.automaticallyAdjustsScrollViewInsets = false
        activityIndicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(UserDetailInformationOfAnimalViewController.deleteOnePost), name: NSNotification.Name(rawValue: "deleteOnePost"), object: nil)
    }
    
    func deleteOnePost() {
        //This function will be called when you post the notification
        
//        apiAllPostsOfUser()
        apiNewsFeedOfChoosenAnimal()
        print("Delete post and update post list")
    }

    func convertUnixToDate(timeStamp: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let text = dateFormatter.string(from: date as Date)
        return text
    }
    
    
    //MARK: - Alerts
    func callAlertSheet(postId: Int, statusOfPost: Int) {
        self.postId = postId
        self.statusOfPost = statusOfPost
        
        let alertController = UIAlertController(title: "Action Sheet", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let changeStatusOfPost = UIAlertAction(title: "Who can see this post", style: .default, handler: { (action) -> Void in
            self.callPostAlert(title: "Who can see this post?", actionTitleFirst: "Only me", actionTitleSecond: "Everyone")
        })
        
        let deletePost = UIAlertAction(title: "Delete this post", style: .destructive, handler: { (action) -> Void in
            self.callPostAlert(title: "Delete this post?", actionTitleFirst: "Yes", actionTitleSecond: "No")
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(changeStatusOfPost)
        alertController.addAction(deletePost)
        alertController.addAction(cancelButton)
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func callPostAlert(title: String, actionTitleFirst: String, actionTitleSecond: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let actionFirst = UIAlertAction(title: actionTitleFirst, style: .destructive) { (action:UIAlertAction) in
            
            if actionTitleFirst == "Only me" {
                self.tvc.changePost(id: self.postId, status: 1)
            } else {
                self.tvc.deletePost(id: self.postId)
            }
        }
        
        let actionSecond = UIAlertAction(title: actionTitleSecond, style: .default) { (action:UIAlertAction) in
            if actionTitleSecond == "Everyone" {
                self.tvc.changePost(id: self.postId, status: 3)
            }
        }
        
        alertController.addAction(actionFirst)
        alertController.addAction(actionSecond)
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
