//
//  DatabaseCreation.swift
//  Planetarium
//
//  Created by Tejas Navada on 12/11/24.
//

import SwiftUI
import SwiftData

public func createDatabase() {
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer
    
    do {
        // Create a database container to manage the Photo and Video objects
        modelContainer = try ModelContainer(for: Photo.self, Video.self, Audio.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context where the Photo and Video objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    /*
     --------------------------------------------------------------------
     |   Check to see if the database has already been created or not   |
     --------------------------------------------------------------------
     */
    let photoFetchDescriptor = FetchDescriptor<Photo>()
    var listOfAllPhotosInDatabase = [Photo]()
    
    do {
        // Obtain all of the Photo objects from the database
        listOfAllPhotosInDatabase = try modelContext.fetch(photoFetchDescriptor)
    } catch {
        fatalError("Unable to fetch Photo objects from the database")
    }
    
    if !listOfAllPhotosInDatabase.isEmpty {
        print("Database has already been created!")
//        do {
//            try modelContext.delete(model: Photo.self)
//            try modelContext.delete(model: Video.self)
//            try modelContext.delete(model: Audio.self)
//        } catch {
//            print("Failed to clear all data.")
//        }
        
        return
    }
    
    print("Database will be created!")
    
    /*
     ----------------------------------------------------------
     | *** The app is being launched for the first time ***   |
     |   Database needs to be created and populated with      |
     |   the initial content given in the JSON files.         |
     ----------------------------------------------------------
     */
    
    /*
     ******************************************************
     *   Create and Populate the Photos in the Database   *
     ******************************************************
     */
    var photoStructList = [PhotoStruct]()
    photoStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "PhotosDBInitialContent.json", fileLocation: "Main Bundle")
    
    for aPhoto in photoStructList {

       
        
        let newPhoto = Photo(center: aPhoto.center, title: aPhoto.title, date_created: aPhoto.date_created, photo_description: aPhoto.photo_description, image_url: aPhoto.image_url, userAdded: false)
        
        // Insert the new Photo object into the database
        modelContext.insert(newPhoto)
        
    }   // End of the for loop
    
    /*
     ******************************************************
     *   Create and Populate the Videos in the Database   *
     ******************************************************
     */
    var videoStructList = [VideoStruct]()
    videoStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "VideosDBInitialContent.json", fileLocation: "Main Bundle")
    
    for aVideo in videoStructList {
        
        // ❎ Instantiate a new Video object and dress it up
        let newVideo = Video(center: aVideo.center, title: aVideo.title, date_created: aVideo.date_created, video_description: aVideo.video_description, video_url: aVideo.video_url, thumbnail_url: aVideo.thumbnail_url, captions_url: aVideo.captions_url, userAdded: false)
        
        // ❎ Insert the new Video object into the database
        modelContext.insert(newVideo)
        
    }   // End of the for loop
    
    
    /*
     ******************************************************
     *   Create and Populate the Audios in the Database   *
     ******************************************************
     */
    var audioStructList = [AudioStruct]()
    audioStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "AudiosDBInitialContent.json", fileLocation: "Main Bundle")
    
    for anAudio in audioStructList {

       
        
        let newAudio = Audio(center: anAudio.center, title: anAudio.title, date_created: anAudio.date_created, audio_description: anAudio.audio_description, audio_url: anAudio.audio_url, userAdded: false)
        
        // Insert the new Photo object into the database
        modelContext.insert(newAudio)
        
    }   // End of the for loop
    /*
     =================================
     |   Save All Database Changes   |
     =================================
     🔴 NOTE: Database changes are automatically saved and SwiftUI Views are
     automatically refreshed upon State change in the UI or after a certain time period.
     But sometimes, you can manually save the database changes just to be sure.
     */
    do {
        try modelContext.save()
    } catch {
        fatalError("Unable to save database changes")
    }
    
    print("Database is successfully created!")
}

