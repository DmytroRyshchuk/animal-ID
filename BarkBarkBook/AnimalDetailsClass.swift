//
//  AnimalDetailsClass.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 23.06.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserAnimalsDetails {
    
    var photo = ""
    var nickname = ""
    var species = ""
    var sex = 0
    var id = 0
    var transponder = ""
    
    init(photo: String, nickname: String, species: String, sex: Int, id: Int, transponder: String) {
        self.photo = photo
        self.nickname = nickname
        self.species = species
        self.sex = sex
        self.id = id
        self.transponder = transponder
    }
    
    init() { }
}


extension MenuVC {
    func openListOfAnimals(view: UIViewController) {
        userAnimalsArray = []
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        var speciesOfAnimalFromJson = ""
        var sexOfAnimalFromJson = 0
        var transponderOfAnimalFromJson = ""
        var photoOfAnimalFromJson = ""
        var nicknameOfAnimalFromJson = ""
        var idOfAnimalFromJson = 0
        
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
                        photoOfAnimalFromJson = photo
                        print(photo)
                    } else {
                        photoOfAnimalFromJson = ""
                    }
                    if let nickname = json["nickname"].string {
                        nicknameOfAnimalFromJson = nickname
                    }
                    if let species = json["species"].string {
                        speciesOfAnimalFromJson = species
                    }
                    if let sex = json["sex"].int {
                        sexOfAnimalFromJson = sex
                    }
                    if let id = json["id"].int {
                        idOfAnimalFromJson = id
                    }
                    if let transponder = json["transponder"].string {
                        transponderOfAnimalFromJson = transponder
                    }
                    
                    let uad = UserAnimalsDetails(photo: photoOfAnimalFromJson,
                                                 nickname: nicknameOfAnimalFromJson,
                                                 species: speciesOfAnimalFromJson,
                                                 sex: sexOfAnimalFromJson,
                                                 id: idOfAnimalFromJson,
                                                 transponder: transponderOfAnimalFromJson)
                    
                    self.userAnimalsArray.append(uad)
                }
                
                DispatchQueue.main.async {
                    self.userAnimalsArray.reverse()
                    self.tableView.reloadData()
                    self.userAnimalsArray.isEmpty ? self.ifTableViewIsEmpty(status: true) : self.ifTableViewIsEmpty(status: false)
                    
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
