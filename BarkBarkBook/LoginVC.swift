//
//  LoginVC.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 21.06.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AFViewShaker

class LoginVC: UIViewController {
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet var allTextFields: [Any]!
    @IBOutlet var allButtons: [UIButton]!
    var viewShaker: AFViewShaker?
    
    let setView = SetView()
    
    var photoOfAnimalFromJson = ""
    var nicknameOfAnimalFromJson = ""
    var speciesOfAnimalFromJson = ""
    var idOfAnimalFromJson = 0
    var sexOfAnimalFromJson = 0
    var transponderOfAnimalFromJson = ""
    
    var userAnimalsDetailsArray = [UserAnimalsDetails]()
    var allPostsOfUserArray = [UserContent]()
    
    var auth_key_user = ""
    var id_user = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.logIn()
        
        self.hideKeyboardWhenTappedAround()
        cleanUserDefaults()
        
        self.viewShaker = AFViewShaker(viewsArray: allTextFields)
        
        setView.setRadius(elements: allButtons)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        userAnimalsDetailsArray = []
    }
    
    //MARK: - Actions    
    @IBAction private func ba_logIn(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            base64Password()
            tf_password.resignFirstResponder()
        } else {
            print("Internet lost")
            Reachability.alertInternetLost(view: self)
        }
    }
    
    @IBAction private func ba_forgotThePassword(_ sender: Any) {
        print(UserDefaults.standard.string(forKey: "loginData")!)
    }

    @IBAction private func ba_registerNewUser(_ sender: Any) {
        //TODO: API in works
    }
    
    func cleanUserDefaults() {
//        UserDefaults.standard.set("", forKey: "id_of_user")
//        UserDefaults.standard.set("", forKey: "auth_key_user")
        UserDefaults.standard.set("", forKey: "idOfAnimal")
        UserDefaults.standard.set("", forKey: "loginData")
        UserDefaults.standard.set("", forKey: "nicknameOfAnimal")
        UserDefaults.standard.set("", forKey: "photoOfAnimal")
    }
}

extension LoginVC: UITextFieldDelegate {
    //MARK: - Text Field Logic
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tf_email {
            tf_password.becomeFirstResponder()
        } else {
            base64Password()
            tf_password.resignFirstResponder()
        }
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
