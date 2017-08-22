//
//  MakeAnEventVC.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 21.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class MakeAnEventVC: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewDidLoad()
    }
    
    @IBAction func changeAnimalAction(_ sender: Any) {
        
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
    func dataAboutChoosenAnimalInPost() {
        animalNamesOfUserArray = []
        let title = SharingManager.sharedInstance.nicknameOfAnimal
        if title != "" {
            animalNickname.text = title
//            chooseAnimalButtonOutlet.setTitle(title, for: .normal)
        } else {
            animalNickname.text = "Choose animal"
//            chooseAnimalButtonOutlet.setTitle("Choose animal", for: .normal)
        }
        
        animalAvatar.image = SharingManager.sharedInstance.photoOfAnimal
    }
}










