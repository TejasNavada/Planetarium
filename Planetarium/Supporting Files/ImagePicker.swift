//
//  ImagePicker.swift
//  PIM
//
//  Created by Osman Balci on 8/14/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import Foundation
import SwiftUI

/*
 ***********************************************
 MARK: Image Picker from Camera or Photo Library
 ***********************************************
 */
struct ImagePicker: UIViewControllerRepresentable {
    
    /*
     @Binding creates a two-way connection between the caller and the called in such a way that the
     called can change the caller's passed parameter value. Wrapping an input parameter with
     @Binding implies that the input parameter's reference is passed so that its value can be changed.
     
     For storage and performance efficiency reasons, we scale down the photo image selected from
     the photo library or taken by the camera to a smaller size with imageWidth and imageHeight.
     */
    
    /*
     ------------------------
     |   Input Parameters   |
     ------------------------
     */
    @Binding var uiImage: UIImage?                          // Image to be picked as of UIImage type
    let sourceType: UIImagePickerController.SourceType      // Pick image from .camera or .photoLibrary
    let imageWidth: CGFloat                                 // Picked image to be scaled to imageWidth
    let imageHeight: CGFloat                                // Picked image to be scaled to imageHeight
    
    /*
     ------------------------
     |   Make Coordinator   |
     ------------------------
     */
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(uiImage: $uiImage, imageWidth: imageWidth, imageHeight: imageHeight)
    }
    
    /*
     -----------------------------
     |   Make UIViewController   |
     -----------------------------
     */
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        /*
         UIImagePickerController is a class that manages the system interfaces for taking
         photos, recording videos, and choosing items from the user's media (photo) library.
         
         Create a UIImagePickerController object, initialize it,
         and store its object reference into imagePickerController
         */
        let imagePickerController = UIImagePickerController()
        
        // Dress up the newly created UIImagePickerController object
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = ["public.image"]
        
        if sourceType == .camera {
            imagePickerController.cameraCaptureMode = .photo
        }
        
        /*
         Designate this view controller as the delegate so that we can implement
         the protocol methods in the ImagePickerCoordinator class below
         */
        imagePickerController.delegate = context.coordinator
        
        return imagePickerController
    }
    
    /*
     -------------------------------
     |   Update UIViewController   |
     -------------------------------
     */
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // Nothing to update
    }
}

/*
 ******************************
 MARK: Image Picker Coordinator
 ******************************
 */
class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //-----------------
    // Class Properties
    //-----------------
    @Binding var uiImage: UIImage?
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    
    //-------------------------------
    // Class Property Initializations
    //-------------------------------
    init(uiImage: Binding<UIImage?>, imageWidth: CGFloat, imageHeight: CGFloat) {
        _uiImage = uiImage
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }
    
    /*
     ----------------------------------------------
     |   UIImagePickerControllerDelegate Method   |
     ----------------------------------------------
     Tells the delegate that the user picked a still image
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            uiImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            uiImage = originalImage
        }
        
        /*
         Scale the picked uiImage to the desired size for storage and performance efficiency reasons.
         The scaleUIImage() method is given below as an extension of the UIImage class.
         */
        let scaledImage = uiImage!.scaleUIImage(targetSize: CGSize(width: imageWidth, height: imageHeight))
        
        uiImage = scaledImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    /*
     ----------------------------------------------
     |   UIImagePickerControllerDelegate Method   |
     ----------------------------------------------
     Tells the delegate that the user cancelled the pick operation
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

/*
 *********************************
 MARK: Scale Image to Desired Size
 *********************************
 */
extension UIImage {
    
    func scaleUIImage(targetSize: CGSize) -> UIImage {
        /*
         Compute the scale factor to proportionately resize the image without distorting it.
         The 'size' is the CGSize of the UIImage being scaled.
         */
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Set the size of the image to be proportionately resized
        let scaledImageSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        // UIGraphicsImageRenderer is a class that renders graphics for creating Core Graphics (CG) images.
        let graphicsImageRenderer = UIGraphicsImageRenderer(size: scaledImageSize)

        let scaledImage = graphicsImageRenderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        
        return scaledImage
    }
}
