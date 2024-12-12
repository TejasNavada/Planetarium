//
//  SearchNasaApi.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/25/24.
//

import SwiftUI

struct SearchNasaApi: View {
    
    @State private var searchFieldValueTitle = ""
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    
    @State private var mediaIndex = 0
    @State private var media_type = ["Photos","Videos", "Audios"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("NasaLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                Section(header: Text("Media Type")) {
                    Picker("", selection: $mediaIndex) {
                        ForEach(0 ..< media_type.count, id: \.self) {
                            Text(media_type[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Enter Query to Search " + media_type[mediaIndex])) {
                    HStack {
                        TextField("Enter Search Query", text: $searchFieldValueTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        
                        // Button to clear the text field
                        Button(action: {
                            searchFieldValueTitle = ""
                            showAlertMessage = false
                            searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        
                    }   // End of HStack
                }
                
                
                Section(header: Text("Search API")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchApi()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Please enter a search query!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }   // End of HStack
                }
                
                if searchCompleted {
                    Section(header: Text("Show " + media_type[mediaIndex] + " Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundStyle(.blue)
                                Text("Show " + media_type[mediaIndex] + " Found")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    Section(header: Text("Clear")) {
                        HStack {
                            Spacer()
                            Button("Clear") {
                                searchCompleted = false
                                searchFieldValueTitle = ""
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            
                            Spacer()
                        }
                    }

                }
                                
            }   // End of Form
            .navigationTitle("Search Nasa Library API")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }
        
    }   // End of body var
    
    /*
     ----------------
     MARK: Search API
     ----------------
     */
    func searchApi() {
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryCleanedTitle = searchFieldValueTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Each space in the query should be converted to +
        let queryTitle = queryCleanedTitle.replacingOccurrences(of: " ", with: "+")
        
        // This public function is given in BookSearchApiData.swift
        if(mediaIndex==0){
            getPhotosFromApi(queryTitle: queryTitle)
        }
        else if(mediaIndex == 1){
            getVideosFromApi(queryTitle: queryTitle)
        }
        else{
            getAudiosFromApi(queryTitle: queryTitle)
        }
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        /*
         Search results are obtained in BookSearchApiData.swift and
         stored in the global var foundPhotosList = [PhotoStruct]()
         */
        if(mediaIndex == 0){
            if foundPhotosList.isEmpty {
                return AnyView(
                    NotFound(message: "No Photo Found!\n\nThe entered search query did not return any photo from the Nasa Library API! Please enter another search query.")
                )
            }
            
            return AnyView(PhotoApiSearchResultsList())
        }
        if(mediaIndex == 1){
            if foundVideosList.isEmpty {
                return AnyView(
                    NotFound(message: "No Video Found!\n\nThe entered search query did not return any audio from the Nasa Library API! Please enter another search query.")
                )
            }
            
            return AnyView(VideoApiSearchResultsList())
        }
        else{
            if foundAudiosList.isEmpty {
                return AnyView(
                    NotFound(message: "No Audio Found!\n\nThe entered search query did not return any audio from the Nasa Library API! Please enter another search query.")
                )
            }
            
            return AnyView(AudioApiSearchResultsList())
        }
        
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryTrimmedTitle = searchFieldValueTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if queryTrimmedTitle.isEmpty {
            return false
        }
        return true
    }
    
}

#Preview {
    SearchNasaApi()
}
