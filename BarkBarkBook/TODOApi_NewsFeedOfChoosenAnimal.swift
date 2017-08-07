//
//  Api_FeedOfChoosenAnimal.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 29.06.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SDWebImage

extension MenuVC {
    
    func apiNewsFeedOfChoosenAnimal() {
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        let idOfAnimal = "\(String(describing: UserDefaults.standard.object(forKey: "idOfAnimal")!))"
        
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
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)"
        ]
        
        Alamofire.request("\(api_animalID)/animal/posts/\(idOfAnimal)", method: .get, headers: headers).responseJSON { response in
            print("\n========POSTS========")
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            
            if let data = jsonAsSwiftyJSON["data"].array {
                for json in data {
                    
                    print("\n\n\n")
                    print("name: ", json["_author"]["name"].string!)
                    print("surname: ", json["_author"]["surname"].string!)
                
                    print("count_comments_posts: ", json["count_comments_posts"].int!)
                    print("count_likes: ", json["count_likes"].int!)
                    
                    if let animal = json["_animal"]["nickname"].string {
                        animalName = animal
                    }
                    name = json["_author"]["name"].string!
                    surname = json["_author"]["surname"].string!
                    
                    if let contentMessage = json["content"].string {
                        content = contentMessage
                        print("content: ", json["content"].string!)
                    }
                    
                    if let createdAtMessage = json["created_at"].int {
                        createdAt = createdAtMessage
                        print("created_at: ", json["created_at"].int!)
                    }
                    
                    countCommentsPosts = json["count_comments_posts"].int!
                    countLikes = json["count_likes"].int!
                    
                    statusOfPost = json["status"]["id"].int!
                    
                    id = json["id"].int!
                    
                    if let imagesAll = json["_images"].array {
                        for image in imagesAll {
                            print("links: ", image["link"].string!)
                            let img = UserImages(imageLink: image["link"].string!)
                            imagesLink.append(img)                                          //TODO: cheak images
                        }
                    }
                    
                    if let commentsAll = json["_comments"].array {
                        for comment in commentsAll {
                            print("author name: ", comment["_author"]["name"].string!)
                            print("author surname: ", comment["_author"]["surname"].string!)
                            
                            if let imagesAll = comment["_author"]["_images"].array {
                                for image in imagesAll {
                                    print("links: ", image["link"].string!)
                                    let img = UserImages(imageLink: image["link"].string!)
                                    imagesLinkInComments.append(img)                        //TODO: cheak images
                                }
                            }
                            
                            print("author content: ", comment["content"].string!)
                            print("author created_at: ", comment["created_at"].int!)
                            
                            authorName = comment["_author"]["name"].string!
                            authorSurname = comment["_author"]["surname"].string!
                            authorContent = comment["content"].string!
                            authorCreatedAt = comment["created_at"].int!
                            
                            let comment = UserComments(authorName: authorName, authorSurname: authorSurname, authorContent: authorContent, authorCreatedAt: authorCreatedAt, imagesLink: imagesLinkInComments)

                            userComments.append(comment)
                        }
                        
                    }
                    
                    let posts = UserContent(animalName: animalName, name: name, surname: surname, content: content, countCommentsPosts: countCommentsPosts, countLikes: countLikes, createdAt: createdAt, statusOfPost: statusOfPost, id: id, userComments: userComments, imageLinks: imagesLink)
                    self.postsArray.append(posts)
                    imagesLink = []
                    userComments = []
                    content = ""
                }
                DispatchQueue.main.async {
                    self.moveToUserAnimalsList()
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func moveToUserAnimalsList () {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailInformationOfAnimalViewController") as! UserDetailInformationOfAnimalViewController
        
        myVC.postsArray = postsArray
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }
}
