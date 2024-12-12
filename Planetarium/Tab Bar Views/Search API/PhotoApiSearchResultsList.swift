//
//  PhotosApiSearchResultsList.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/25/24.
//

import SwiftUI

struct PhotoApiSearchResultsList: View {
    var body: some View {
        List {
            ForEach(foundPhotosList, id:\.title) { aPhoto in
                NavigationLink(destination: ApiPhotoDetails(photo: aPhoto)) {
                    ApiPhotoItem(photo: aPhoto)
                }
            }
        }   // End of List
        .font(.system(size: 14))
        .navigationTitle("Photos API Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    PhotoApiSearchResultsList()
}
