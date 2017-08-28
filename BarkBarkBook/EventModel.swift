//
//  EventModel.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 25.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

class EventModel {
    
    var note = ""
    var animal = ""
    var repeating = 0
    var dateTime = Date()
    var mode = false
    var userID = 0
    var photoData = Data()
    
    init(note: String, animal: String, repeating: Int, dateTime: Date, mode: Bool, userID: Int, photoData: Data) {
        self.note = note
        self.animal = animal
        self.repeating = repeating
        self.dateTime = dateTime
        self.mode = mode
        self.userID = userID
        self.photoData = photoData
    }
    
    init() { }
    
}
