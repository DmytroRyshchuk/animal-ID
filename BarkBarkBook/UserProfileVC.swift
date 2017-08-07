//
//  UserProfileVC.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 23.06.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {

    @IBOutlet weak var iv_avatar: UIImageView!
    @IBOutlet weak var l_name: UILabel!
    @IBOutlet weak var l_surname: UILabel!
    @IBOutlet weak var l_email: UILabel!
    @IBOutlet weak var l_phone: UILabel!
    @IBOutlet weak var l_country: UILabel!
    @IBOutlet weak var l_zipcode: UILabel!
    @IBOutlet weak var l_address: UILabel!
    
    var up = [UserProfile]()
    var img: Data?
    var getCountryISO = [GetCountryISO]()
    var countryWasChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if countryWasChanged {
            self.api_ProfileChange( userName: "",
                                    userSurname: "",
                                    userPhone: "",
                                    userCountry: Int(SharingManager.sharedInstance.isoOfCountry),
                                    userZipcode: "",
                                    userAddress: "",
                                    whatToChange: 4)
            print("iso = ", SharingManager.sharedInstance.isoOfCountry)
        }
    }
    
    //MARK: - Actions
    @IBAction func ba_edit_Name(_ sender: Any) {
        fillEditAlert(title: "Name", placeholder: "Enter your name here", whatToChange: 1)
    }
    
    @IBAction func ba_edit_Surname(_ sender: Any) {
        fillEditAlert(title: "Surname", placeholder: "Enter your surname here", whatToChange: 2)
    }
    
    @IBAction func ba_edit_Phone(_ sender: Any) {
        fillEditAlert(title: "Phone", placeholder: "+380...", whatToChange: 3)
    }
    
    @IBAction func ba_edit_Country(_ sender: Any) {
        self.api_getISOOfCountry()
        countryWasChanged = true
    }
    
    @IBAction func ba_edit_Zipcode(_ sender: Any) {
        fillEditAlert(title: "Zipcode", placeholder: "29000", whatToChange: 5)
    }
    
    @IBAction func ba_edit_Address(_ sender: Any) {
        fillEditAlert(title: "address", placeholder: "str.", whatToChange: 6)
//        lvc.api_LogOut()
    }
    
    @IBAction func ba_updateUserAvatar(_ sender: Any) {
        enterPhotoLibrary()
    }

    //MARK: - Funcs
    func fillProfile() {
        l_name.text = up[0].name
        l_surname.text = up[0].surname
        l_email.text = up[0].email
        l_phone.text = up[0].phone
        l_country.text = up[0].country
        l_zipcode.text = up[0].zipcode
        l_address.text = up[0].address
        
        let url = URL(string: up[0].avatar)
        
        DispatchQueue.global().async {
            if url != nil  {
                print(String(describing: url))
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.iv_avatar.image = UIImage(data: data!)
                }
            }
        }
    }

    func fillEditAlert(title: String, placeholder: String, whatToChange: Int) {
        
        let alertController = UIAlertController(title: "\(title)", message: "Please enter your credentials.", preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            //This is called when the user presses the cancel button.
            print("You've pressed the cancel button");
        }
        
        let actionLogin = UIAlertAction(title: "\(title)", style: .default) { (action:UIAlertAction) in
            //This is called when the user presses the login button.
            let textUser = alertController.textFields![0] as UITextField
            
            switch whatToChange {
            case 1:
                self.api_ProfileChange( userName: "\(textUser.text!)",
                    userSurname: "",
                    userPhone: "",
                    userCountry: 0,
                    userZipcode: "",
                    userAddress: "",
                    whatToChange: whatToChange)
                self.api_ProfileOfUser()
            case 2:
                self.api_ProfileChange( userName: "",
                                            userSurname: "\(textUser.text!)",
                    userPhone: "",
                    userCountry: 0,
                    userZipcode: "",
                    userAddress: "",
                    whatToChange: whatToChange)
                self.api_ProfileOfUser()
            case 3:
                self.api_ProfileChange( userName: "",
                                            userSurname: "",
                                            userPhone: "\(textUser.text!)",
                    userCountry: 0,
                    userZipcode: "",
                    userAddress: "",
                    whatToChange: whatToChange)
                self.api_ProfileOfUser()
            case 4:
                self.api_ProfileChange( userName: "",
                                            userSurname: "",
                                            userPhone: "",
                                            userCountry: Int(textUser.text!),
                                            userZipcode: "",
                                            userAddress: "",
                                            whatToChange: whatToChange)
                self.api_ProfileOfUser()
            case 5:
                self.api_ProfileChange( userName: "",
                                            userSurname: "",
                                            userPhone: "",
                                            userCountry: 0,
                                            userZipcode: "\(textUser.text!)",
                    userAddress: "",
                    whatToChange: whatToChange)
                self.api_ProfileOfUser()
            case 6:
                self.api_ProfileChange( userName: "",
                                            userSurname: "",
                                            userPhone: "",
                                            userCountry: 0,
                                            userZipcode: "",
                                            userAddress: "\(textUser.text!)",
                    whatToChange: whatToChange)
                self.api_ProfileOfUser()
            default:
                break
            }
        }
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "\(placeholder)"
        }
        
        //Add the buttons
        alertController.addAction(actionCancel)
        alertController.addAction(actionLogin)
        
        //Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
}
