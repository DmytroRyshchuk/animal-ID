//
//  UserProfileClass.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 23.06.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

class UserProfile {
    
    var name = ""
    var surname = ""
    var email = ""
    var phone = ""
    var country = ""
    var zipcode = ""
    var address = ""
    var avatar = ""
    
    init() {
        
    }
    
    init(name: String, surname: String, email: String, phone: String, country: String, zipcode: String, address: String, avatar: String) {
        self.name = name
        self.surname = surname
        self.email = email
        self.phone = phone
        self.country = country
        self.zipcode = zipcode
        self.address = address
        self.avatar = avatar
    }
}
