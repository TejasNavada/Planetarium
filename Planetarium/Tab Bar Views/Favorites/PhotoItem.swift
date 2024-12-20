//
//  PhotoItem.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/25/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI

struct PhotoItem: View {
    
    // Input Parameter
    let photo: Photo
    
    var body: some View {
        HStack {
            if (photo.userAdded){
                getImageFromDocumentDirectory(filename: photo.image_url.components(separatedBy: ".")[0], fileExtension: photo.image_url.components(separatedBy: ".")[1], defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            }
            else{
                getImageFromUrl(url: photo.image_url, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
            }
            

            VStack(alignment: .leading) {
                Text(photo.title)
                Text(photo.center)
                HStack {
                    Image(systemName: "calendar")
                    Text(photo.date_created)
                }
            }
            .font(.system(size: 14))
            
        }   // End of HStack
    }
    
}


