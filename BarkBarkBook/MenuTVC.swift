//
//  MenuTVC.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 23.06.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class MenuTVC: UITableViewCell {

    @IBOutlet weak var iv_animalAvatar: UIImageView!
    @IBOutlet weak var l_animalName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
