//
//  Event.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 23.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

class Event {
    
    var note = ""
    var animal = ""
    var repeating = 0
    var dateTime = Date()
    var mode = false
    
    init(note: String, animal: String, repeating: Int, dateTime: Date, mode: Bool) {
        self.note = note
        self.animal = animal
        self.repeating = repeating
        self.dateTime = dateTime
        self.mode = mode
    }
    
    init() { }
    
}
