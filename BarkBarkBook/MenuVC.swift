//
//  MenuVC.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 23.06.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import SDWebImage

class MenuVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var bo_addViewPop: UIView!
    
    var userAnimalsArray = [UserAnimalsDetails]()
    var postsArray = [UserContent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: "newAnimalOpenPage", name: NSNotification.Name(rawValue: "newAnimalOpenPage"), object: nil)
//        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        postsArray = []
        addNavBarImage()
        openListOfAnimals(view: self)
    }
    
    func addNavBarImage() {
        
        let navController = navigationController!
        
        let image = #imageLiteral(resourceName: "newLogo")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    func ifTableViewIsEmpty() {
        self.view.addSubview(bo_addViewPop)
        bo_addViewPop.center = self.view.center
        
        bo_addViewPop.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        bo_addViewPop.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.bo_addViewPop.alpha = 1
            self.bo_addViewPop.transform = CGAffineTransform.identity
        }
    }
}
