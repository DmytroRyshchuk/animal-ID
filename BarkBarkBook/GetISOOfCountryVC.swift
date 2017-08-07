//
//  GetISOOfCountryViewController.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 17.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class GetISOOfCountryViewController: UIViewController {

    var getCountryISO = [GetCountryISO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Action
    @IBAction func ba_accept(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension GetISOOfCountryViewController: UITableViewDataSource, UITextViewDelegate {
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(getCountryISO.count)
        return getCountryISO.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GetISOOfCountryTableViewCell
        
        let countryName = getCountryISO[indexPath.row].countryName  // speciesDict.description
        let countryISOCode = getCountryISO[indexPath.row].countryISOCode
        
        cell.countryNameLabel.text = String(describing: countryName)
        cell.isoOfCountryIsHidden.text = String(countryISOCode)
        
        return cell
    }
}
