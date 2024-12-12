//
//  UtilityFunctions.swift
//  Planetarium
//
//  Created by Osman Balci on 10/20/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

// Global constant
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

/*
***********************************************
MARK: Decode JSON file into an Array of Structs
***********************************************
*/
public func decodeJsonFileIntoArrayOfStructs<T: Decodable>(fullFilename: String, fileLocation: String, as type: T.Type = T.self) -> T {
    
    /*
     T.self defines the struct type T into which each JSON object will be decoded.
        exampleStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "exampleFile.json", fileLocation: "Main Bundle")
     or
        exampleStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "exampleFile.json", fileLocation: "Document Directory")
     The left hand side of the equation defines the struct type T into which JSON objects will be decoded.
     
     This function returns an array of structs of type T representing the JSON objects in the input JSON file.
     In Swift, an Array stores values of the same type in an ordered list. Therefore, the structs will keep their order.
     */
    
    var jsonFileData: Data?
    var jsonFileUrl: URL?
    var arrayOfStructs: T?
    
    if fileLocation == "Main Bundle" {
        // Obtain URL of the JSON file in main bundle
        let urlOfJsonFileInMainBundle: URL? = Bundle.main.url(forResource: fullFilename, withExtension: nil)
        
        if let mainBundleUrl = urlOfJsonFileInMainBundle {
            jsonFileUrl = mainBundleUrl
        } else {
            print("JSON file \(fullFilename) does not exist in main bundle!")
        }
    } else {
        // Obtain URL of the JSON file in document directory on user's device
        let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent(fullFilename)
        
        if let docDirectoryUrl = urlOfJsonFileInDocumentDirectory {
            jsonFileUrl = docDirectoryUrl
        } else {
            print("JSON file \(fullFilename) does not exist in document directory!")
        }
    }
    
    do {
        jsonFileData = try Data(contentsOf: jsonFileUrl!)
    } catch {
        print("Unable to obtain JSON file \(fullFilename) content!")
    }
    
    do {
        // Instantiate an object from the JSONDecoder class
        let decoder = JSONDecoder()
        
        // Use the decoder object to decode JSON objects into an array of structs of type T
        arrayOfStructs = try decoder.decode(T.self, from: jsonFileData!)
    } catch {
        print("Unable to decode JSON file \(fullFilename) because your Struct attribute names do not exactly match the JSON file attribute names!")
    }
    
    // Return the array of structs of type T
    return arrayOfStructs!
}

/*
************************
MARK: Get Image from URL
************************
*/
public func getImageFromUrl(url: String, defaultFilename: String) -> Image {
    /*
     If getting image from URL fails, Image file with given defaultFilename
     (e.g., "ImageUnavailable") in Assets.xcassets will be returned.
     */
    var imageObtainedFromUrl = Image(defaultFilename)
 
    let headers = [
        "accept": "image/jpg, image/jpeg, image/png",
        "cache-control": "cache",
        "connection": "keep-alive",
    ]
 
    // Convert given URL string into URL struct
    guard let imageUrl = URL(string: url) else {
        return Image(defaultFilename)
    }
 
    let request = NSMutableURLRequest(url: imageUrl,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 30.0)
 
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
 
    /*
     Create a semaphore to control getting and processing image data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
 
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
        URLSession is established and the image file from the URL is set to be fetched
        in an asynchronous manner. After the file is fetched, data, response, error
        are returned as the input parameter values of this Completion Handler Closure.
        */
 
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
 
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }
 
        // Unwrap Optional 'data' to see if it has a value
        guard let imageDataFromUrl = data else {
            semaphore.signal()
            return
        }
 
        // Convert fetched imageDataFromUrl into UIImage object
        let uiImage = UIImage(data: imageDataFromUrl)
 
        // Unwrap Optional uiImage to see if it has a value
        if let imageObtained = uiImage {
            // UIImage is successfully obtained. Convert it to SwiftUI Image.
            imageObtainedFromUrl = Image(uiImage: imageObtained)
        }
 
        semaphore.signal()
    }).resume()
 
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
 
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 30 seconds expires.
    */
 
    _ = semaphore.wait(timeout: .now() + 30)
 
    return imageObtainedFromUrl
}


/*
******************************************************************
MARK: - Copy Image File from Assets.xcassets to Document Directory
******************************************************************
*/
public func copyImageFileFromAssetsToDocumentDirectory(filename: String, fileExtension: String) {
   
    /*
     UIImage(named: filename)   gets image from Assets.xcassets as UIImage
     Image("filename")          gets image from Assets.xcassets as Image
     */
   
    //--------------
    // PNG File Copy
    //--------------
   
    if fileExtension == "png" {
        if let imageInAssets = UIImage(named: filename) {
           
            // pngData() returns a Data object containing the specified image in PNG format
            if let pngImageData = imageInAssets.pngData() {
                let fileUrlInDocDir = documentDirectory.appendingPathComponent("\(filename).png")
                do {
                    try pngImageData.write(to: fileUrlInDocDir)
                } catch {
                    print("Unable to write file \(filename).png to document directory!")
                }
            } else {
                print("Image file \(filename).png cannot be converted to PNG data format!")
            }
        } else {
            print("Image file \(filename).png does not exist in Assets.xcassets!")
        }
    }
   
    //---------------
    // JPEG File Copy
    //---------------
   
    if fileExtension == "jpg" {
        if let imageInAssets = UIImage(named: filename) {
            /*
             jpegData() returns a Data object containing the specified image
             in JPEG format with 100% compression quality
             */
            if let jpegImageData = imageInAssets.jpegData(compressionQuality: 1.0) {
                let fileUrlInDocDir = documentDirectory.appendingPathComponent("\(filename).jpg")
                do {
                    try jpegImageData.write(to: fileUrlInDocDir)
                } catch {
                    print("Unable to write file \(filename).jpg to document directory!")
                }
            } else {
                print("Image file \(filename).jpg cannot be converted to JPEG data format!")
            }
        } else {
            print("Image file \(filename).jpg does not exist in Assets.xcassets!")
        }
    }
   
}

/*
******************************************************
MARK: Copy File from Main Bundle to Document Directory
******************************************************
*/
public func copyFileFromMainBundleToDocumentDirectory(filename: String, fileExtension: String) {
   
    if let fileUrlInMainBundle = Bundle.main.url(forResource: filename, withExtension: fileExtension) {
       
        let fileUrlInDocDir = documentDirectory.appendingPathComponent("\(filename).\(fileExtension)")
       
        do {
            try FileManager.default.copyItem(at: fileUrlInMainBundle, to: fileUrlInDocDir)
        } catch {
            print("Unable to copy file \(filename).\(fileExtension) from main bundle to document directory!")
        }
       
    } else {
        print("The file \(filename).\(fileExtension) does not exist in main bundle!")
    }
}

/*
*****************************************
MARK: - Get Image from Document Directory
*****************************************
*/
public func getImageFromDocumentDirectory(filename: String, fileExtension: String, defaultFilename: String) -> Image {
 
    var imageData: Data?
   
    let urlOfImageInDocDir = documentDirectory.appendingPathComponent("\(filename).\(fileExtension)")
       
    do {
        // Try to get the image data from urlOfImageInDocDir
        imageData = try Data(contentsOf: urlOfImageInDocDir, options: NSData.ReadingOptions.mappedIfSafe)
    } catch {
        imageData = nil
    }
   
    // Unwrap imageData to see if it has a value
    if let imageDataObtained = imageData {
       
        // Create a UIImage object from imageDataObtained
        let uiImage = UIImage(data: imageDataObtained)
       
        // Unwrap uiImage to see if it has a value
        if let imageObtained = uiImage {
            // Convert UIImage to Image and return
            return Image(uiImage: imageObtained)
        } else {
            return Image(defaultFilename)
        }
    } else {
        /*
         Image file with name 'defaultFilename' is returned if the image with 'filename'
         cannot be obtained. Image file 'defaultFilename' must be given in Assets.xcassets
         */
        return Image(defaultFilename)
    }
   
}

/*
*****************************************
MARK: Get Thumbnail Image of a Video File
*****************************************
*/
public func getVideoThumbnailImage(url: URL) -> Image {
    
    let urlAsset = AVURLAsset(url: url, options: nil)
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
        return Image("ImageUnavailable")
    }
    
    if let thumbnailImage = thumbnailCGImage {
        let uiImage = UIImage(cgImage: thumbnailImage)
        return Image(uiImage: uiImage)
    }

    return Image("ImageUnavailable")
}
