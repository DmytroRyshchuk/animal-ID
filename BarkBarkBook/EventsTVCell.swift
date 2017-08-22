//
//  EventsTVCell.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 22.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class EventsTVCell: UITableViewCell {
    
    @IBOutlet weak var nicknameOfAnimal: UILabel!
    @IBOutlet weak var dateOfEvent: UILabel!
    @IBOutlet weak var eventText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
