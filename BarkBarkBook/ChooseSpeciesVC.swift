//
//  ChooseSpeciesViewController.swift
//  AnimalBook
//
//  Created by Dmytro Ryshchuk on 31.05.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class ChooseSpeciesViewController: UIViewController {

    var speciesTypeDict = [SpeciesClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - Action
    @IBAction func ba_accept(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChooseSpeciesViewController: UITableViewDataSource, UITextViewDelegate {
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speciesTypeDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChooseSpeciesOfAnimalTableViewCell
        
        let value = speciesTypeDict[indexPath.row].value  // speciesDict.description
        let key = speciesTypeDict[indexPath.row].key
        
        cell.l_species.text = String(describing: value)
        cell.l_key_isHidden.text = String(describing: key)
        
        return cell
    }
}
