//
//  EventsVC.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 21.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class EventsVC: UIViewController {
 
    let setView = SetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView.naviColor(navi: navigationController)
    }
    
    @IBAction func addNewEvent(_ sender: Any) {
        
    }
    
    
    
}
