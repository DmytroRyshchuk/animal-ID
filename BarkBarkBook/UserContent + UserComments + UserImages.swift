//
//  UserContent.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 01.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

class UserContent {
    
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
    var imageLinks = [UserImages]()
    
    init(animalName: String, name: String, surname: String, content: String, countCommentsPosts: Int, countLikes: Int, createdAt: Int, statusOfPost: Int, id: Int, userComments: [UserComments]?, imageLinks: [UserImages]?) {
        self.animalName = animalName
        self.name = name
        self.surname = surname
        self.content = content
        self.countCommentsPosts = countCommentsPosts
        self.countLikes = countLikes
        self.createdAt = createdAt
        self.statusOfPost = statusOfPost
        self.id = id
        self.userComments = userComments!
        if imageLinks != nil {
            self.imageLinks = imageLinks!
        }
    }
    
    init() { }
    
}

class UserComments {
    
    var authorName = ""
    var authorSurname = ""
    var authorContent = ""
    var authorCreatedAt = 0
    var imageLinks = [UserImages]()
    
    init(authorName: String, authorSurname: String, authorContent: String, authorCreatedAt: Int, imagesLink: [UserImages]?) {
        self.authorName = authorName
        self.authorSurname = authorSurname
        self.authorContent = authorContent
        self.authorCreatedAt = authorCreatedAt
    }
    
    init() { }
    
}

class UserImages {
    
    var imageLink: String?
    
    init(imageLink: String?) {
        self.imageLink = imageLink
    }
    
    init() { }
    
}
