//
//  UserProfileVC + API.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 01.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension UserProfileVC {
    func api_ListOfCountry() {
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)",
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(api_animalID)/country", method: .get, headers: headers).responseJSON { response in
            print("\n========ProfileOfUser========")
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
        }
    }
    
    func api_ProfileOfUser() {
        
        up = []
        
        let id_user = UserDefaults.standard.object(forKey: "id_of_user") as! Int
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        var userName = ""
        var userSurname = ""
        var userEmail = ""
        var userPhone = ""
        var userCountry = ""
        var userZipcode = ""
        var userAddress = ""
        var userAvatar = ""
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)",
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(api_animalID)/owner/\(id_user)", method: .get, headers: headers).responseJSON { response in
            print("\n========ProfileOfUser========")
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            
            if let name = jsonAsSwiftyJSON["data"]["name"].string {
                userName = name
            }
            if let surname = jsonAsSwiftyJSON["data"]["surname"].string {
                userSurname = surname
            }
            if let email = jsonAsSwiftyJSON["data"]["email"].string {
                userEmail = email
            }
            if let phone = jsonAsSwiftyJSON["data"]["phone"].string {
                userPhone = phone
            }
            if let country = jsonAsSwiftyJSON["data"]["country_name"]["name_ua"].string {
                userCountry = country
            }
            if let zipcode = jsonAsSwiftyJSON["data"]["zipcode"].string {
                userZipcode = zipcode
            }
            if let address = jsonAsSwiftyJSON["data"]["address"].string {
                userAddress = address
            }
            if let avatar = jsonAsSwiftyJSON["data"]["avatar"].string {
                userAvatar = avatar
            }
            
            let user = UserProfile(name: userName, surname: userSurname, email: userEmail, phone: userPhone, country: userCountry, zipcode: userZipcode, address: userAddress, avatar: userAvatar)
            self.up.append(user)
            //            DispatchQueue.main.async {
            self.fillProfile()
            //            }
        }
    }
    
    func api_ChangeAvatar(img: Data?) {
        let request = NSMutableURLRequest(url: NSURL(string:"\(api_animalID)/owner/photo")! as URL)
        //        var session = URLSession.shared
        
        request.httpMethod = "POST"
        
        let boundary = NSString(format: "---------------------------14737809831466499882746641449")
        let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        
        // Image
        if let image = img {
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"avatar\"; filename=\"img.jpg\"\\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(image)
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        }
        
        request.httpBody = body as Data
        
        let id_user = UserDefaults.standard.object(forKey: "id_of_user") as! Int
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)",
        ]
        
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            if let dat = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: dat, options: .mutableContainers) as? NSDictionary
                    
                    if let parseJSON = json {
                        print("\n\nREG DATA-----")
                        print(parseJSON)
                        
                        if let x =  parseJSON.value(forKey: "data") {
                            print("registration is okay")
                        } else {
                            print("registration false")
                        }
                        print("-----REG DATA")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            
            guard let data = data, error == nil else {                                         // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {   // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    func api_ProfileChange(userName: String?, userSurname: String?,
                           userPhone: String?, userCountry: Int?,
                           userZipcode: String?, userAddress: String?,
                           whatToChange: Int) {
        
        let id_user = UserDefaults.standard.object(forKey: "id_of_user") as! Int
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        var parameters: [String: Any] = [
            "" : ""
        ]
        
        switch whatToChange {
        case 1:
            parameters = [
                "name" : userName!
            ]
        case 2:
            parameters = [
                "surname": userSurname!
            ]
        case 3:
            parameters = [
                "phone" : userPhone!
            ]
        case 4:
            parameters = [
                "country": userCountry!
            ]
        case 5:
            parameters = [
                "zipcode": userZipcode!
            ]
        case 6:
            parameters = [
                "address": userAddress!
            ]
        default:
            break
        }
        
        print(parameters)
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)"
            //            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        print(id_user)
        Alamofire.request("\(api_animalID)/owner/\(id_user)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                print(response)
                self.api_ProfileOfUser()
        }
    }
    
    func api_getISOOfCountry() {
        
        var countryName = ""
        var countryISO = 804
        
        var langStr = Locale.current.languageCode
        print("language on phone is ====== ", langStr!)
        
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)"
        ]
        
        if langStr == "uk" {
            langStr = "ua"
        } else if langStr == "ru" {
            langStr = "ru"
        } else {
            langStr = "en"
        }
        
        Alamofire.request("\(api_animalID)/country?lang=\(langStr!)", method: .get, headers: headers).responseJSON { response in
            print("\n========ProfileOfUser========")
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            
            if let countries = jsonAsSwiftyJSON["data"].array {
                
                
                
                for country in countries {
                    if let name = country["name_\(langStr!)"].string {
                        countryName = name
                    }
                    if let id_iso = country["id_iso"].int {
                        countryISO = id_iso
                    }
                    let iso = GetCountryISO(countryName: countryName, countryISOCode: countryISO)
                    self.getCountryISO.append(iso)
                }
                DispatchQueue.main.async {
                    self.getISO()
                }
            }
        }
    }
    
    
    
    func getISO () {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "GetISOOfCountryViewController") as! GetISOOfCountryViewController
        myVC.getCountryISO = getCountryISO
        self.navigationController?.pushViewController(myVC, animated: true)
    }

}
