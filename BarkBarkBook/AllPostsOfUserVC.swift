//
//  AllPostsOfUserViewController.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 17.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class AllPostsOfUserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var trailiingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    var menuIsShow = false
    var menuIsOpen = false
    let openMenu = OpenMenu()
    
    var userContent = UserContent()
    var allPostsOfUserArray = [UserContent]()
    
    let tvc = TableViewCell()
    let apou = AllPostsOfUserTableViewCell()
    var postId = 0
    var statusOfPost = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        apiAllPostsOfUser()
        //        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(AllPostsOfUserViewController.deleteMessage), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        apiAllPostsOfUser()
//        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    
    //MARK: - Actions
    @IBAction func showMenuAction(_ sender: Any) {
        if menuIsShow {
            leadingConstraint.constant = 0
            trailiingConstraint.constant = 0
        } else {
            leadingConstraint.constant = 150
            trailiingConstraint.constant = -150
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        menuIsShow = !menuIsShow
        print("Hello there")
    }
    
    @IBAction func openProfileOfUser(_ sender: Any) {
//        openMenu.openProfileOfUser()
        openMenu.api_ProfileOfUser(view: self)
    }
    
    @IBAction func openListOfAnimals(_ sender: Any) {
        openMenu.openListOfAnimals(view: self)
        menuIsOpen = true
    }
    
    @IBAction func logout(_ sender: Any) {
        api_LogOut()
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
    
    func deleteMessage() {
        //This function will be called when you post the notification
        apiAllPostsOfUser()
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
                self.apou.changePost(id: self.postId, status: 1)
//                self.tvc.changePost(id: self.postId, status: 1)
            } else {
                self.apou.deletePost(id: self.postId)
//                self.tvc.deletePost(id: self.postId)
            }
        }
        
        let actionSecond = UIAlertAction(title: actionTitleSecond, style: .default) { (action:UIAlertAction) in
            if actionTitleSecond == "Everyone" {
                self.apou.changePost(id: self.postId, status: 3)
//                self.tvc.changePost(id: self.postId, status: 3)
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
