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
        self.view.addSubview(bo_addViewPop)
        bo_addViewPop.center = self.view.center
        
        bo_addViewPop.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        bo_addViewPop.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.bo_addViewPop.alpha = 1
            self.bo_addViewPop.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func ba_backToViewController(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bo_addViewPop.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.bo_addViewPop.alpha = 0
            
        }) { (success:Bool) in
            self.bo_addViewPop.removeFromSuperview()
        }
        if dateIsPicked == false {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            
            SharingManager.sharedInstance.date = strDate
            bo_datePicker.setTitle(SharingManager.sharedInstance.date, for: .normal)
        }
    }
    
    @IBAction func ba_dataPicker(_ sender: UIDatePicker) {
        dateIsPicked = true
        
        dp_datePicker.maximumDate = Date()                          //обмежуємо максимальний день сьогоднішнім
        
        let dateFromDatePicker = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: dateFromDatePicker)
        
        SharingManager.sharedInstance.date = strDate
        bo_datePicker.setTitle(SharingManager.sharedInstance.date, for: .normal)
    }
}
