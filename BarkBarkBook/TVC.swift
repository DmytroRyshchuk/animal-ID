//
//  TableViewCell.swift
//  Dynamic TableVeiw
//
//  Created by Dmytro Ryshchuk on 01.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    //MARK: - let/outlet
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var dateOfPostLabel: UILabel!
    @IBOutlet weak var likeButtonImageAnimation: UIImageView!
    
    var heartImagesArray: [UIImage] = []
    
    var postId = 0
    var statusOfPost = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout*/
        
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//        }
        
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
        let udi = UserDetailInformationOfAnimalViewController()
        udi.callAlertSheet(postId: postId, statusOfPost: statusOfPost)
    }
    
    // Change status of post
    func changePost(id: Int, status: Int) {
        postId = id
        statusOfPost = status
        actionWithPost(address: "\(api_animalID)/post/status", method: .put, type: "Status")
    }
    
    // Delete post
    func deletePost(id: Int) {
        postId = id
        actionWithPost(address: "\(api_animalID)/post/delete", method: .delete, type: "Delete")
    }
}
