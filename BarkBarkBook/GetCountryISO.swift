//
//  GetCountryISO.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 01.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

class GetCountryISO {
    
    var countryName = ""
    var countryISOCode = 0
    
    init(countryName: String, countryISOCode: Int) {
        self.countryName = countryName
        self.countryISOCode = countryISOCode
    }
    
    init() { }
}
