//
//  AllAnimalsOfUserTableViewCell.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 10.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class AllAnimalsOfUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idOfAnimalIsHidden: UILabel!
    @IBOutlet weak var avatarOfAnimalImage: UIImageView!
    @IBOutlet weak var nicknameOfAnimal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        idOfAnimalIsHidden.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptAnimalButton(_ sender: Any) {
        SharingManager.sharedInstance.nicknameOfAnimal = nicknameOfAnimal.text!
        SharingManager.sharedInstance.idOfAnimal = Int(idOfAnimalIsHidden.text!)!
        SharingManager.sharedInstance.photoOfAnimal = avatarOfAnimalImage.image!
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "choosenAnimalFromApi"), object: nil)
    }
}
