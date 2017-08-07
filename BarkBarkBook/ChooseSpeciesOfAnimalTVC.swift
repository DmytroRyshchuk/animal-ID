//
//  ChooseSpeciesOfAnimalTableViewCell.swift
//  AnimalBook
//
//  Created by Dmytro Ryshchuk on 31.05.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class ChooseSpeciesOfAnimalTableViewCell: UITableViewCell {

    @IBOutlet weak var l_species: UILabel!
    @IBOutlet weak var l_key_isHidden: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        l_key_isHidden.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func ba_accept(_ sender: Any) {
        SharingManager.sharedInstance.value = l_species.text!
        SharingManager.sharedInstance.key = l_key_isHidden.text!
    }
}
