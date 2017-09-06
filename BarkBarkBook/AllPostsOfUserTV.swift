//
//  AllPostsOfUserTableView.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 17.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

extension AllPostsOfUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPostsOfUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AllPostsOfUserTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.nameSurnameLabel.text = allPostsOfUserArray[index].name + " " + allPostsOfUserArray[index].surname + " with " + allPostsOfUserArray[index].animalName
//        if allPostsOfUserArray[index].content != "" {
            cell.contentLabel.text = allPostsOfUserArray[index].content
//        }
        cell.likesLabel.text = String(allPostsOfUserArray[index].countLikes)
        cell.commentsLabel.text = String(allPostsOfUserArray[index].countCommentsPosts) + " comments"
        cell.dateOfPostLabel.text = convertUnixToDate(timeStamp: allPostsOfUserArray[index].createdAt)
        
        cell.statusOfPost = allPostsOfUserArray[index].statusOfPost
        cell.postId = allPostsOfUserArray[index].id
        
        cell.cellButtonOutlet.tag = index
        
        cell.collectionView.tag = index
//        print("index is = ", index)
        let post = allPostsOfUserArray[index]
        if post.imageLinks.count == 0 {
            cell.collectionView.isHidden = true
        } else {
            cell.collectionView.isHidden = false
        }
        
        cell.collectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("section: \(indexPath.section)")
//        print("row: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = allPostsOfUserArray.count - 1
        if indexPath.row == lastItem {
            if countOfAllPost == 0 || Int((countOfAllPost / 3) + 1) >= pageIndex {
                apiAllPostsOfUser()
            }
        }
    }
}
