//
//  Api_AddNewAnimal.swift
//  AnimalBook
//
//  Created by Dmytro Ryshchuk on 30.05.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

extension RegisterNewAnimalViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    //MARK: - Image
    //Choose - make photo on camera or take from library
    func enterPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    //To pick right photo from library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        iv_imageOfAnimal.contentMode = .scaleAspectFit
        iv_imageOfAnimal.image = chosenImage         
        //        UIImageWriteToSavedPhotosAlbum(chosenImage, self, #selector(UserProfileViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        let imageOrintationIsOkay = self.sFunc_imageFixOrientation(img: self.iv_imageOfAnimal.image!)
        
        if let imageData = imageOrintationIsOkay.jpeg(.high) {
            img = imageData
//            api_ChangeAvatar(img: img)
        }
        
        dismiss(animated:true, completion: nil) //5
    }
    
    //if we want to save image
    /*func image(_ image:UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
     if error == nil {
     let ac = UIAlertController(title: "Image saved", message: "The photo has been saved.", preferredStyle: .alert)
     ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
     present(ac, animated: true, completion: nil)
     } else {
     let ac = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
     ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
     present(ac, animated: true, completion: nil)
     }
     }*/
    
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
