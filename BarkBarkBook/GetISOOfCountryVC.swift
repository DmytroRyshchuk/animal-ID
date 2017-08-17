//
//  GetISOOfCountryViewController.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 17.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class GetISOOfCountryViewController: UIViewController {

    @IBOutlet weak var searchCountryTextField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var getCountryISO = [GetCountryISO]()
    var filtered = [GetCountryISO]()
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Action
    @IBAction func ba_accept(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = getCountryISO.filter({ (text) -> Bool in
            let tmp: NSString = text.countryName as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if filtered.count == 0 {
            searchActive = false
        } else {
            searchActive = true
        }
        tableView.reloadData()
    }
}

extension GetISOOfCountryViewController: UITableViewDataSource, UITextViewDelegate {
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        
        return getCountryISO.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GetISOOfCountryTableViewCell
        
        let countryName = getCountryISO[indexPath.row].countryName  // speciesDict.description
        let countryISOCode = getCountryISO[indexPath.row].countryISOCode
        
        if searchActive {
                    }
        
        if searchActive {
            let countryName2 = filtered[indexPath.row].countryName  // speciesDict.description
            let countryISOCode2 = filtered[indexPath.row].countryISOCode

            cell.countryNameLabel.text = String(describing: countryName2)
            cell.isoOfCountryIsHidden.text = String(countryISOCode2)
        } else {
            cell.countryNameLabel.text = String(describing: countryName)
            cell.isoOfCountryIsHidden.text = String(countryISOCode)
        }
        
        return cell
    }
}
