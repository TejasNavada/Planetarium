
//
//  ApiPhotoDetails.swift
//  BooksPhotos
//
//  Created by Tejas Navada on 11/05/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI
import MapKit


struct ApiAudioDetails: View {
    
    // Input Parameter
    let audio: AudioStruct
    @Environment(\.modelContext) private var modelContext
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var showAlertMessage = false
    
    var body: some View {
        

        
        return AnyView(
            Form {
                Section(header: Text("Audio Title")) {
                    Text(audio.title)
                }
                Section(header: Text("Audio Description")) {
                    Text(audio.audio_description)
                }
                
                Section(header: Text("Audio Creation Date And Time")) {
                    Text(audio.date_created)
                }
                
                Section(header: Text("Audio Center")) {
                    Text(audio.center)
                }
                Section(header: Text("Add Audio to Database as Favorite")) {
                    Button(action: {
                        saveAudioToDatabaseAsFavorite()
                        
                        showAlertMessage = true
                        alertTitle = "Audio Added!"
                        alertMessage = "Selected audio is added to the database as your favorite."
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Add Audio to Database")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Found Audio Details")
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
     MARK: Save Audio to Database as Favorite
     ----------------------------------------
     */
    func saveAudioToDatabaseAsFavorite() {
        
        /*
         =============================
         |   Audio Object Creation   |
         =============================
         */
        
        // Instantiate a new Photo object and dress it up
        let newAudio = Audio(center: audio.center, title: audio.title, date_created: audio.date_created, audio_description: audio.audio_description, audio_url: audio.audio_url)
        
        // ❎ Insert it into the database context
        modelContext.insert(newAudio)

        
        
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



