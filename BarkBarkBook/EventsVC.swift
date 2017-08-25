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
        
        let date = String(describing: event.dateTime!)
        let dateCountCharacters = date.characters.count - 9
        let index = date.index(date.startIndex, offsetBy: dateCountCharacters)
        let showDate = date.substring(to: index)
        
        cell.eventText.text = event.note
        cell.nicknameOfAnimal.text = event.animal
        cell.dateOfEvent.text = showDate
        
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
//        let object = self.fetchedResultsController.object(at: indexPath)
//        personData = PersonData(name: object.name!, year: Int(object.years), nationality: object.nationality!)
        //        alert(isEdit: true, object: object)
//        moveToListOfAnimalPage()
    }
    
//    func moveToListOfAnimalPage () {
//        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "GreenVC") as! GreenVC
//        
//        myVC.person = self.personData
//        self.navigationController?.pushViewController(myVC, animated: true)
//    }
    
}





