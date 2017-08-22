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
    
    var animalNamesOfUserArray = [ChooseAnimalForMakeNewPost]()
    
    let apiClass = ApiClass()
    
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
    
    }
    
    @IBAction func setDateAction(_ sender: Any) {
        
    }
    
    @IBAction func setRepeatAction(_ sender: Any) {
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
    }
    
    
    func setViewDidLoad() {
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0.367, green: 0.342, blue: 0.341, alpha: 1)
        
        animalAvatar.layer.cornerRadius = animalAvatar.frame.height / 2
        animalNickname.layer.cornerRadius = 5
        animalButtonOutlet.layer.cornerRadius = 5
        notation.layer.cornerRadius = 5
        timeOutlet.layer.cornerRadius = 5
        dateOutlet.layer.cornerRadius = 5
        saveButtonOutlet.layer.cornerRadius = 5
    }
    
    //MARK: - Funcs
    func firstAnimalFromApi() {
        animalAvatar.image = SharingManager.sharedInstance.photoOfAnimal
//        animalAvatar.sd_setImage(with: url! as URL)
        animalAvatar.layer.masksToBounds = false
        animalAvatar.layer.cornerRadius = animalAvatar.frame.height/2 - 2
        animalAvatar.clipsToBounds = true
        animalNickname.text = SharingManager.sharedInstance.nicknameOfAnimal
    }
    
    func choosenAnimalFromApi() {
        animalAvatar.image = SharingManager.sharedInstance.photoOfAnimal
        animalNickname.text = SharingManager.sharedInstance.nicknameOfAnimal
    }
}










