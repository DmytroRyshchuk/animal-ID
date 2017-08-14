//
//  AllAnimalsOfUserViewController.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 10.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class AllAnimalsOfUserViewController: UIViewController {

    var allAnimalsOfUserArray = [ChooseAnimalForMakeNewPost]()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction private func acceptAnimalButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}




//MARK: - TableView
extension AllAnimalsOfUserViewController: UITableViewDataSource, UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAnimalsOfUserArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AllAnimalsOfUserTableViewCell
        
        let nickname = allAnimalsOfUserArray[indexPath.row].nickname
        let id = allAnimalsOfUserArray[indexPath.row].id
        
        cell.nicknameOfAnimal.text = String(describing: nickname)
        cell.idOfAnimalIsHidden.text = String(describing: id)
        
        let urlString = allAnimalsOfUserArray[indexPath.row].photo
        
        let url = NSURL(string: urlString!)
        
        if url != nil {
            cell.avatarOfAnimalImage.sd_setImage(with: url! as URL)
            cell.avatarOfAnimalImage.layer.masksToBounds = false
            cell.avatarOfAnimalImage.layer.cornerRadius = cell.avatarOfAnimalImage.frame.height/2 - 2
            cell.avatarOfAnimalImage.clipsToBounds = true
            
            
            if self.allAnimalsOfUserArray[indexPath.row].photo == "" {
                cell.avatarOfAnimalImage.image = UIImage(named: "Dof-for-ios")
            }
        }
        
        return cell
    }

}

