//
//  ToDoTasksList.swift
//  PIM
//
//  Created by Tejas Navada on 10/14/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI
import SwiftData

struct FavoritesList: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Photo>(sortBy: [SortDescriptor(\Photo.title, order: .forward)])) private var listOfPhotosInDatabase: [Photo]
    @Query(FetchDescriptor<Video>(sortBy: [SortDescriptor(\Video.title, order: .forward)])) private var listOfVideosInDatabase: [Video]
    @Query(FetchDescriptor<Audio>(sortBy: [SortDescriptor(\Audio.title, order: .forward)])) private var listOfAudiosInDatabase: [Audio]
    
    @State private var selectedIndex = 0
    var mediaType = ["Photos", "Videos", "Audios"]
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    
    // Search Bar: 1 of 4 --> searchText contains the search query entered by the user
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            Picker("Sort By", selection: $selectedIndex) {
                ForEach(0 ..< mediaType.count, id: \.self) { index in
                    Text(mediaType[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            List {
                // Search Bar: 2 of 4 --> Use filteredListOfTasks
                if(selectedIndex == 0){
                    ForEach(filteredListOfPhotos) { aPhoto in
                        NavigationLink(destination: PhotoDetails(photo: aPhoto)) {
                            PhotoItem(photo: aPhoto)
                                .alert(isPresented: $showConfirmation) {
                                    Alert(title: Text("Delete Confirmation"),
                                          message: Text("Are you sure to permanently delete the photo?"),
                                          primaryButton: .destructive(Text("Delete")) {
                                        /*
                                        'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                         element to be deleted. It is nil if the array is empty. Process it as an optional.
                                        */
                                        if let index = toBeDeleted?.first {
                                            let photoToDelete = filteredListOfPhotos[index]
                                            modelContext.delete(photoToDelete)
                                        }
                                        toBeDeleted = nil
                                    }, secondaryButton: .cancel() {
                                        toBeDeleted = nil
                                    }
                                )
                            }   // End of alert
                        }   // End of NavigationLink
                    }   // End of ForEach
                    .onDelete(perform: delete)
                }
                if(selectedIndex == 1){
                    ForEach(filteredListOfVideos) { aVideo in
                        NavigationLink(destination: VideoDetails(video: aVideo)) {
                            VideoItem(video: aVideo)
                                .alert(isPresented: $showConfirmation) {
                                    Alert(title: Text("Delete Confirmation"),
                                          message: Text("Are you sure to permanently delete the video?"),
                                          primaryButton: .destructive(Text("Delete")) {
                                        /*
                                        'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                         element to be deleted. It is nil if the array is empty. Process it as an optional.
                                        */
                                        if let index = toBeDeleted?.first {
                                            let videoToDelete = filteredListOfVideos[index]
                                            modelContext.delete(videoToDelete)
                                        }
                                        toBeDeleted = nil
                                    }, secondaryButton: .cancel() {
                                        toBeDeleted = nil
                                    }
                                )
                            }   // End of alert
                        }   // End of NavigationLink
                    }   // End of ForEach
                    .onDelete(perform: delete)
                }
                if(selectedIndex == 2){
                    ForEach(filteredListOfAudios) { aAudio in
                        NavigationLink(destination: AudioDetails(audio: aAudio, audioPlayer: AudioPlayer())) {
                            AudioItem(audio: aAudio)
                                .alert(isPresented: $showConfirmation) {
                                    Alert(title: Text("Delete Confirmation"),
                                          message: Text("Are you sure to permanently delete the audio?"),
                                          primaryButton: .destructive(Text("Delete")) {
                                        /*
                                        'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                         element to be deleted. It is nil if the array is empty. Process it as an optional.
                                        */
                                        if let index = toBeDeleted?.first {
                                            let audioToDelete = filteredListOfAudios[index]
                                            modelContext.delete(audioToDelete)
                                        }
                                        toBeDeleted = nil
                                    }, secondaryButton: .cancel() {
                                        toBeDeleted = nil
                                    }
                                )
                            }   // End of alert
                        }   // End of NavigationLink
                    }   // End of ForEach
                    .onDelete(perform: delete)
                }
                
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("Favorites List")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                // Place the Add (+) button on right side of the toolbar
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddFavorite()) {
                        Image(systemName: "plus")
                    }
                }
            }   // End of toolbar
            
        }   // End of NavigationStack
        .searchable(text: $searchText, prompt: "Search " + mediaType[selectedIndex])
        
    }   // End of body var
    
    /*
     ---------------------------
     MARK: Filter List of Photos
     ---------------------------
     */
    // Search Bar: 4 of 4 --> Compute filtered results
    var filteredListOfPhotos: [Photo] {
        if searchText.isEmpty {
            listOfPhotosInDatabase
        } else {
            listOfPhotosInDatabase.filter {
                $0.title.localizedStandardContains(searchText) ||
                $0.center.localizedStandardContains(searchText)
            }
        }
    }
    
    /*
     ---------------------------
     MARK: Filter List of Videos
     ---------------------------
     */
    // Search Bar: 4 of 4 --> Compute filtered results
    var filteredListOfVideos: [Video] {
        if searchText.isEmpty {
            listOfVideosInDatabase
        } else {
            listOfVideosInDatabase.filter {
                $0.title.localizedStandardContains(searchText) ||
                $0.center.localizedStandardContains(searchText)
            }
        }
    }
    
    /*
     ---------------------------
     MARK: Filter List of Photos
     ---------------------------
     */
    // Search Bar: 4 of 4 --> Compute filtered results
    var filteredListOfAudios: [Audio] {
        if searchText.isEmpty {
            listOfAudiosInDatabase
        } else {
            listOfAudiosInDatabase.filter {
                $0.title.localizedStandardContains(searchText) ||
                $0.center.localizedStandardContains(searchText)
            }
        }
    }
    
    /*
     ---------------------------
     MARK: Delete Selected Task
     ---------------------------
     */
    private func delete(offsets: IndexSet) {
        toBeDeleted = offsets
        showConfirmation = true
    }
 
}

#Preview {
    FavoritesList()
}
