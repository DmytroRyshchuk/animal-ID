//
//  AllPostsOfUserTabBarController.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 18.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class AllPostsOfUserTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for vc in self.viewControllers! {
            vc.tabBarItem.title = nil
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        }
        
        imagesInTabBar()
    }
    
    func imagesInTabBar() {
        let arrayOfImageNameForSelectedState = ["Asset 1", "Asset 2", "Asset 3", "Asset 4"]
        let arrayOfImageNameForUnselectedState = ["Asset 1", "Asset 2", "Asset 3", "Asset 4"]
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
}
