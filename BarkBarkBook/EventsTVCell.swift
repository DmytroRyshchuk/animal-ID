//
//  EventsTVCell.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 22.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import CoreData

class EventsTVCell: UITableViewCell {
    
    @IBOutlet weak var nicknameOfAnimal: UILabel!
    @IBOutlet weak var dateOfEvent: UILabel!
    @IBOutlet weak var eventText: UILabel!
    @IBOutlet weak var switchOutlet: UISwitch!
    
    var mode = false
    var eventObject = Event()
    var eventModel = EventModel()
    
    var fetchedResultsController: NSFetchedResultsController<Event>!
    var managedContext:NSManagedObjectContext!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func switchChangeMode(_ sender: Any) {
        
        if switchOutlet.isOn {
            mode = true
        } else {
            mode = false
        }
        
        eventObject.mode = mode
        
//        eventModel = EventModel(note: eventObject.note!,
//                                animal: eventObject.animal!,
//                                repeating: Int(eventObject.repeating),
//                                dateTime: eventObject.dateTime! as Date,
//                                mode: mode,
//                                userID: Int(eventObject.userID),
//                                photoData: eventObject.photoData! as Data)
        
        print("note = ", mode)
        
        do {
            try managedContext.save()
            // MARK: - Remove people.append(person)
            print("event was created")
//            _ = navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
