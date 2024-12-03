//
//  PhotosGrid.swift
//  PhotosVideos
//
//  Created by Osman Balci on 8/14/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData
import AVFoundation
import AVKit


struct PhotosGrid: View {

    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Video>(sortBy: [SortDescriptor(\Video.title, order: .forward)])) private var listOfAllVideosInDatabase: [Video]
    
    
    @State private var showAlertMessage = false
    
    // Fit as many photos per row as possible with minimum image width of 100 points each.
    // spacing defines spacing between columns
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 5) ]
    
    var body: some View {
        ScrollView {
            // spacing defines spacing between rows
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(listOfAllVideosInDatabase) { aVideo in
                    NavigationLink(destination:
                                    VideoPlayer(player: AVPlayer(url: URL(string: aVideo.video_url)!))
                        .navigationTitle("Tap Video to Play")
                        .toolbarTitleDisplayMode(.inline)
                    ){
                        getImageFromUrl(url: aVideo.thumbnail_url, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .scaledToFit()
                            // Speak photo info on tap gesture
                            // Display photo info on long press gesture
                            .onLongPressGesture {
                                showAlertMessage = true
                                alertTitle = aVideo.title
                                alertMessage = "This video was taken on \(aVideo.date_created) and is from the \(aVideo.center) Center"
                            }
                    }
                    
                    
                }   // End of ForEach
            }   // End of LazyVGrid
                .padding()
            
        }   // End of ScrollView
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
              Button("OK") {}
            }, message: {
              Text(alertMessage)
            })
        
    }   // End of body var
    
    //-----------------------
    // Convert Text to Speech
    //-----------------------
    

}   // End of PhotosGrid struct



#Preview {
    PhotosGrid()
}
