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
import Fusuma

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
    @IBOutlet weak var segmentedControllerOutlet: UISegmentedControl!
    @IBOutlet weak var addSomePhotoButtonOutlet: UIButton!
    
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
    var cleanDataInPost = false
    var deleteRow = 0
    
    
    //MARK: - Default func
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0.367, green: 0.342, blue: 0.341, alpha: 1)

        self.hideKeyboardWhenTappedAround()        
        
        api_GetFirstUserAnimalToPost()
        
        textInPostTextView.layer.cornerRadius = 5
        chooseAnimalButtonOutlet.layer.cornerRadius = 5
        addSomePhotoButtonOutlet.layer.cornerRadius = 5
        addSomePhotoButtonOutlet.setTitle("  Add some photo  ", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataAboutChoosenAnimalInPost()
        
        if cleanDataInPost {
            photosFromUserInPostArray = []
            photosOfAnimalInCollectionView.reloadData()
            textInPostTextView.text = ""
            segmentedControllerOutlet.selectedSegmentIndex = 0
            
            cleanDataInPost = true
        }
        
//        leadingConstraint.constant = 0
//        traillingConstraint.constant = 0
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
        cleanDataInPost = false
    }
    
    @IBAction private func addPhotoToPost(_ sender: Any) {
        fusumaPod()
    }
    
    @IBAction func cancelBarButtonOnPostPage(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        cleanDataInPost = true
    }
    
    @IBAction func makeNewPostBarButton(_ sender: Any) {
        if textInPostTextView.text != "" {
            self.api_CreateNewPost()
        } else {
            alert(code: 1000, content: "")
        }
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
    
    @IBAction func deleteImageInCollectionViewButton(_ sender: Any) {
        if let cell = (sender as AnyObject).superview??.superview as? MultiplyPhotosOfAnimalCollectionViewCell {
            let indexPath = photosOfAnimalInCollectionView.indexPath(for: cell)
            deleteRow = indexPath!.row
        }
        
        photosFromUserInPostArray.remove(at: deleteRow)
        photosOfAnimalInCollectionView.reloadData()
    }
    
    
    //MARK: - Funcs
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
    
    func alert(code: Int, content: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            var alertController = UIAlertController()
            if code == 1000 {
                alertController = UIAlertController(title: "Error!", message: "Please fill text field.", preferredStyle: .alert)
            } else {
                alertController = UIAlertController(title: "Error: \(code)", message: "\(content)", preferredStyle: .alert)
            }
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                print("You've pressed OK button")
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
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


//MARK: - Fusuma image pod
extension MakeNewPostViewController: FusumaDelegate {
    
    func fusumaPod() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false // If you want to let the users allow to use video.
        fusuma.cropHeightRatio = 0.75 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = false // You can select multiple photos from the camera roll. The default value is false.
        fusuma.defaultMode = .library // The first choice to show (.camera, .library, .video). The default value is .camera.
        self.present(fusuma, animated: true, completion: nil)
        
        fusuma.hideButtons()
        cleanDataInPost = false
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
//        for oneImage in images {
//            let imageOrintationIsOkay = self.sFunc_imageFixOrientation(img: oneImage)
//            
//            if let imageData = imageOrintationIsOkay.jpeg(.low) {
//                imageT = scaledImage(UIImage(data: imageData)!, maximumWidth: 400)
//                photosFromUserInPostArray.append(UIImage(data: imageData)!)
//            }
//        }
//        
//        buttonIsPressed = true
//        photosOfAnimalInCollectionView.contentMode = .scaleAspectFit //3
//        photosOfAnimalInCollectionView?.reloadData()
    }
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        let imageOrintationIsOkay = self.sFunc_imageFixOrientation(img: image)
        
        if let imageData = imageOrintationIsOkay.jpeg(.low) {
            photosFromUserInPostArray.append(UIImage(data: imageData)!)
        }
        
        buttonIsPressed = true
        photosOfAnimalInCollectionView.contentMode = .scaleAspectFit //3
        photosOfAnimalInCollectionView?.reloadData()

        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage, source: FusumaMode) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    // Return an image and the detailed information.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellWidth = collectionView.bounds.size.width
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    //TODO: open image on whole view on new ViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print(indexPath.item)
        //        collectionView.deleteItems(at: [indexPath])
        //        photosFromUserInPostArray.remove(at: indexPath.item)
        //        collectionView.reloadData()
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

extension FusumaViewController {
    
    func hideButtons() {
        let btnLibrary = self.value(forKey: "libraryButton") as? UIButton
        let btnCamera = self.value(forKey: "cameraButton") as? UIButton
        
        btnLibrary?.isHidden = true
        btnCamera?.isHidden = true
    }
}

