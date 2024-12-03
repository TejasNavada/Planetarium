
//
//  ApiPhotoDetails.swift
//  BooksPhotos
//
//  Created by Tejas Navada on 11/05/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI
import MapKit


struct ApiPhotoDetails: View {
    
    // Input Parameter
    let photo: PhotoStruct
    @Environment(\.modelContext) private var modelContext
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var showAlertMessage = false
    
    var body: some View {
        

        
        return AnyView(
            Form {
                Section(header: Text("Photo Title")) {
                    Text(photo.title)
                }
                Section(header: Text("Photo Image")) {
                    getImageFromUrl(url: photo.image_url, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                }
                Section(header: Text("Photo Description")) {
                    Text(photo.photo_description)
                }
                
                Section(header: Text("Photo Creation Date And Time")) {
                    Text(photo.date_created)
                }
                
                Section(header: Text("Photo Center")) {
                    Text(photo.center)
                }
                Section(header: Text("Add Photo to Database as Favorite")) {
                    Button(action: {
                        savePhotoToDatabaseAsFavorite()
                        
                        showAlertMessage = true
                        alertTitle = "Photo Added!"
                        alertMessage = "Selected photo is added to the database as your favorite."
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Add Photo to Database")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Found Photo Details")
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
     MARK: Save Photo to Database as Favorite
     ----------------------------------------
     */
    func savePhotoToDatabaseAsFavorite() {
        
        /*
         =============================
         |   Photo Object Creation   |
         =============================
         */
        
        // Instantiate a new Photo object and dress it up
        let newPhoto = Photo(center: photo.center, title: photo.title, date_created: photo.date_created, photo_description: photo.photo_description, image_url: photo.image_url)
        
        // ❎ Insert it into the database context
        modelContext.insert(newPhoto)

        
        
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



