//
//  BookItem.swift
//  BooksPhotos
//
//  Created by Tejas Navada on 11/05/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI

struct AudioItem: View {
    
    // Input Parameter
    let audio: Audio
    
    var body: some View {
        HStack {

            VStack(alignment: .leading) {
                Text(audio.title)
                Text(audio.center)
                HStack {
                    Image(systemName: "calendar")
                    Text(audio.date_created)
                }
            }
            .font(.system(size: 14))
            
        }   // End of HStack
    }
    
}


