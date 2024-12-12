//
//  VideoPicker.swift
//  Planetarium
//
//  Created by Osman Balci on 8/14/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import Foundation
import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers
import AVFoundation

// Global Variables
var videoUIImage = UIImage()
var videoData: Data? = nil
 
/*
***********************************************
MARK: Video Picker from Camera or Photo Library
***********************************************
*/
struct VideoPicker: UIViewControllerRepresentable {
    /*
    🔴 @Binding creates a two-way connection between the caller and the called in such a way that the
     called can change the caller's passed parameter value. Wrapping an input parameter with
     @Binding implies that the input parameter's reference is passed so that its value can be changed.
    */
   
    @Binding var videoUrl: URL?
    let sourceType: UIImagePickerController.SourceType
   
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPicker>) -> UIImagePickerController {
        
        // Create a UIImagePickerController object, initialize it,
        // and store its object reference into imagePickerController
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = ["public.movie"]
        
        if sourceType == .camera {
            imagePickerController.cameraCaptureMode = .video
        }

        // Designate this view controller as the delegate so that we can implement
        // the protocol methods in the ImagePickerCoordinator class below
        imagePickerController.delegate = context.coordinator
       
        return imagePickerController
    }
   
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<VideoPicker>) {
        // Nothing to update
    }
    
    func makeCoordinator() -> VideoPickerCoordinator {
        return VideoPickerCoordinator(videoUrl: $videoUrl)
    }
   
}

/*
******************************
MARK: Video Picker Coordinator
******************************
*/
class VideoPickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @Binding var videoUrl: URL?
   
    init(videoUrl: Binding<URL?>) {
        _videoUrl = videoUrl
    }
   
    /*
     UIImagePickerController is a view controller that manages the system interfaces for
     taking pictures, recording movies, and choosing items from the user's media library.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            videoUrl = url
        } else { return }
        
        let urlAsset = AVURLAsset(url: videoUrl!)
        
        do {
            videoData = try Data(contentsOf: videoUrl!)
        } catch let error {
            print("Error: \(error)")
            videoUrl = nil
            return
        }
        
        let assetImageGenerator = AVAssetImageGenerator(asset: urlAsset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.apertureMode = .encodedPixels

        let cmTime = CMTime(seconds: 1, preferredTimescale: 60)
        var thumbnailCGImage: CGImage?
        var errorOccurred = false
        
        let semaphore = DispatchSemaphore(value: 0)

        assetImageGenerator.generateCGImageAsynchronously(for: cmTime) { generatedImage, timeGenerated, error in
            if error == nil {
                if let cgVideoImage = generatedImage {
                    thumbnailCGImage = cgVideoImage
                } else {
                    errorOccurred = true
                }
            } else {
                errorOccurred = true
            }
            semaphore.signal()
            return
        }
        
        _ = semaphore.wait(timeout: .now() + 30)
        
        /*
         ---------------------------------------------------------------------------
         Purple message "Thread running at User-interactive quality-of-service class
         waiting on a lower QoS thread running at Default quality-of-service class."
         can either be ignored or disabled by following the steps below in Xcode:
         (1) Select Product > Scheme > Edit Scheme to display the scheme editor.
         (2) Select the Run schemes, navigate to the Diagnostics section, and
             unselect the Thread Performance Checker tool checkbox.
         ---------------------------------------------------------------------------
         */
        
        if errorOccurred {
            videoUrl = nil
            return
        }
        
        if let thumbnailImage = thumbnailCGImage {
            videoUIImage = UIImage(cgImage: thumbnailImage)
        } else {
            videoUrl = nil
            return
        }

        picker.dismiss(animated: true, completion: nil)
    }
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
   
}

