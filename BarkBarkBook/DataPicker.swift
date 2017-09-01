//
//  DataPicker.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 07.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

extension RegisterNewAnimalViewController {
    //MARK: - Data Picker
    
    @IBAction func ba_callViewPop(_ sender: Any) {
        setView.callViewPop(view: self, addViewPop: bo_addViewPop, datepicker: dp_datePicker, mode: "Date", max: true)
    }
    
    @IBAction func ba_backToViewController(_ sender: Any) {
        setView.closeViewPop(view: self, addViewPop: bo_addViewPop, datepicker: dp_datePicker, setDataButton: bo_datePicker, setTimeButton: nil)
    }
}
