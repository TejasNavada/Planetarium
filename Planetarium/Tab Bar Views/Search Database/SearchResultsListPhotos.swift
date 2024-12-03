//
//  SearchResultsListPhotos.swift
//  BooksPhotos
//
//  Created by Tejas Navada on 11/05/24.
//

import SwiftUI

struct SearchResultsListPhotos: View {
    var body: some View {
        List {
            ForEach(databaseSearchResultsPhotos) { aPhoto in
                NavigationLink(destination: PhotoDetails(photo: aPhoto)) {
                    PhotoItem(photo: aPhoto)
                }
            }
        }
        .navigationTitle("Photos Found in Database")
        .toolbarTitleDisplayMode(.inline)
        
    }   // End of body
}


#Preview {
    SearchResultsListPhotos()
}
