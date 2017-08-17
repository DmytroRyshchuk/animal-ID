//
//  GetIOSOfCountryGetData.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 17.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//MARK: - API - get ISO of Countries
extension RegisterNewUserVC {
    
    func api_getISOOfCountry() {
        
        var countryName = ""
        var countryISO = 804
        
        var langStr = Locale.current.languageCode
        print("language on phone is ====== ", langStr!)
        
        if langStr == "uk" {
            langStr = "ua"
        } else if langStr == "ru" {
            langStr = "ru"
        } else {
            langStr = "en"
        }
        
        Alamofire.request("\(api_animalID)/country?lang=\(langStr!)", method: .get).responseJSON { response in
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
                    self.moveToListOfAnimalPage()
                }
            }
        }
    }
    
    
    
    func moveToListOfAnimalPage () {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "GetISOOfCountryViewController") as! GetISOOfCountryViewController
        myVC.getCountryISO = getCountryISO
        self.navigationController?.pushViewController(myVC, animated: true)
    }
}

