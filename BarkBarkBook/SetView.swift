//
//  SetView.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 23.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class SetView {
    let formatter = DateFormatter()
    
    func setRadius(elements: [AnyObject]) {
        for i in elements {
            i.layer.cornerRadius = 5
        }
    }
    func makeAvatarRound(avatar: UIImageView) {
        avatar.layer.cornerRadius = avatar.frame.height / 2
    }
    func naviColor(navi: UINavigationController?) {
        navi?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0.367, green: 0.342, blue: 0.341, alpha: 1)
    }
    func setTitleForButton(button: UIButton, title: String, forState: UIControlState) {
        button.setTitle(title, for: forState)
    }
    func showDataOfFirstAnimal(avatar: UIImageView, element: NSObject) {
    
        avatar.image = SharingManager.sharedInstance.photoOfAnimal
        avatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = avatar.frame.height/2 - 2
        avatar.clipsToBounds = true
//        animalAvatar.sd_setImage(with: url! as URL)
        
        let title = SharingManager.sharedInstance.nicknameOfAnimal
        if element is UIButton {
            let button = element as! UIButton
            title != "" ? setTitleForButton(button: button, title: title, forState: .normal) : setTitleForButton(button: button, title: "Choose animal", forState: .normal)
        } else if element is UILabel {
            let label = element as! UILabel
            if title != "" {
                label.text! = SharingManager.sharedInstance.nicknameOfAnimal
            } else {
                label.text! = "Choose animal"
            }
        }
    }
    func showDataOfAnimal(avatar: UIImageView, element: NSObject) {
        avatar.image = SharingManager.sharedInstance.photoOfAnimal
        if element is UIButton {
            let button = element as! UIButton
            setTitleForButton(button: button, title: SharingManager.sharedInstance.nicknameOfAnimal, forState: .normal)
        } else if element is UILabel {
            let label = element as! UILabel
            label.text = SharingManager.sharedInstance.nicknameOfAnimal
        }
    }
    func callViewPop(view: UIViewController, addViewPop: UIView, datepicker: UIDatePicker, mode: String) {
        view.view.addSubview(addViewPop)
        addViewPop.center = view.view.center
        
        addViewPop.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addViewPop.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            addViewPop.alpha = 1
            addViewPop.transform = CGAffineTransform.identity
        }
        
        if mode == "Date" {
            datepicker.maximumDate = Date()
            datepicker.datePickerMode = .date
            formatter.locale = NSLocale.current
            formatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        } else {
            datepicker.datePickerMode = .time
            formatter.timeStyle = .short
        }
    }
    func closeViewPop(view: UIViewController, addViewPop: UIView, datepicker: UIDatePicker, setDataButton: UIButton, setTimeButton: UIButton?) {
        UIView.animate(withDuration: 0.3, animations: {
            addViewPop.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            addViewPop.alpha = 0
            
        }) { (success:Bool) in
            addViewPop.removeFromSuperview()
        }
        
        if datepicker.datePickerMode == .date {
            SharingManager.sharedInstance.date = formatter.string(from: datepicker.date)
            setDataButton.setTitle("  " + SharingManager.sharedInstance.date + "  ", for: .normal)
        } else if datepicker.datePickerMode == .time {
            SharingManager.sharedInstance.time = formatter.string(from: datepicker.date)
            setTimeButton?.setTitle("  " + SharingManager.sharedInstance.time + "  ", for: .normal)
        }
    }
}






