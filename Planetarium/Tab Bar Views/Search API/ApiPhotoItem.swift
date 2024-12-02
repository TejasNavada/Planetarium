//
//  BookItem.swift
//  BooksPhotos
//
//  Created by Tejas Navada on 11/05/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI

struct ApiPhotoItem: View {
    
    // Input Parameter
    let photo: PhotoStruct
    
    var body: some View {
        HStack {
            getImageFromUrl(url: photo.image_url, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)

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


