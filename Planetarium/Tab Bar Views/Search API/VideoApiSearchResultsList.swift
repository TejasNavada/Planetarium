//
//  VideoApiSearchResultsList.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/25/24.
//

import SwiftUI

struct VideoApiSearchResultsList: View {
    var body: some View {
        List {
            ForEach(foundVideosList, id:\.title) { aVideo in
                NavigationLink(destination: ApiVideoDetails(video: aVideo)) {
                    ApiVideoItem(video: aVideo)
                }
            }
        }   // End of List
        .font(.system(size: 14))
        .navigationTitle("Videos API Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    PhotoApiSearchResultsList()
}
