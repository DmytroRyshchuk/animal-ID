//
//  GetISOOfCountryTableViewCell.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 17.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class GetISOOfCountryTableViewCell: UITableViewCell {

    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var isoOfCountryIsHidden: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isoOfCountryIsHidden.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func ba_accept(_ sender: Any) {
        SharingManager.sharedInstance.countryName = countryNameLabel.text!
        SharingManager.sharedInstance.isoOfCountry = Int(isoOfCountryIsHidden.text!)!
    }
}
