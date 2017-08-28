//
//  EventsVC.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 21.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import CoreData

class EventsVC: UIViewController {
 
    var fetchedResultsController: NSFetchedResultsController<Event>!
    var managedContext:NSManagedObjectContext!
    
    @IBOutlet weak var tableView: UITableView!
    
    let setView = SetView()
    var eventModel = EventModel()
    
    var eventObject = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        
        setView.naviColor(navi: navigationController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    @IBAction func addNewEvent(_ sender: Any) {
        
    }
    
    func reloadData() {
        let fetchRequest:NSFetchRequest<Event> = Event.fetchRequest()
        if true {
            fetchRequest.predicate = NSPredicate(format: "userID CONTAINS \(UserDefaults.standard.value(forKey: "id_of_user") as! Int)")
        }
        
        let sortDescriptor = NSSortDescriptor(key: "dateTime", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // MARK: - Create fetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            // MARK: - Add try fetchedResultsController.performFetch()
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch let error {
            print(error)
        }
    }

    
    
}

extension EventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: - Update
        let event = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventsTVCell
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "dd MMMM yyyy HH:mm"
        let displayDate = formatter.string(from: event.dateTime! as Date)
        
        cell.eventText.text = event.note
        cell.nicknameOfAnimal.text = event.animal
        cell.dateOfEvent.text = displayDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let user = fetchedResultsController.object(at: indexPath)
            managedContext.delete(user)
            
            do {
                try managedContext.save()
                reloadData()
            } catch let error {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventObject = self.fetchedResultsController.object(at: indexPath)
        eventModel = EventModel(note: eventObject.note!, animal: eventObject.animal!, repeating: Int(eventObject.repeating), dateTime: eventObject.dateTime! as Date, mode: eventObject.mode, userID: Int(eventObject.userID))
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "dd MMMM yyyy"
        SharingManager.sharedInstance.date = formatter.string(from: eventObject.dateTime! as Date)
        formatter.dateFormat = "HH:mm"
        SharingManager.sharedInstance.time = formatter.string(from: eventObject.dateTime! as Date)
        
        //        alert(isEdit: true, object: object)
        moveToListOfAnimalPage()
    }
    
    func moveToListOfAnimalPage () {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MakeAnEventVC") as! MakeAnEventVC
        
        myVC.eventModel = self.eventModel
        myVC.eventObject = eventObject
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
}





