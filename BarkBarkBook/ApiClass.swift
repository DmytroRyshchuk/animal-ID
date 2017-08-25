//
//  ApiClass.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 22.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiClass {

    var animalNamesOfUserArray = [ChooseAnimalForMakeNewPost]()
    var nicknameOfAnimalFromJson = ""
    var idOfAnimalFromJson = 0
    var photoOfAnimalFromJson = ""
    
    //MARK: - Get first animal of user to choose in post
    func getFirstUserAnimalToPostAPI(delegate: UIViewController, activityIndicator: UIActivityIndicatorView) {
        animalNamesOfUserArray = []
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)"
        ]
        
        Alamofire.request("\(api_animalID)/owner/animals", method: .get, headers: headers).responseJSON { response in
            print("\n========api_UserAnimals========")
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            if let data = jsonAsSwiftyJSON["data"].array {
                
                for json in data {
                    if let photo = json["photo"].string {
                        self.photoOfAnimalFromJson = photo
                        print(photo)
                    } else {
                        self.photoOfAnimalFromJson = ""
                    }
                    if let nickname = json["nickname"].string {
                        self.nicknameOfAnimalFromJson = nickname
                    }
                    if let id = json["id"].int {
                        self.idOfAnimalFromJson = id
                    }
                    let chooseAnimalForMakeNewPost = ChooseAnimalForMakeNewPost(nickname: self.nicknameOfAnimalFromJson,
                                                                                id: self.idOfAnimalFromJson,
                                                                                photo: self.photoOfAnimalFromJson)
                    
                    self.animalNamesOfUserArray.append(chooseAnimalForMakeNewPost)
                }
                
                DispatchQueue.main.async {
                    self.getFirstAnimal(delegate: delegate)
                }
            }
        }
    }
    
    func getFirstAnimal(delegate: UIViewController) {
        var id = 0
        var nickname = ""
        var photo = ""
        
        guard animalNamesOfUserArray.count != 0 else {
            return
        }
        
        for _ in 0..<animalNamesOfUserArray.count {
            id = animalNamesOfUserArray[0].id
            nickname = animalNamesOfUserArray[0].nickname
            photo = animalNamesOfUserArray[0].photo!
        }
        
        
        let urlString = photo
        
        let url = NSURL(string: urlString)
        
        if url != nil {
            if self.animalNamesOfUserArray[0].photo == "" {
                SharingManager.sharedInstance.photoOfAnimal = UIImage(named: "Dof-for-ios")!
            } else {
                let url = URL(string: self.animalNamesOfUserArray[0].photo!)
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                SharingManager.sharedInstance.photoOfAnimal = UIImage(data: data!)!
            }
        }
        
        SharingManager.sharedInstance.nicknameOfAnimal = nickname
        SharingManager.sharedInstance.idOfAnimal = id
        print("n = ", nickname)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "firstAnimalFromApi"), object: nil)
    }
    
    
    
    //MARK: - Get all animals of user to choose in post
    func allAnimalsOfUserAPI(del: UIViewController) {
        animalNamesOfUserArray = []
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)"
        ]
        
        Alamofire.request("\(api_animalID)/owner/animals", method: .get, headers: headers).responseJSON { response in
            print("\n========api_UserAnimals========")
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            
            
            if let data = jsonAsSwiftyJSON["data"].array {
                
                for json in data {
                    if let photo = json["photo"].string {
                        self.photoOfAnimalFromJson = photo
                        print(photo)
                    } else {
                        self.photoOfAnimalFromJson = ""
                    }
                    if let nickname = json["nickname"].string {
                        self.nicknameOfAnimalFromJson = nickname
                    }
                    if let id = json["id"].int {
                        self.idOfAnimalFromJson = id
                    }
                    let chooseAnimalForMakeNewPost = ChooseAnimalForMakeNewPost(nickname: self.nicknameOfAnimalFromJson,
                                                                                id: self.idOfAnimalFromJson,
                                                                                photo: self.photoOfAnimalFromJson)
                    
                    self.animalNamesOfUserArray.append(chooseAnimalForMakeNewPost)
                }
                
                DispatchQueue.main.async {
                    let myVC = del.storyboard?.instantiateViewController(withIdentifier: "AllAnimalsOfUserViewController") as! AllAnimalsOfUserViewController
                    myVC.allAnimalsOfUserArray = self.animalNamesOfUserArray
                    del.navigationController?.pushViewController(myVC, animated: true)
                }
            }
        }
    }
}
