//
//  EventsArray.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 29.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

class EventsArray {
    
    var date = [Int]()
    var title = ""
    var body = ""
    
    init(date: [Int], title: String, body: String) {
        self.date = date
        self.title = title
        self.body = body
    }
    
    init() { }
}
