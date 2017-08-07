//
//  Api_GetAllSpecies.swift
//  AnimalBook
//
//  Created by Dmytro Ryshchuk on 31.05.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension RegisterNewAnimalViewController {
    
    func api_getAllSpeciesOfAnimal() {

        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)"
        ]
        
        Alamofire.request("\(api_animalID)/animal/species", method: .get, headers: headers).responseJSON { response in
            print("\n========ProfileOfUser========")
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            
            if let species = jsonAsSwiftyJSON["data"].dictionary {
                self.speciesTypeDict = []
                print("\n\nAll species: ", species)
                
                for (key, value) in species {
                    print(value)
                    
                    let sp = SpeciesClass(key: key, value: String(describing: value))
                    self.speciesTypeDict.append(sp)
                }

                
                DispatchQueue.main.async {
                    self.moveToListOfAnimalPage()
                }
            }
        }
    }
    
    
    
    func moveToListOfAnimalPage () {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChooseSpeciesViewController") as! ChooseSpeciesViewController

        myVC.speciesTypeDict = speciesTypeDict
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    func registerNewAnimalOnServer(microchip: Int?,
                                   transponder: String?,
                                   species: Int?,
                                   breed: String?,
                                   sex: Int?,
                                   nickname: String?,
                                   birthday: String?,
                                   photo: Data?) {
        
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        let parameters: [String: Any] = [
            "microchip": microchip,
            "transponder": transponder,
            "species" : species,
            "breed" : breed,
            "sex" : sex,
            "nickname" : nickname,
            "birth_date" : birthday,
            "photo" : photo
        ]
        
        print(parameters)
        
        let request = NSMutableURLRequest(url: NSURL(string:"\(api_animalID)/animal")! as URL)
        //        var session = URLSession.shared
        
        request.httpMethod = "POST"
        
        let boundary = NSString(format: "---------------------------14737809831466499882746641449")
        let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        
        // Microchip
        if let micro = microchip {
            body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"microchip\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append("\(micro)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        }
        
        // Transponder
        if let trans = transponder {
            body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"transponder\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append("\(trans)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        }
        
        // Species
        if let spec = species {
            body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"species\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append("\(spec)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        }
        
        // Breed
        if let bre = breed {
            body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"breed\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append("\(bre)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        }
        
        // Sex
        if let s = sex {
            body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"sex\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append("\(s)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        }
        
        // Nickname
        if let nick = nickname {
            body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"nickname\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append("\(nick)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        }
        
        // Birth_date
        if let birth = birthday {
            body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"birth_date\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append("\(birth)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        }
        
        // Image
        if let image = photo {
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"photo\"; filename=\"img.jpg\"\\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(image)
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        }
        
        
        
        
        request.httpBody = body as Data
        
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
                        
                        if let x = parseJSON.value(forKey: "code") {
                            if x as? Int == 200 {
                                print("registration is okay")
                                                    
                                self.openListOfAnimalPage()
                            } else {
                                print("registration false")
                            }
                        }
                        DispatchQueue.main.async {                                                    
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
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

}
