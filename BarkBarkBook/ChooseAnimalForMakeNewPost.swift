//
//  ChooseAnimalForMakeNewPost.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 01.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

//MARK: - Class for api
class ChooseAnimalForMakeNewPost {
    var nickname = ""
    var id = 0
    var photo: String?
    
    init(nickname: String, id: Int, photo: String?) {
        self.nickname = nickname
        self.id = id
        self.photo = photo
    }
    
    init() { }
}
