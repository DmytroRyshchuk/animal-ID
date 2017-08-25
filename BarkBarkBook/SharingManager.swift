//
//  SharingManager.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 01.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class SharingManager {
    var avatar:String = ""
    
    var allPosts = [UserContent]()
    
    var key: String = ""
    var value: String = ""
    var date: String = ""
    var time: String = ""
    var repeating = 0
    
    var idOfAnimal: Int = 0
    var nicknameOfAnimal: String = ""
    var photoOfAnimal: UIImage = UIImage()
    
    var countryName = ""
    var isoOfCountry = 0
    static let sharedInstance = SharingManager()
}
