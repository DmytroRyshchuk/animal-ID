//
//  AllPostsOfUserTableViewCell.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 17.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class AllPostsOfUserTableViewCell: UITableViewCell {

    //MARK: - let/outlet
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var statusOfPostOpenOrLock: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var dateOfPostLabel: UILabel!
    @IBOutlet weak var likeButtonImageAnimation: UIImageView!
    @IBOutlet weak var cellButtonOutlet: UIButton!
    
    var heartImagesArray: [UIImage] = []
    
    var postId = 0
    var statusOfPost = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heartImagesArray = createImageArray(total: 24, imagePrefix: "heart")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // Like post
    @IBAction func likeButtonAction(_ sender: Any) {
        actionWithPost(address: "\(api_animalID)/post/like", method: .post, type: "Like")
        animate(imageView: likeButtonImageAnimation, images: heartImagesArray)
    }
    
    // What to do button
    @IBAction func whatToDoWithPostButtonAction(_ sender: Any) {
//        let udi = UserDetailInformationOfAnimalViewController()
//        udi.callAlertSheet(postId: postId, statusOfPost: statusOfPost)
        let apou = AllPostsOfUserViewController()
        apou.callAlertSheet(postId: postId, statusOfPost: statusOfPost)
    }
    
    //Animate like button
    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        var imageArray: [UIImage] = []
        
        for imageCount in 0..<total {
            let imageName = "\(imagePrefix)-\(imageCount).png"
            let image = UIImage(named: imageName)!
            
            imageArray.append(image)
        }
        return imageArray
    }
    
    
    func animate(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 1.0
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
    }
    
    // Change status of post
    func changePost(id: Int, status: Int) {
        postId = id
        statusOfPost = status
        actionWithPost(address: "\(api_animalID)/post/status", method: .put, type: "Status")
    }
    
    // Delete post
    func deletePost(id: Int) {
//        print(cellButtonOutlet.tag)              //TODO: catch cell id              remove - allPostsOfUserArray.removeAtIndex(cellButtonOutlet.tag)
        
        postId = id
        actionWithPost(address: "\(api_animalID)/post/delete", method: .delete, type: "Delete")            
    }
}
