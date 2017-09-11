//
//  RegisterNewUserVC.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 21.06.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import SwiftValidator

class RegisterNewUserVC: UIViewController, ValidationDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_surname: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var firstNameWrongLabel: UILabel!
    @IBOutlet weak var surnameWrongLabel: UILabel!
    @IBOutlet weak var emailWrongLabel: UILabel!
    @IBOutlet weak var phoneWrongLabel: UILabel!
    @IBOutlet weak var passwordWrongLabel: UILabel!
    @IBOutlet weak var zipcodeWrongLabel: UILabel!
    @IBOutlet weak var addressWrongLabel: UILabel!
    
    @IBOutlet var makeButtonRounded: [UIButton]!
    
    var getCountryISO = [GetCountryISO]()
    var langOnPhone: String? = ""
    let validator = Validator()
    let setView = SetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        langaugeOnPhone()
        validatorInViewDidLoad()
    
        activityIndicator.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        setView.setRadius(elements: makeButtonRounded)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if SharingManager.sharedInstance.countryName != "" {
            countryLabel.text = SharingManager.sharedInstance.countryName
        }
    }

    //MARK: - Actions
    @IBAction func ba_registerNewUser(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            if tf_name.text != "" || tf_surname.text != "" || tf_phone.text != "" || tf_email.text != "" || tf_password.text != "" || zipcodeTextField.text != "" || addressTextField.text != "" || countryLabel.text != "" {
                api_RegistrationOfNewUser(name: tf_name.text!, surname: tf_surname.text!,
                                          phone: tf_phone.text!, email: tf_email.text!,
                                          password: tf_password.text!, zipcode: zipcodeTextField.text!,
                                          countryISO: SharingManager.sharedInstance.isoOfCountry,
                                          address: addressTextField.text!, language: langOnPhone!)
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            } else {
                alerts(title: "Please, filled all fields", message: "")
            }
        } else {
            print("Internet lost")
            Reachability.alertInternetLost(view: self)
        }
    }
    
    @IBAction func chooseCountryButtonAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            api_getISOOfCountry()
        } else {
            print("Internet lost")
            Reachability.alertInternetLost(view: self)
        }
    }
    
    
    @IBAction func ba_goBackToLoginPage(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func userPoliticsOnWebSite(_ sender: Any) {
        if let url = URL(string: "https://animal-id.info/ua/site/terms-use") {
            UIApplication.shared.openURL(url)
        }
    }
    
    //MARK: - Alerts
    func alerts(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func langaugeOnPhone() {
        langOnPhone = Locale.current.languageCode
        if langOnPhone == "uk" {
            langOnPhone = "ua"
            countryLabel.text = "Україна"
        } else if langOnPhone == "ru" {
            countryLabel.text = "Украина"
        } else {
            countryLabel.text = "Ukraine"
        }
    }
    
    
    //MARK: - Validate
    func validatorInViewDidLoad() {
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
                textField.layer.cornerRadius = 5
                
            }
        }, error:{ (validationError) -> Void in
            print("error")
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
                textField.layer.cornerRadius = 5
            }
        })
    }
    
    func validationSuccessful() {
        print("Validation SUCCESS!")
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        print("Validation FAILED!")
    }
}


extension RegisterNewUserVC: UITextFieldDelegate {
    //MARK: - Text Field Logic
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - up screen when keyboard appear
    func animateTextField(textField: UITextField, up: Bool) {
        let movementDistance:CGFloat = -100
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up {
            movement = movementDistance
        }
        else {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up:false)
    }
}
