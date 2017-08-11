//
//  CollectionViewAnimalNewsFeed.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 07.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}

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
        
        let cellWidth = collectionView.bounds.size.width
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.size.width/1.5 - 20, height: collectionView.bounds.size.width)
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets
//    {
//        return  UIEdgeInsetsMake( 5,  14, 5,  14)
//    }
}
