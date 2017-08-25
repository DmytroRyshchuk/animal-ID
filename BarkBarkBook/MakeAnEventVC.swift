//
//  MakeAnEventVC.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 21.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import CoreData

class MakeAnEventVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var animalAvatar: UIImageView!
    @IBOutlet weak var animalNickname: UILabel!
    @IBOutlet weak var animalButtonOutlet: UIButton!
    @IBOutlet weak var notation: UITextView!
    @IBOutlet weak var timeOutlet: UIButton!
    @IBOutlet weak var dateOutlet: UIButton!
    @IBOutlet weak var switchMode: UISwitch!
    @IBOutlet weak var repeatOutlet: UIButton!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var addViewPop: UIView!
    
    var fetchedResultsController: NSFetchedResultsController<Event>!
    var managedContext:NSManagedObjectContext!
    
    var animalNamesOfUserArray = [ChooseAnimalForMakeNewPost]()
    
    let apiClass = ApiClass()
    let setView = SetView()
    
    var mode = false
    var repeatingTime = 0
    var unixDataTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MakeAnEventVC.firstAnimalFromApi), name: NSNotification.Name(rawValue: "firstAnimalFromApi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MakeAnEventVC.choosenAnimalFromApi), name: NSNotification.Name(rawValue: "choosenAnimalFromApi"), object: nil)
        
        SharingManager.sharedInstance.repeating = 0
        
        setViewDidLoad()
        apiClass.getFirstUserAnimalToPostAPI(delegate: self, activityIndicator: activityIndicator)
        getCurentDateTime()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func changeAnimalAction(_ sender: Any) {
        apiClass.allAnimalsOfUserAPI(del: self)
    }
    
    @IBAction func setTimeAction(_ sender: Any) {
        setView.callViewPop(view: self, addViewPop: addViewPop, datepicker: datePicker, mode: "Time", max: false)
    }
    
    @IBAction func setDateAction(_ sender: Any) {
        setView.callViewPop(view: self, addViewPop: addViewPop, datepicker: datePicker, mode: "Date", max: false)
    }
    
    @IBAction func closeDatePicker(_ sender: Any) {
        setView.closeViewPop(view: self, addViewPop: addViewPop, datepicker: datePicker, setDataButton: dateOutlet, setTimeButton: timeOutlet)
    }
    
    @IBAction func setRepeatAction(_ sender: Any) {
        let alert = UIAlertController(title: "Repeat", message: "Please Choose how often to repeat", preferredStyle: .actionSheet)
        
        setView.repeatingModeInAlertList(alert: alert, button: repeatOutlet, times: ["Once", "Every day", "One in a week", "Twice per month", "Every month", "Every year"])
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if switchMode.isOn {
            mode = true
        } else {
            mode = false
        }
        
        let timeUnix = formateTimeToDate()
        if let unixDate = timeUnix {
            unixDataTime = unixDate
        }
        
        let s = formateDateToString()
        
        print("u = ", unixDataTime)
        print("s = ", s)
        
        let userID = UserDefaults.standard.value(forKey: "id_of_user") as? Int
        
        let event = Event(entity: Event.entity(), insertInto: managedContext)
        
        event.note = notation.text
        event.animal = animalNickname.text
        event.repeating = Int16(SharingManager.sharedInstance.repeating)
        event.dateTime = unixDataTime as NSDate
        event.mode = mode
        event.userID = Int32(userID!)
        
        do {
            try managedContext.save()
            // MARK: - Remove people.append(person)
            print("event was created")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getCurentDateTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let time = "  \(hour):\(minutes)  "
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current//Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "  dd MMMM yyyy  "
        let dateStr = formatter.string(from: unixDataTime)
        
        timeOutlet.setTitle(time, for: .normal)
        dateOutlet.setTitle(dateStr, for: .normal)
    }
    
    func formateTimeToDate() -> Date? {
        let date = dateOutlet.titleLabel?.text
        let time = timeOutlet.titleLabel?.text
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = NSLocale.current//Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "  dd MMMM yyyy  'T'  HH:mm  "
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let string = "\(String(describing: date!))T\(String(describing: time!))"
        let convertedDate = RFC3339DateFormatter.date(from: string)
        
        if let convert = convertedDate {
            return convert
        } else {
            return nil
        }
    }
    
    func formateDateToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current//Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMMM yyyy HH:mm"
        let str = formatter.string(from: unixDataTime)
        
        return str
    }
    
    func setViewDidLoad() {
        setView.naviColor(navi: navigationController)
        setView.makeAvatarRound(avatar: animalAvatar)
        setView.setRadius(elements: [animalNickname, animalButtonOutlet, notation, timeOutlet, dateOutlet, saveButtonOutlet])
    }
    
    //MARK: - Funcs
    func firstAnimalFromApi() {
        setView.showDataOfFirstAnimal(avatar: animalAvatar, element: animalNickname)
    }
    
    func choosenAnimalFromApi() {
        setView.showDataOfAnimal(avatar: animalAvatar, element: animalNickname)
    }
}










