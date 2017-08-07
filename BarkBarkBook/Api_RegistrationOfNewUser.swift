//
//  Api_RegistrationOfNewUser.swift
//  AnimalBook
//
//  Created by Dmytro Ryshchuk on 23.05.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftValidator

extension RegisterNewUserVC {
    
    func api_RegistrationOfNewUser(name: String, surname: String, phone: String, email: String, password: String, zipcode: String, countryISO: Int, address: String, language: String) {
        
        var country = countryISO
        if country == 0 {
            country = 804
        }
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "name" : name,
            "surname" : surname,
            "phone" : phone,
            "zipcode" : zipcode,
            "country" : country,
            "address" : address,
            "language" : language
        ]
        print(parameters)
        
        Alamofire.request("\(api_animalID)/auth/registration", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("\n========RegistrationOfNewUser========")
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            
            if let password = jsonAsSwiftyJSON["data"]["password"].array {
                for data in password {
                    self.validator.registerField(self.tf_password, errorLabel: self.passwordWrongLabel, rules: [MinLengthRule(length: 6), RequiredRule(message: String(describing: data))])
                }
            }
            
            if let email = jsonAsSwiftyJSON["data"]["email"].array {
                for data in email {
                    self.validator.registerField(self.tf_email, errorLabel: self.emailWrongLabel, rules: [EmailRule(message: String(describing: data))])
                }
            }
            if let name = jsonAsSwiftyJSON["data"]["name"].array {
                for data in name {
                    self.validator.registerField(self.tf_name, errorLabel: self.firstNameWrongLabel, rules: [RequiredRule(message: String(describing: data))])
                }
            }
            if let surname = jsonAsSwiftyJSON["data"]["surname"].array {
                for data in surname {
                    self.validator.registerField(self.tf_surname, errorLabel: self.surnameWrongLabel, rules: [RequiredRule(message: String(describing: data))])
                }
            }
            if let phone = jsonAsSwiftyJSON["data"]["phone"].array {
                for data in phone {
                    self.validator.registerField(self.tf_phone, errorLabel: self.phoneWrongLabel, rules: [PhoneNumberRule(message: String(describing: data))])
                }
            }
            if let zipcode = jsonAsSwiftyJSON["data"]["zipcode"].array {
                for data in zipcode {
                    self.validator.registerField(self.zipcodeTextField, errorLabel: self.zipcodeWrongLabel, rules: [RequiredRule(message: String(describing: data))])
                }
            }
            if let address = jsonAsSwiftyJSON["data"]["address"].array {
                for data in address {
                    self.validator.registerField(self.addressTextField, errorLabel: self.addressWrongLabel, rules: [RequiredRule(message: String(describing: data))])
                }
            }
            
            if let auth_key = jsonAsSwiftyJSON["data"]["auth_key"].string {
                print(auth_key)
                UserDefaults.standard.setValue(auth_key, forKey: "auth_key_user")
            }
            
            if let id = jsonAsSwiftyJSON["data"]["id"].int {
                UserDefaults.standard.set(id, forKey: "id_of_user")
                UserDefaults.standard.set("true", forKey: "RegistrationOfNewUse")
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AllPostsOfUserTabBarController") as! AllPostsOfUserTabBarController
                
                self.navigationController?.pushViewController(myVC, animated: true)
            }
            
            
            self.validator.validate(self)
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
