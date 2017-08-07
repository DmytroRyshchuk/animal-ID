//
//  TableViewMenu.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 07.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

extension MenuVC: UITableViewDataSource {
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAnimalsArray.count
    }

//    func numberOfSections(in tableView: UITableView) -> Int {
//        if userAnimalsArray.count > 0 {
//            self.tableView.backgroundView = nil
//            self.tableView.separatorStyle = .singleLine
//            return 1
//        }
//        
//        self.tableView.separatorStyle = .none
//        
//        ifTableViewIsEmpty()
//        return 0
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        print("set ID")
        print(userAnimalsArray[indexPath.row].id)
        //TODO : Check here!!!
        UserDefaults.standard.set(userAnimalsArray[indexPath.row].nickname, forKey: "nicknameOfAnimal")
        UserDefaults.standard.set(userAnimalsArray[indexPath.row].photo, forKey: "photoOfAnimal")
        print(userAnimalsArray[indexPath.row].nickname)
        print(userAnimalsArray[indexPath.row].photo)
        UserDefaults.standard.set(userAnimalsArray[indexPath.row].id, forKey: "idOfAnimal")
        apiNewsFeedOfChoosenAnimal()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTVC
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let nickname = userAnimalsArray[indexPath.row].nickname
        cell.l_animalName.text = String(describing: nickname)
        //        cell.idOfAnimal = String(userAnimalsArray[indexPath.row].id)
        
        let urlString = userAnimalsArray[indexPath.row].photo
        
        let url = NSURL(string: urlString)
        
        if url != nil {
            cell.iv_animalAvatar.sd_setImage(with: url! as URL)
            cell.iv_animalAvatar.layer.masksToBounds = false
            cell.iv_animalAvatar.layer.cornerRadius = cell.iv_animalAvatar.frame.height/2 - 2
            cell.iv_animalAvatar.clipsToBounds = true
            
            
            if self.userAnimalsArray[indexPath.row].photo == "" {
                cell.iv_animalAvatar.image = UIImage(named: "Dof-for-ios")
            }
        }
        
        return cell
    }
}
