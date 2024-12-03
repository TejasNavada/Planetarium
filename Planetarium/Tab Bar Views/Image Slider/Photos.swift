//
//  Photos.swift
//  Blacksburg
//
//  Created by Osman Balci on 9/4/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
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
                                getImageFromUrl(url: photo.image_url, defaultFilename: "ImageUnavailable")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }   // End of TabView
                    .tabViewStyle(PageTabViewStyle())
                    .onAppear() {
                        UIPageControl.appearance().currentPageIndicatorTintColor = .black
                        UIPageControl.appearance().pageIndicatorTintColor = .gray
                    }
                    
                }   // End of VStack
                .navigationTitle("Blacksburg Photos")
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
