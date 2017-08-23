//
//  MakeAnEventVC.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 21.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

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
    
    var dateIsPicked = false
    var animalNamesOfUserArray = [ChooseAnimalForMakeNewPost]()
    
    let apiClass = ApiClass()
    let setView = SetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: "firstAnimalFromApi", name: NSNotification.Name(rawValue: "firstAnimalFromApi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: "choosenAnimalFromApi", name: NSNotification.Name(rawValue: "choosenAnimalFromApi"), object: nil)
        
        setViewDidLoad()
        apiClass.getFirstUserAnimalToPostAPI(delegate: self, activityIndicator: activityIndicator)
    }
    
    @IBAction func changeAnimalAction(_ sender: Any) {
        apiClass.allAnimalsOfUserAPI(del: self)
    }
    
    @IBAction func setTimeAction(_ sender: Any) {
        setView.callViewPop(view: self, addViewPop: addViewPop, datepicker: datePicker, mode: "Time")
    }
    
    @IBAction func setDateAction(_ sender: Any) {
        setView.callViewPop(view: self, addViewPop: addViewPop, datepicker: datePicker, mode: "Date")
    }
    
    @IBAction func closeDatePicker(_ sender: Any) {
        setView.closeViewPop(view: self, addViewPop: addViewPop, datepicker: datePicker, setDataButton: dateOutlet, setTimeButton: timeOutlet, dateIsPicked: dateIsPicked)
    }
    
    @IBAction func setRepeatAction(_ sender: Any) {
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
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










