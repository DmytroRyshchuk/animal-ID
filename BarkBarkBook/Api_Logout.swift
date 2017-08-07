//
//  Api_Logout.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 25.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension AllPostsOfUserViewController {
    func api_LogOut() {
        UserDefaults.standard.set("", forKey: "auth_key_user")
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logoutInTabBar"), object: nil)
        
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)",
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(api_animalID)/auth/logout", method: .post, headers: headers).responseJSON { response in
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return
            }
            
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            print("JSONASSWIFTYJSON LogOut: ", jsonAsSwiftyJSON)
            if let data = jsonAsSwiftyJSON["success"].bool {
                print("data: ", data)
            }
            if let data = jsonAsSwiftyJSON["success"].bool {
                print("success: ", data)

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateInitialViewController()
                appDelegate.window?.rootViewController = loginVC

            }
        }
    }
}
