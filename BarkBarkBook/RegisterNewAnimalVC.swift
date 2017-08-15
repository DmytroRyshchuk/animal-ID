//
//  RegisterNewAnimalViewController.swift
//  AnimalBook
//
//  Created by Dmytro Ryshchuk on 30.05.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class RegisterNewAnimalViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var iv_imageOfAnimal: UIImageView!
    @IBOutlet weak var s_microchip: UISwitch!
    @IBOutlet weak var tf_transponder: UITextField!
    @IBOutlet weak var bo_species: UIButton!
    @IBOutlet weak var tf_breed: UITextField!
    @IBOutlet weak var sc_sex: UISegmentedControl!
    @IBOutlet weak var tf_nickname: UITextField!
    @IBOutlet weak var dp_datePicker: UIDatePicker!
    @IBOutlet weak var bo_datePicker: UIButton!
    @IBOutlet var v_view: UIView!
    @IBOutlet weak var sv_tran: UIStackView!
    
    @IBOutlet var bo_addViewPop: UIView!
    
    var img: Data?
    var speciesTypeDict = [SpeciesClass]()
    
    var dateIsPicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillViewDidLoad()
        activityIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if SharingManager.sharedInstance.value != "" {
            bo_species.setTitle(SharingManager.sharedInstance.value, for: .normal)
        }
    }
    
    func fillViewDidLoad() {
        let subViewOfSegment1: UIView = sc_sex.subviews[0] as UIView
        let subViewOfSegment2: UIView = sc_sex.subviews[1] as UIView
        //TODO: what the different?
        subViewOfSegment1.tintColor = UIColor.init(colorLiteralRed: 0.480, green: 0.695, blue: 0.424, alpha: 1)
        subViewOfSegment2.tintColor = UIColor.init(red: 0.480, green: 0.695, blue: 0.424, alpha: 1)
        //        subViewOfSegment2.tintColor = UIColor.init(displayP3Red: 0.480, green: 0.695, blue: 0.424, alpha: 1)
        
        sv_tran.isHidden = true
        
        iv_imageOfAnimal.layer.cornerRadius = iv_imageOfAnimal.frame.height/2
        iv_imageOfAnimal.clipsToBounds = true
    }
    
    
    
    //MARK: - Actions
    @IBAction func sa_microchip(_ sender: Any) {
        if s_microchip.isOn {
            //            tf_transponder.isEnabled = true
            //            tf_transponder.isHidden = false
            sv_tran.isHidden = false
        } else {
            //            tf_transponder.isEnabled = false
            //            tf_transponder.isHidden = true
            sv_tran.isHidden = true
        }
    }
    
    @IBAction func ba_registrationNewAnimal(_ sender: Any) {
        if s_microchip.isOn {
            if tf_transponder.text?.characters.count != 15 {
                let alertController = UIAlertController(title: "Error", message: "Transponder should be 15 characters long", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    print("You've pressed OK button");
                }
                
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
            } else {
                registerForm()
            }
        } else {
            registerForm()
        }
    }
    
    func registerForm() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        var micro = 0
        var trans = ""
        
        if s_microchip.isOn {
            micro = 1
            trans = tf_transponder.text!
        } else {
            micro = 0
            trans = ""
        }
        
        if let image = iv_imageOfAnimal.image {
            let imageOrintationIsOkay = self.sFunc_imageFixOrientation(img: image)
            
            if let imageData = imageOrintationIsOkay.jpeg(.high) {
                img = imageData
            }
        }
        
        print(SharingManager.sharedInstance.date)
        
        if tf_breed.text! == "" || SharingManager.sharedInstance.key == "" || tf_nickname.text! == "" || SharingManager.sharedInstance.date == "" {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            let alertController = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                print("You've pressed OK button");
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        } else {
            registerNewAnimalOnServer(microchip: micro,
                                      transponder: trans,
                                      species: Int(SharingManager.sharedInstance.key),
                                      breed: tf_breed.text!,
                                      sex: sc_sex.selectedSegmentIndex,
                                      nickname: tf_nickname.text!,
                                      birthday: SharingManager.sharedInstance.date,
                                      photo: img)
        }
    }
    
    @IBAction func ba_addAvatar(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = true
        image.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        self.present(image, animated: true, completion: nil)
    }
    
    @IBAction func ba_ChooseSpecies(_ sender: Any) {
        api_getAllSpeciesOfAnimal()
    }
    
    func openListOfAnimalPage() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}











