//
//  SearchResultsListAudios.swift
//  BooksPhotos
//
//  Created by Tejas Navada on 11/05/24.
//

import SwiftUI

struct SearchResultsListAudios: View {
    var body: some View {
        List {
            ForEach(databaseSearchResultsAudios) { aAudio in
                NavigationLink(destination: AudioDetails(audio: aAudio, audioPlayer: AudioPlayer(), audioPlayerUser: AudioPlayerUser())) {
                    AudioItem(audio: aAudio)
                }
            }
        }
        .navigationTitle("Audios Found in Database")
        .toolbarTitleDisplayMode(.inline)
        
    }   // End of body
}


#Preview {
    SearchResultsListAudios()
}
