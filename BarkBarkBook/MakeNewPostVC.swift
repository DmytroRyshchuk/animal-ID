//
//  MakeNewPostViewController.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 10.07.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import UIKit
import ImagePicker
import SDWebImage

class MakeNewPostViewController: UIViewController {
    
    //MARK: - IBOutlets & var/let
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var chooseAnimalButtonOutlet: UIButton!
    @IBOutlet weak var accessToPostLabel: UILabel!
    @IBOutlet weak var avatarOfAnimalImage: UIImageView!
    @IBOutlet weak var textInPostTextView: UITextView!
    @IBOutlet weak var photosOfAnimalInCollectionView: UICollectionView!
    @IBOutlet weak var traillingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    var menuIsShowing = false
    var menuIsOpen = false
    let openMenu = OpenMenu()
    
    var imageT = UIImage()
    var nicknameOfAnimalFromJson = ""
    var idOfAnimalFromJson = 0
    var photoOfAnimalFromJson = ""
    var animalNamesOfUserArray = [ChooseAnimalForMakeNewPost]()
    var statusOfPost = 3
    var photosFromUserInPostArray = [UIImage]()
    var buttonIsPressed = false
    var moveToPostVC = true
    
    
    //MARK: - Default func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()        
        
        api_GetFirstUserAnimalToPost()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataAboutChoosenAnimalInPost()
        
        leadingConstraint.constant = 0
        traillingConstraint.constant = 0
        menuIsShowing = false
        
        if menuIsOpen {
            _ = navigationController?.popViewController(animated: true)
            menuIsOpen = false
        }
        
        self.tabBarController?.tabBar.isHidden = true
        //cleanDataInPost()
        
        if nicknameOfAnimalFromJson != "" {
            activityIndicator.stopAnimating()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: - Actions
    @IBAction private func chooseAccessToPostSegmentedController(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            accessToPostLabel.text = "Public post"
            statusOfPost = 3
        } else {
            accessToPostLabel.text = "Private post"
            statusOfPost = 1
        }
    }
    
    @IBAction private func chooseAccessToPostButtonAction(_ sender: Any) {
        api_UserAnimals()
    }
    
    @IBAction private func addPhotoToPost(_ sender: Any) {
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelBarButtonOnPostPage(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func makeNewPostBarButton(_ sender: Any) {        
        self.api_CreateNewPost()
    }
    
    @IBAction func showMenu(_ sender: Any) {
        if menuIsShowing {
            leadingConstraint.constant = 0
            traillingConstraint.constant = 0
        } else {
            leadingConstraint.constant = 200
            traillingConstraint.constant = -200
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        menuIsShowing = !menuIsShowing
        
    }
    
    
    //MARK: - Funcs
    func cleanDataInPost() {
        photosFromUserInPostArray = []
        textInPostTextView.text = ""
    }
    
    func dataAboutChoosenAnimalInPost() {
        animalNamesOfUserArray = []
        let title = SharingManager.sharedInstance.nicknameOfAnimal
        if title != "" {
            chooseAnimalButtonOutlet.setTitle(title, for: .normal)
        } else {
            chooseAnimalButtonOutlet.setTitle("Choose animal", for: .normal)
        }
        
        avatarOfAnimalImage.image = SharingManager.sharedInstance.photoOfAnimal
    }
}


// MARK: - UITextViewDelegate - hide text view
extension MakeNewPostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


//MARK: - PickerView pod
extension MakeNewPostViewController: ImagePickerDelegate {
    internal func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        for oneImage in images {
            let imageOrintationIsOkay = self.sFunc_imageFixOrientation(img: oneImage)
            
            if let imageData = imageOrintationIsOkay.jpeg(.low) {
                imageT = scaledImage(UIImage(data: imageData)!, maximumWidth: 400)
                photosFromUserInPostArray.append(UIImage(data: imageData)!)
            }

        }
        
        //photosFromUserInPostArray = images
        imagePicker.dismiss(animated: true, completion: nil)
        buttonIsPressed = true
        photosOfAnimalInCollectionView?.reloadData()
    }
    
    internal func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    internal func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}




//MARK: - CollectionView
extension MakeNewPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosFromUserInPostArray.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MultiplyPhotosOfAnimalCollectionViewCell
        if photosFromUserInPostArray.count != 0 || buttonIsPressed {
            cell.addedImagesToPost.image = photosFromUserInPostArray[indexPath.row]
        }
        
        return cell
    }
}


//MARK: - Photo
extension MakeNewPostViewController {
    func scaledImage(_ image: UIImage, maximumWidth: CGFloat) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage, scale: image.size.width / maximumWidth, orientation: image.imageOrientation)
    }
    
    //Fix orientation of picture
    func sFunc_imageFixOrientation(img:UIImage) -> UIImage {
        
        // No-op if the orientation is already correct
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransform.identity
        
        if (img.imageOrientation == UIImageOrientation.down
            || img.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: img.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if (img.imageOrientation == UIImageOrientation.left
            || img.imageOrientation == UIImageOrientation.leftMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        }
        
        if (img.imageOrientation == UIImageOrientation.right
            || img.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: 0, y: img.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2));
        }
        
        if (img.imageOrientation == UIImageOrientation.upMirrored
            || img.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if (img.imageOrientation == UIImageOrientation.leftMirrored
            || img.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: img.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx:CGContext = CGContext(data: nil, width: Int(img.size.width), height: Int(img.size.height),
                                      bitsPerComponent: img.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: img.cgImage!.colorSpace!,
                                      bitmapInfo: img.cgImage!.bitmapInfo.rawValue)!
        
        ctx.concatenate(transform)
        
        if (img.imageOrientation == UIImageOrientation.left
            || img.imageOrientation == UIImageOrientation.leftMirrored
            || img.imageOrientation == UIImageOrientation.right
            || img.imageOrientation == UIImageOrientation.rightMirrored
            ) {
            
            ctx.draw(img.cgImage!, in: CGRect(x:0,y:0,width:img.size.height,height:img.size.width))
            
        } else {
            ctx.draw(img.cgImage!, in: CGRect(x:0,y:0,width:img.size.width,height:img.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)
        
        return imgEnd
    }
}
