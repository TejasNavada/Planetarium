
//
//  ApiVideoDetails.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/05/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI
import AVKit


struct ApiVideoDetails: View {
    
    // Input Parameter
    let video: VideoStruct
    @Environment(\.modelContext) private var modelContext
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var showAlertMessage = false
    
    var body: some View {
        

        
        return AnyView(
            Form {
                Section(header: Text("Video Title")) {
                    Text(video.title)
                }
                Section(header: Text("Video Thumbnail")) {
                    getImageFromUrl(url: video.thumbnail_url, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                }
                Section(header: Text("Play Video")) {
                    NavigationLink(destination:
                                    VideoPlayer(player: AVPlayer(url: URL(string: video.video_url)!))
                        .navigationTitle("Tap Video to Play")
                        .toolbarTitleDisplayMode(.inline)
                    ){
                        HStack {
                            Image(systemName: "play.rectangle.fill")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Play Video")
                                .font(.system(size: 16))
                        }
                    }
                }
                Section(header: Text("Video Description")) {
                    Text(video.video_description)
                }
                
                Section(header: Text("Video Creation Date And Time")) {
                    Text(video.date_created)
                }
                
                Section(header: Text("Video Center")) {
                    Text(video.center)
                }
                Section(header: Text("Add Video to Database as Favorite")) {
                    Button(action: {
                        saveVideoToDatabaseAsFavorite()
                        
                        showAlertMessage = true
                        alertTitle = "Video Added!"
                        alertMessage = "Selected video is added to the database"
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Add Video to Database")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Found Video Details")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                  Button("OK") {}
                }, message: {
                  Text(alertMessage)
                })
            
        ) // End of AnyView
    }   // End of body var
    
    /*
     ----------------------------------------
     MARK: Save Video to Database as Favorite
     ----------------------------------------
     */
    func saveVideoToDatabaseAsFavorite() {
        
        /*
         =============================
         |   Photo Object Creation   |
         =============================
         */
        
        // Instantiate a new Photo object and dress it up
        let newVideo = Video(center: video.center, title: video.title, date_created: video.date_created, video_description: video.video_description, video_url: video.video_url, thumbnail_url: video.thumbnail_url, captions_url: video.captions_url, userAdded: false)
        
        // ❎ Insert it into the database context
        modelContext.insert(newVideo)

        
        
        /*
         =================================
         |   Save All Database Changes   |
         =================================
         */
        do {
            try modelContext.save()
        } catch {
            fatalError("Unable to save database changes")
        }
        
    }   // End of function 
}



