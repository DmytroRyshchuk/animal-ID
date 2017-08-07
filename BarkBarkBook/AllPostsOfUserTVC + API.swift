//
//  AllPostsOfUserTVC + API.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 01.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension AllPostsOfUserTableViewCell {
    // Universal func
    func actionWithPost(address: String, method: HTTPMethod, type: String) {
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth_key_user)"
        ]
        
        var parameters: [String: Any] = [:]
        
        if type == "Status" {
            parameters = [
                "post_id": postId,
                "status": statusOfPost
            ]
        } else {
            parameters = [
                "post_id": postId
            ]
        }
        
        Alamofire.request(address, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print("\n========\(type) Post========")
            debugPrint("RESPONSE: ", response.result)
            
            guard let jsonAsDictionary = response.result.value as? [String: Any] else {
                print("Error: (response.result.error)")
                return }
            let jsonAsSwiftyJSON = JSON(jsonAsDictionary)
            
            if method == .delete {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil)
            }
            
            if address == "\(api_animalID)/post/like" {
                self.likesLabel.text = String(jsonAsSwiftyJSON["data"].int!)
            }
        }
    }
}
