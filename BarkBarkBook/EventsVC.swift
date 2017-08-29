//
//  EventsVC.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 21.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class EventsVC: UIViewController {
 
    var fetchedResultsController: NSFetchedResultsController<Event>!
    var managedContext:NSManagedObjectContext!
    
    @IBOutlet weak var tableView: UITableView!
    
    let setView = SetView()
    var eventModel = EventModel()
    let wwd = WorkWithDate()
    var eventObject = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        
        setView.naviColor(navi: navigationController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
        wwd.eventsArray = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scheduleLocal()
    }
    
    @IBAction func addNewEvent(_ sender: Any) {
        
    }
    
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default()
        
        let dateOfEvent = wwd.getDate()
        for i in dateOfEvent {
            print(dateOfEvent)
            
            content.title = i.title
            content.body = i.body
//            content.badge = 1
            
            var dateComponents = DateComponents()
            dateComponents.hour = i.date[0]
            dateComponents.minute = i.date[1]
            dateComponents.day = i.date[2]
            dateComponents.month = i.date[3]
            dateComponents.year = i.date[4]
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
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
        
        wwd.setDate(date: displayDate, title: "Animal: \(String(describing: event.animal))", body: event.note!)
        
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
        eventModel = EventModel(note: eventObject.note!, animal: eventObject.animal!, repeating: Int(eventObject.repeating), dateTime: eventObject.dateTime! as Date, mode: eventObject.mode, userID: Int(eventObject.userID), photoData: eventObject.photoData! as Data)
        
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





