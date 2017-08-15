//
//  Api_Login.swift
//  AnimalBook
//
//  Created by Dmytro Ryshchuk on 18.05.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension LoginVC {
    
    func base64Password() {
        var str = "\(tf_email.text!.lowercased()):\(tf_password.text!)"
        print("Original: \(str)")
        
        let utf8str = str.data(using: String.Encoding.utf8)
        
        if let base64Encoded = utf8str?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
            str = base64Encoded
        }
        
        UserDefaults.standard.setValue(str, forKey: "loginData")
        print("str = ", str)
        api_LogIn()
    }
    
    func api_LogIn() {
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(UserDefaults.standard.string(forKey: "loginData")!)",
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(api_animalID)/auth/login", method: .get, headers: headers).responseJSON { response in
            print("\n========Login========")
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            
            
            if let auth_key = jsonAsSwiftyJSON["data"]["auth_key"].string {
                print("auth_key = ", auth_key)
                self.auth_key_user = auth_key
                UserDefaults.standard.set(auth_key, forKey: "auth_key_user")
            } else {
                //self.alertFunc()
            }
            if let id = jsonAsSwiftyJSON["data"]["id"].int {
                print("id = ", id)
                self.id_user = id
                UserDefaults.standard.set(id, forKey: "id_of_user")
            }
            if let code = jsonAsSwiftyJSON["code"].int {
                if code != 200 {
                    switch code {
                    case 403: self.alert(title: "Error", message: "You can't authorize with this account")
                    case 401: self.alert(title: "Error", message: "You use wrong login or password")
                    default: self.alert(title: "Error", message: "Please connect with developer team")
                    }
                }
            }
            
            if let avatar = jsonAsSwiftyJSON["data"]["avatar"].string {
                SharingManager.sharedInstance.avatar = avatar
                self.moveToAllPostsOfUser()
            }
        }
    }
    
    func moveToAllPostsOfUser() {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AllPostsOfUserTabBarController") as! AllPostsOfUserTabBarController
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    func alert(title: String, message: String) {
        viewShaker?.shake(withDuration: 0.6, completion: {() -> Void in
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
        })
    }
}


