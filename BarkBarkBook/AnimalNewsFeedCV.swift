//
//  CollectionViewAnimalNewsFeed.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 07.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import SDWebImage

extension UserDetailInformationOfAnimalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: - Collections
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let post = postsArray[collectionView.tag]
        //        print("count: ", post.imagesLink.count)
        return post.imageLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        let post = postsArray[collectionView.tag]
        //        print("postArrayPhotos: ", post.imagesLink.count)
        if post.imageLinks.count != 0 {
            //            print("POST = ", post)
            //            print("Look here: ", post.imagesLink[indexPath.row].imageLink)
            //            print("IMAGELINK = ", post.imagesLink[indexPath.row].imageLink)
            let imageLink = post.imageLinks[indexPath.row]
            
            if imageLink.imageLink != nil {
                let url = URL(string: imageLink.imageLink!)
                print("IMAGELINK = ", imageLink)
                
                cell.imageOfAnimalInCollectionView.sd_setImage(with: url!, placeholderImage: UIImage(named: "App-Default"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                })
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.view.frame.size.height;
        let width  = self.view.frame.size.width;
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width, height: height * 0.35)
        
//        return CGSize(width: view.frame.width / 2, height: 350)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}
