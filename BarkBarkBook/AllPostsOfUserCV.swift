//
//  AllPostsOfUserCollectionView.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 17.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import SDWebImage

extension AllPostsOfUserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: - Collections
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let post = allPostsOfUserArray[collectionView.tag]
//        print("\n\ncount: ", post.imageLinks.count)
        return post.imageLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AllPostsOfUserCollectionViewCell
        
        let post = allPostsOfUserArray[collectionView.tag]
//        print("allPostsOfUserArray[collectionView.tag] = ", allPostsOfUserArray[collectionView.tag].imageLinks.count)
        if post.imageLinks.count != 0 {
            let imageLink = post.imageLinks[indexPath.row]
            
            if imageLink.imageLink != nil {
                let url = URL(string: imageLink.imageLink!)
                
                cell.imageOfAnimalInCollectionView.sd_setImage(with: url!, placeholderImage: UIImage(named: "App-Default"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                })
            }
        }
        
        return cell
    }
}
