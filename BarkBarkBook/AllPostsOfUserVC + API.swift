//
//  AllPostsOfUserVC + API.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 01.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//MARK: - All posts of user
extension AllPostsOfUserViewController {
    
    func apiAllPostsOfUser() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.tableView.isScrollEnabled = false
        
        
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        var animalName = ""
        var name = ""
        var surname = ""
        var content = ""
        var countCommentsPosts = 0
        var countLikes = 0
        var createdAt = 0
        var statusOfPost = 0
        var id = 0
        var userComments = [UserComments]()
        var imagesLink = [UserImages]()
        var imagesLinkInComments = [UserImages]()
        
        var authorName = ""
        var authorSurname = ""
        var authorContent = ""
        var authorCreatedAt = 0
        
        pageIndex += 1
        let link = "\(api_animalID)/post/index/\(pageIndex)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)"
        ]
        
        Alamofire.request(link, method: .get, headers: headers).responseJSON { response in
            print("\n========POSTS========")
//            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                //                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            
            if let data = jsonAsSwiftyJSON["data"]["posts"].array {
                if let total_count = jsonAsSwiftyJSON["data"]["total_count"].int {
                    self.countOfAllPost = total_count
                }
                
                for json in data {
                    if let animal = json["_animal"]["nickname"].string {
                        animalName = animal
                    }
                    
                    name = json["_author"]["name"].string!
                    surname = json["_author"]["surname"].string!
                    
                    if let contentMessage = json["content"].string {
                        content = contentMessage
                    }
                    
                    if let createdAtMessage = json["created_at"].int {
                        createdAt = createdAtMessage
                    }
                    
                    countCommentsPosts = json["count_comments_posts"].int!
                    countLikes = json["count_likes"].int!
                    
                    statusOfPost = json["status"]["id"].int!
                    
                    id = json["id"].int!
                    
                    if let imagesAll = json["_images"].array {
                        for image in imagesAll {
                            let img = UserImages(imageLink: image["link"].string!)
                            imagesLink.append(img)                                          //TODO: cheak images
                        }
                    }
                    
                    if let commentsAll = json["_comments"].array {
                        for comment in commentsAll {
                            if let imagesAll = comment["_author"]["_images"].array {
                                for image in imagesAll {
                                    let img = UserImages(imageLink: image["link"].string!)
                                    imagesLinkInComments.append(img)                        //TODO: cheak images
                                }
                            }
                            
                            authorName = comment["_author"]["name"].string!
                            authorSurname = comment["_author"]["surname"].string!
                            authorContent = comment["content"].string!
                            authorCreatedAt = comment["created_at"].int!
                            
                            let comment = UserComments(authorName: authorName, authorSurname: authorSurname, authorContent: authorContent, authorCreatedAt: authorCreatedAt, imagesLink: imagesLinkInComments)
                            
                            userComments.append(comment)
                        }
                        
                    }
                    
                    let posts = UserContent(animalName: animalName, name: name, surname: surname, content: content, countCommentsPosts: countCommentsPosts, countLikes: countLikes, createdAt: createdAt, statusOfPost: statusOfPost, id: id, userComments: userComments, imageLinks: imagesLink)
                    
                    self.allPostsOfUserArray.append(posts)
                    imagesLink = []
                    userComments = []
                    content = ""
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.tableView.isScrollEnabled = true
                    print("TableView was reloaded")
                    
                    if UserDefaults.standard.value(forKey: "RegistrationOfNewUse") as? String == "true" || self.allPostsOfUserArray.isEmpty {
                        UserDefaults.standard.set("false", forKey: "RegistrationOfNewUse")
                        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                        
                        self.navigationController?.pushViewController(myVC, animated: true)
                    }
                }
            }
        }
    }
}

