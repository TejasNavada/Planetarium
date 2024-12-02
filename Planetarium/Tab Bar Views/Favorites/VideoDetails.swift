
//
//  ApiVideoDetails.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/05/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI
import MapKit


struct VideoDetails: View {
    
    // Input Parameter
    let video: Video
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
                Section(header: Text("Video Description")) {
                    Text(video.video_description)
                }
                Section(header: Text("Video Image")) {
                    getImageFromUrl(url: video.thumbnail_url, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                }
                
                Section(header: Text("Video Creation Date And Time")) {
                    Text(video.date_created)
                }
                
                Section(header: Text("Video Center")) {
                    Text(video.center)
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
    

}



