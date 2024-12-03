
//  SearchResultsListVideos.swift
//  BooksPhotos
//
//  Created by Tejas Navada on 11/05/24.
//

import SwiftUI

struct SearchResultsListVideos: View {
    var body: some View {
        List {
            ForEach(databaseSearchResultsVideos) { aVideo in
                NavigationLink(destination: VideoDetails(video: aVideo)) {
                    VideoItem(video: aVideo)
                }
            }
        }
        .navigationTitle("Videos Found in Database")
        .toolbarTitleDisplayMode(.inline)
        
    }   // End of body
}


#Preview {
    SearchResultsListVideos()
}
