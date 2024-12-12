//
//  ApiAudioItem.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/25/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI

struct ApiAudioItem: View {
    
    // Input Parameter
    let audio: AudioStruct
    
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


