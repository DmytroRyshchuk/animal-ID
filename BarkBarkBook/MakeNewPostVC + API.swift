//
//  MakeNewPostVC + API.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 01.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

//MARK: - Api's
extension MakeNewPostViewController {
    //MARK: - Send data to server - API
    func api_CreateNewPost() {
        var codeJSON = 0
        var contentJSON = ""
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        let auth_key_user = "\(String(describing: UserDefaults.standard.object(forKey: "auth_key_user")!))"
        
        let parameters: [String: Any] = [
            "animal_id": SharingManager.sharedInstance.idOfAnimal,
            "content": textInPostTextView.text!,
            "status" : statusOfPost,
            "files" : photosFromUserInPostArray
        ]
        
        print(parameters)
        
        let request = NSMutableURLRequest(url: NSURL(string:"\(api_animalID)/post")! as URL)
        //        var session = URLSession.shared
        
        request.httpMethod = "POST"
        
        let boundary = NSString(format: "---------------------------14737809831466499882746641449")
        let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        
        // animal_id
        body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format:"Content-Disposition: form-data; name=\"animal_id\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append("\(SharingManager.sharedInstance.idOfAnimal)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        
        
        // content
        body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format:"Content-Disposition: form-data; name=\"content\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append("\(textInPostTextView.text!)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        
        
        // status
        body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format:"Content-Disposition: form-data; name=\"status\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append("\(statusOfPost)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        
        
        
        // Image
        for i in 0..<photosFromUserInPostArray.count {
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"files[]\"; filename=\"img\(i).jpg\"\\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            
            let imageOrintationIsOkay = self.sFunc_imageFixOrientation(img: photosFromUserInPostArray[i])
            //var timageOrintationIsOkay = imageOrintationIsOkay.scaleImage(toSize: CGSize(width: 200, height: 200))
            //let data = UIImagePNGRepresentation(timageOrintationIsOkay!) as NSData?
            //print("data = ", timageOrintationIsOkay)
            
            let imageData = imageOrintationIsOkay.jpeg(.medium)
            imageT = scaledImage(UIImage(data: imageData!)!, maximumWidth: 400)
            
            let data = UIImagePNGRepresentation(imageT) as NSData?
            body.append(data! as Data)
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
                        
                        if parseJSON.value(forKey: "code") as? Int == 200 {
                            self.moveToPostVC = true
                            DispatchQueue.main.async {
                                self.moveToPostVCFunc()
                            }
                        } else {                            
                            codeJSON = parseJSON.value(forKey: "code") as! Int
                        }
                        
                        if let data = parseJSON.value(forKey: "data") as? [String: Any] {
                            if let content = data["content"] as? [String] {
                                for cont in 0..<content.count {
                                    contentJSON += content[cont] + "\n"
                                }
                            }
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
            
            if codeJSON != 0 {
                self.alert(code: codeJSON, content: contentJSON)
            }
        }
        task.resume()
        photosFromUserInPostArray = []
        textInPostTextView.text = ""
        photosOfAnimalInCollectionView.reloadData()
    }
    
    func moveToPostVCFunc() {
        if moveToPostVC {
            self.tabBarController?.selectedIndex = 0
            self.moveToPostVC = false
        }
    }
}
