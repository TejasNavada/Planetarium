
//
//  VideoDetails.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/25/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI
import AVKit

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
                if (video.userAdded){
                    Section(header: Text("Video Thumbnail")) {
                        getVideoThumbnailImage(url: documentDirectory.appendingPathComponent(video.video_url))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    }
                    Section(header: Text("Play Video")) {
                        NavigationLink(destination:
                                        VideoPlayer(player: AVPlayer(url: documentDirectory.appendingPathComponent(video.video_url)))
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
                }
                else{
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
                
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Video Details")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                  Button("OK") {}
                }, message: {
                  Text(alertMessage)
                })
            
        ) // End of AnyView
    }   // End of body var
    

}



