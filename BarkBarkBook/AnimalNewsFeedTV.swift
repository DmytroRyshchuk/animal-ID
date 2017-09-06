//
//  TableViewAnimalNewsFeed.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 07.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

extension UserDetailInformationOfAnimalViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            return self.cellForMainInfo(tableView: tableView)
        } else {
            let index = indexPath.row - 1
            return cellForPostAtIndex(index, tableView: tableView)
        }
    }
    
    func cellForMainInfo(tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "animalInfo") as? AnimalInfoTableViewCell {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.animalNicknameLabel.text = UserDefaults.standard.value(forKey: "nicknameOfAnimal") as? String
            
            let url = URL(string: UserDefaults.standard.value(forKey: "photoOfAnimal") as! String)
            
            if url != nil {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        cell.animalAvatarImage.image = UIImage(data: data!)
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func cellForPostAtIndex(_ index: Int, tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.nameSurnameLabel.text = postsArray[index].surname + " " + postsArray[index].name
            
            if postsArray[index].statusOfPost == 1 {
                cell.statusOfPostOpenOrLock.image = UIImage(named: "postLockIcon")
            } else {
                cell.statusOfPostOpenOrLock.image = UIImage(named: "postOpenIcon")
            }
            
            //cell.nameSurnameLabel.text = postsArray[index].surname + " " + postsArray[index].name + " with " + postsArray[index].animalName
            cell.contentLabel.text = postsArray[index].content
            cell.likesLabel.text = String(postsArray[index].countLikes)
            cell.commentsLabel.text = String(postsArray[index].countCommentsPosts) + " comments"
            cell.dateOfPostLabel.text = convertUnixToDate(timeStamp: postsArray[index].createdAt)
            
            cell.statusOfPost = postsArray[index].statusOfPost
            cell.postId = postsArray[index].id
            
            cell.collectionView.tag = index
            //            print("cc: ", cell.collectionView.tag)
            let post = postsArray[index]
            if post.imageLinks.count == 0 {
                //                print("Look, here is 0")
                cell.collectionView.isHidden = true
            } else {
                cell.collectionView.isHidden = false
                //                print("More photos: ", post.imagesLink.count)
            }
            cell.collectionView.reloadData()
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
