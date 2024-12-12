//
//  SearchDatabase.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/25/24.
//

import SwiftUI
import SwiftData

struct SearchDatabase: View {
    
    
    
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false

    @State private var showAlertMessage = false
    @State private var dateStart = Date(timeIntervalSince1970: 0)
    @State private var dateEnd = Date(timeIntervalSinceNow: 0)
    
       
    let SearchCategoriesList = ["Title, Description or Center", "Date Range"]
    let databaseList = ["Photos", "Videos", "Audios"]
    
    @State private var selectedCategoryIndex = 0
    
    @State private var selectedDatabaseIndex = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("SearchDatabase")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                Section(header: Text("Search")) {
                    Picker("", selection: $selectedDatabaseIndex) {
                        ForEach(0 ..< databaseList.count, id: \.self) {
                            Text(databaseList[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Select A Search Category For "+databaseList[selectedDatabaseIndex])) {
                    Picker("", selection: $selectedCategoryIndex) {
                        ForEach(0 ..< SearchCategoriesList.count, id: \.self) {
                            Text(SearchCategoriesList[$0]).tag($0)
                        }
                    }
                }
                if(selectedCategoryIndex==0){
                    Section(header: Text("Search Query Under Selected Category")) {
                        HStack {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                            
                            // Button to clear the text field
                            Button(action: {
                                searchFieldValue = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                            
                        }   // End of HStack
                    }
                }
                else {
                    Section(header: Text("Start Date")) {
                        DatePicker(
                                "Start Date",
                                selection: $dateStart,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                    }
                    Section(header: Text("End Date")) {
                        DatePicker(
                                "End Date",
                                selection: $dateEnd,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                    }
                }
                
                Section(header: Text("Search Database")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchDB()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Please enter a database search query!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                        
                    }   // End of HStack
                }
                if searchCompleted {
                    Section(header: Text("List "+databaseList[selectedDatabaseIndex]+" Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List "+databaseList[selectedDatabaseIndex]+" Found")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    Section(header: Text("Clear")) {
                        HStack {
                            Spacer()
                            Button("Clear") {
                                searchCompleted = false
                                searchFieldValue = ""
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            
                            Spacer()
                        }
                    }
                }
                
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Search Database")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
            
        }   // End of NavigationStack
    }   // End of body var
    
    /*
     ---------------------
     MARK: Search Database
     ---------------------
     */
    func searchDB() {
        
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        searchQuery = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        date1 = dateStart
        date2 = dateEnd
        // searchCategory and searchQuery are global search parameters defined in DatabaseSearch.swift
        
        databaseIndex = selectedDatabaseIndex
        searchCategory = SearchCategoriesList[selectedCategoryIndex]
        
        // Public function conductDatabaseSearch is given in DatabaseSearch.swift
        conductDatabaseSearch()
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        
        // Global array databaseSearchResults is given in DatabaseSearch.swift
        
        if selectedDatabaseIndex==0{
            if databaseSearchResultsPhotos.isEmpty {
                return AnyView(
                    NotFound(message: "Database "+databaseList[selectedDatabaseIndex]+" Search Produced No Results!\n\nThe database did not return any value for the given search query!")
                )
            }
            return AnyView(SearchResultsListPhotos())
        }
        else if selectedDatabaseIndex == 1 {
            if databaseSearchResultsVideos.isEmpty {
                return AnyView(
                    NotFound(message: "Database "+databaseList[selectedDatabaseIndex]+" Search Produced No Results!\n\nThe database did not return any value for the given search query!")
                )
            }
            return AnyView(SearchResultsListVideos())
        }
        else{
            if databaseSearchResultsAudios.isEmpty{
                return AnyView(
                    NotFound(message: "Database "+databaseList[selectedDatabaseIndex]+" Search Produced No Results!\n\nThe database did not return any value for the given search query!")
                )
            }
            return AnyView(SearchResultsListAudios())
        }
        
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        
        if selectedCategoryIndex == 0{
            // Remove spaces, if any, at the beginning and at the end of the entered search query string
            let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if queryTrimmed.isEmpty {
                return false
            }
        }
        
        return true
    }
}


#Preview {
    SearchDatabase()
}
