
//
//  ApiPhotoDetails.swift
//  BooksPhotos
//
//  Created by Tejas Navada on 11/05/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI
import MapKit


struct AudioDetails: View {
    
    // Input Parameter
    let audio: Audio
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
    
}



