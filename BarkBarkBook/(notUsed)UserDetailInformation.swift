//
//  UserDetailInformation.swift
//  AnimalBook
//
//  Created by Dmytro Ryshchuk on 08.06.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//
/*
import Foundation
import Alamofire
import SwiftyJSON
import SDWebImage

extension UserDetailInformationOfAnimalViewController {
    
    func api() {
        
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        let idOfAnimal = "\(String(describing: UserDefaults.standard.object(forKey: "idOfAnimal")!))"
        print("id2 = ", idOfAnimal)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)"
        ]
        
        Alamofire.request("http://api.animal-id.info/v1/animal/\(idOfAnimal)", method: .get, headers: headers).responseJSON { response in
            print("\n========UserDetailInformationOfAnimalViewController========")
            //debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            
            if let role = jsonAsSwiftyJSON["data"]["_user"]["role"].string {
                self.l_role.text = role
            }
            if let birth_date = jsonAsSwiftyJSON["data"]["birth_date"].string {
                self.l_birth_date.text = birth_date
            }
            if let breed = jsonAsSwiftyJSON["data"]["breed"].string {
                self.l_breed.text = breed
            }
            if let nickname = jsonAsSwiftyJSON["data"]["nickname"].string {
                self.l_nickname.text = nickname
            }
            
            if let photos = jsonAsSwiftyJSON["data"]["photos"].array {
                
                for i in photos {
                    
                    let url = URL(string: i["_link"].string!)
                    
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    print("data = ", data)
                    self.iv_imageOfAnimal.image = UIImage(data: data!)
                    self.iv_imageOfAnimal.layer.cornerRadius = self.iv_imageOfAnimal.frame.height/2
                    self.iv_imageOfAnimal.clipsToBounds = true
                }
            }
            
            
            
            if let register_date = jsonAsSwiftyJSON["data"]["register_date"].string {
                self.l_register_date.text = register_date
            }
            if let sex = jsonAsSwiftyJSON["data"]["sex"].int {
                switch sex {
                case 0: self.l_sex.text = "female"//SexOfAnimal.female.rawValue
                case 1: self.l_sex.text = "male"//SexOfAnimal.male.rawValue
                default: break
                }
            }
            if let species = jsonAsSwiftyJSON["data"]["species"].string {
                self.l_species.text = species
            }
            
            
            
                /*
                 let spe = species.values
                 print(spe)
                 let spec = SpeciesClass(speciesDict: species)
                 self.speciesTypeDict.append(spec)
                 */
                DispatchQueue.main.async {
//                    self.moveToListOfAnimalPage()
                }
            }
        
        print("\n================")
        print()
//        let feedOfChoosenAnimal = FeedOfChoosenAnimal()
        getApi()
        }
    /*
    func api2() {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChooseSpeciesViewController") as! ChooseSpeciesViewController
        //        if isInternetAvailible {
        //            myVC.animalListCheck = self.animalList
        //        }
        //        myVC.speciesTypeDict = speciesTypeDict
//        myVC.speciesTypeDict = speciesTypeDict
        self.navigationController?.pushViewController(myVC, animated: true)
    }*/
}

class UserAnimalsDetailsFullInformation {
    
    var _father_transponder = ""
    var _mother_transponder = ""
    var _short_description = ""
    
    //    var avatar = ""
    //    var idUser = 0
    //    var role = ""
    //    var show_profile = 0
    //    var name = ""
    //    var surname = ""
    //    var org_name = ""
    
    var _user = UserAnimalsDetailsFullInformationAboutUser()
    
    var birth_date = ""
    var breed = ""
    var color = ""
    var idAnimal = 0
    var nickname = ""
    var photos = [UserAnimalsDetailsPhotosArray]()
    var register_date = ""
    var sex = 0
    var species = ""
    var sterilization = 0
    var token = ""
    var transponder = ""
    
    
    init() {
        
    }
    
    //init() { }
}

class UserAnimalsDetailsPhotosArray {
    
    var _link = ""
    var id = 0
    var main = 0
    
    init(_link: String, id: Int, main: Int) {
        self._link = _link
        self.id = id
        self.main = main
    }
    
    init() { }
}

class UserAnimalsDetailsFullInformationAboutUser {
    var avatar = ""
    var idUser = 0
    var role = ""
    var show_profile = 0
    var name = ""
    var surname = ""
    var org_name = ""
    
    init(avatar: String, idUser: Int, role: String, show_profile: Int, name: String, surname: String, org_name: String) {
        self.avatar = avatar
        self.idUser = idUser
        self.role = role
        self.show_profile = show_profile
        self.name = name
        self.surname = surname
        self.org_name = org_name
    }
    
    init() { }
}
*/
