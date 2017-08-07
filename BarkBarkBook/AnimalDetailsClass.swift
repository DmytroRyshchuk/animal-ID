//
//  AnimalDetailsClass.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 23.06.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

class UserAnimalsDetails {
    
    var photo = ""
    var nickname = ""
    var species = ""
    var sex = 0
    var id = 0
    var transponder = ""
    
    init(photo: String, nickname: String, species: String, sex: Int, id: Int, transponder: String) {
        self.photo = photo
        self.nickname = nickname
        self.species = species
        self.sex = sex
        self.id = id
        self.transponder = transponder
    }
    
    init() { }
}
