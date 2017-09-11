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
    func setBarButtonTintColor(buttons: [UIBarButtonItem]) {
        for i in buttons {
            i.tintColor = UIColor(colorLiteralRed: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        }
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
    func callViewPop(view: UIViewController, addViewPop: UIView, datepicker: UIDatePicker, mode: String, max: Bool) {
        view.view.addSubview(addViewPop)
        addViewPop.center = view.view.center
        
        addViewPop.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addViewPop.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            addViewPop.alpha = 1
            addViewPop.transform = CGAffineTransform.identity
        }
        
        if mode == "Date" {
            if max {
                datepicker.maximumDate = Date()
            }
            datepicker.datePickerMode = .date
            formatter.locale = NSLocale.current
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "dd MMMM yyyy" //Specify your format that you want

            if SharingManager.sharedInstance.date != "" {
                let convertedStartDate = formatter.date(from: SharingManager.sharedInstance.date)
                print(SharingManager.sharedInstance.date)
                datepicker.date = convertedStartDate!
            }
        } else {
            datepicker.datePickerMode = .time
            formatter.timeStyle = .short
            formatter.locale = Locale(identifier: "uk_UK")
            if SharingManager.sharedInstance.time != "" {
                let convertedStartDate = formatter.date(from: SharingManager.sharedInstance.time)
                print(SharingManager.sharedInstance.time)
                //TODO: Fix time if it american version
                datepicker.date = convertedStartDate!
            }
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
    func repeatingModeInAlertList(alert: UIAlertController, button: UIButton, times: [String]) {
        for title in 0..<times.count {
            alert.addAction(UIAlertAction(title: times[title], style: .default, handler: { (action) in
                //execute some code when this option is selected
                button.setTitle(times[title], for: .normal)
            }))
        }
    }
}






