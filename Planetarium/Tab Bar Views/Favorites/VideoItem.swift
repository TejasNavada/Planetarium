//
//  VideoItem.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/25/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI

struct VideoItem: View {
    
    // Input Parameter
    let video: Video
    
    var body: some View {
        HStack {
            if(video.userAdded){
                getVideoThumbnailImage(url: documentDirectory.appendingPathComponent(video.video_url))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
            }
            else{
                getImageFromUrl(url: video.thumbnail_url, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
            }
            

            VStack(alignment: .leading) {
                Text(video.title)
                Text(video.center)
                HStack {
                    Image(systemName: "calendar")
                    Text(video.date_created)
                }
            }
            .font(.system(size: 14))
            
        }   // End of HStack
    }
    
}


