//
//  Photos.swift
//  Planetarium
//
//  Created by Tejas Navada on 12/4/24.
//

import SwiftUI
import SwiftData

// Preserve selected background color between views
fileprivate var selectedColor = Color.gray.opacity(0.1)

struct Photos: View {
    
    // Default selected background color
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Photo>(sortBy: [SortDescriptor(\Photo.title, order: .forward)])) private var listOfPhotosInDatabase: [Photo]
    @State private var selectedBgColor = Color.gray.opacity(0.1)
    
    var body: some View {
        NavigationStack {
            ZStack {            // Background
                // Color entire background with selected color
                selectedBgColor
                
                // Place color picker at upper right corner
                VStack {        // Foreground
                    HStack {
                        Spacer()
                        ColorPicker("", selection: $selectedBgColor)
                            .padding()
                    }
                    Spacer()
                    
                    TabView {
                        // Since Photo  has the 'id' property, no need to specify 'id' in ForEach
                        ForEach(listOfPhotosInDatabase, id: \.title) { photo in
                            VStack {
                                Text(photo.title)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                if(photo.userAdded){
                                    getImageFromDocumentDirectory(filename: photo.image_url.components(separatedBy: ".")[0], fileExtension: photo.image_url.components(separatedBy: ".")[1], defaultFilename: "ImageUnavailable")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                else{
                                    getImageFromUrl(url: photo.image_url, defaultFilename: "ImageUnavailable")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                
                            }
                        }
                    }   // End of TabView
                    .tabViewStyle(PageTabViewStyle())
                    .onAppear() {
                        UIPageControl.appearance().currentPageIndicatorTintColor = .black
                        UIPageControl.appearance().pageIndicatorTintColor = .gray
                    }
                    
                }   // End of VStack
                .navigationTitle("Favorite Photos")
                .toolbarTitleDisplayMode(.inline)
                .onAppear() {
                    selectedBgColor = selectedColor
                }
                .onDisappear() {
                    selectedColor = selectedBgColor
                }
                
            }   // End of ZStack
        }   // End of NavigationStack
    }   // End of body var
    

}

#Preview {
    Photos()
}
