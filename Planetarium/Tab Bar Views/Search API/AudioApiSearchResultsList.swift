//
//  AudioApiSearchResultsList.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/25/24.
//

import SwiftUI

struct AudioApiSearchResultsList: View {
    var body: some View {
        List {
            ForEach(foundAudiosList, id:\.title) { aAudio in
                NavigationLink(destination: ApiAudioDetails(audio: aAudio, audioPlayer: AudioPlayer() )) {
                    ApiAudioItem(audio: aAudio)
                }
            }
        }   // End of List
        .font(.system(size: 14))
        .navigationTitle("Audios API Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    AudioApiSearchResultsList()
}
