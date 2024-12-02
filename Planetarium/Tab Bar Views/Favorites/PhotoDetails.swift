
//
//  ApiPhotoDetails.swift
//  BooksPhotos
//
//  Created by Tejas Navada on 11/05/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI
import MapKit


struct PhotoDetails: View {
    
    // Input Parameter
    let photo: Photo
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
                Section(header: Text("Photo Description")) {
                    Text(photo.photo_description)
                }
                Section(header: Text("Photo Image")) {
                    getImageFromUrl(url: photo.image_url, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                }
                
                Section(header: Text("Photo Creation Date And Time")) {
                    Text(photo.date_created)
                }
                
                Section(header: Text("Photo Center")) {
                    Text(photo.center)
                }
                
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Photo Details")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                  Button("OK") {}
                }, message: {
                  Text(alertMessage)
                })
            
        ) // End of AnyView
    }   // End of body var
    

}



