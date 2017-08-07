//
//  OpenMenu + API.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 01.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//MARK: - API's openProfile + openListOfAnimals
extension OpenMenu {
    func openProfileOfUser() {
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request("\(api_animalID)/post/animal-posts", method: .get, headers: headers).responseJSON { response in
            print("\n========PostFromAllAnimals========")
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            
        }
    }
    
//    func openListOfAnimals(view: UIViewController) {
//        
//        userAnimalsDetailsArray = []
//        
//        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(auth_key_user)"
//        ]
//        
//        Alamofire.request("\(api_animalID)/owner/animals", method: .get, headers: headers).responseJSON { response in
//            print("\n========api_UserAnimals========")
//            debugPrint("RESPONSE: ", response.result)
//            
//            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
//                print("Error: (response.result.error)")
//                return }
//            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
//            
//            
//            if let data = jsonAsSwiftyJSON["data"].array {
//                
//                for json in data {
//                    if let photo = json["photo"].string {
//                        self.photoOfAnimalFromJson = photo
//                        print(photo)
//                    } else {
//                        self.photoOfAnimalFromJson = ""
//                    }
//                    if let nickname = json["nickname"].string {
//                        self.nicknameOfAnimalFromJson = nickname
//                    }
//                    if let species = json["species"].string {
//                        self.speciesOfAnimalFromJson = species
//                    }
//                    if let sex = json["sex"].int {
//                        self.sexOfAnimalFromJson = sex
//                    }
//                    if let id = json["id"].int {
//                        self.idOfAnimalFromJson = id
//                    }
//                    if let transponder = json["transponder"].string {
//                        self.transponderOfAnimalFromJson = transponder
//                    }
//                    
//                    let uad = UserAnimalsDetails(photo: self.photoOfAnimalFromJson,
//                                                 nickname: self.nicknameOfAnimalFromJson,
//                                                 species: self.speciesOfAnimalFromJson,
//                                                 sex: self.sexOfAnimalFromJson,
//                                                 id: self.idOfAnimalFromJson,
//                                                 transponder: self.transponderOfAnimalFromJson)
//                    
//                    self.userAnimalsDetailsArray.append(uad)
//                }
//                
//                DispatchQueue.main.async {
//                    moveToUserAnimalsList(view: view)
//                }
//            }
//        }
//      }
    
    func openListOfAnimals (view: UIViewController) {
        let myVC = view.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        
        view.navigationController?.pushViewController(myVC, animated: true)
    }

    
    func api_ProfileOfUser(view: UIViewController) {
        
        userProfilePage = []
        print("idOfAnimal")
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
            self.userProfilePage.append(user)
            self.moveToListOfAnimalPage(view: view)
        }
    }
    
    func moveToListOfAnimalPage(view: UIViewController) {
        let upvc = view.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        
        upvc.up = self.userProfilePage
        
        view.navigationController?.pushViewController(upvc, animated: true)
    }


}
