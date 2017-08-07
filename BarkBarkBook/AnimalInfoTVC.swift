//
//  AnimalInfoTableViewCell.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 04.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class AnimalInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var animalAvatarImage: UIImageView!
    @IBOutlet weak var animalNicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
