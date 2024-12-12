
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
                if (photo.userAdded){
                    Section(header: Text("Photo Image")) {
                        getImageFromDocumentDirectory(filename: photo.image_url.components(separatedBy: ".")[0], fileExtension: photo.image_url.components(separatedBy: ".")[1], defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                            .contextMenu {
                                // Context Menu Item
                                Button(action: {
                                    // Copy the apartment photo to universal clipboard for pasting elsewhere
                                    UIPasteboard.general.image = UIImage(named: photo.image_url)
                                    
                                    showAlertMessage = true
                                    alertTitle = "Photo is Copied to Clipboard"
                                    alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                                }) {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy Image")
                                }
                            }
                    }
                }
                else{
                    Section(header: Text("Photo Image")) {
                        getImageFromUrl(url: photo.image_url, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                            .contextMenu {
                                // Context Menu Item
                                Button(action: {
                                    // Copy the apartment photo to universal clipboard for pasting elsewhere
                                    DispatchQueue.global().async {

                                            // Create url from string address
                                        guard let url = URL(string: photo.image_url) else {
                                            return
                                        }

                                        // Create data from url (You can handle exeption with try-catch)
                                        guard let data = try? Data(contentsOf: url) else {
                                            return
                                        }

                                        // Create image from data
                                        guard let image = UIImage(data: data) else {
                                            
                                            return
                                        }
                                        UIPasteboard.general.image = image

                                            
                                    }
                                    
                                    showAlertMessage = true
                                    alertTitle = "Photo is Copied to Clipboard"
                                    alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                                }) {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy Image")
                                }
                            }
                    }
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



