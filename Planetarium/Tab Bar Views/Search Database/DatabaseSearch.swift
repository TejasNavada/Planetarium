//
//  DatabaseSearch.swift
//  BooksPhotos
//
//  Created by Tejas Navada on 11/05/24.
//

import SwiftUI
import SwiftData

// Global variable to hold database search results
var databaseSearchResultsPhotos = [Photo]()
var databaseSearchResultsVideos = [Video]()
var databaseSearchResultsAudios = [Audio]()

// Global Search Parameters
var databaseIndex = 0
var searchCategory = ""
var searchQuery = ""
var date1 = Date.distantPast
var date2 = Date.distantFuture

public func conductDatabaseSearch() {
    let dateFormatter = DateFormatter()

    // Set the format of the input string
    dateFormatter.dateFormat = "MMM dd, yyyy 'at' h:mm a"

    // Set the locale to ensure correct parsing (optional but recommended)
    dateFormatter.locale = Locale(identifier: "en_US")
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer
    
    do {
        // Create a database container to manage Movie, Genre, Director, and Actor objects
        modelContainer = try ModelContainer(for: Photo.self, Video.self,Audio.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context (workspace) where database objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    // Initialize the global variable to hold the database search results
    databaseSearchResultsVideos = [Video]()
    databaseSearchResultsAudios = [Audio]()
    databaseSearchResultsPhotos = [Photo]()
    switch databaseIndex{
    case 0:
        switch searchCategory {
            
        case "Title, Description or Center":
            // 1️⃣ Define the Search Criterion (Predicate)
            let titlePredicate = #Predicate<Photo> {
                $0.title.localizedStandardContains(searchQuery) ||
                $0.photo_description.localizedStandardContains(searchQuery) ||
                $0.center.localizedStandardContains(searchQuery)
                // Perform CASE INSENSITIVE Search
            }
            
            // 2️⃣ Define the Fetch Descriptor
            let titleFetchDescriptor = FetchDescriptor<Photo>(
                predicate: titlePredicate,
                sortBy: [SortDescriptor(\Photo.title, order: .forward)]
            )
            
            // 3️⃣ Execute the Fetch Request
            do {
                databaseSearchResultsPhotos = try modelContext.fetch(titleFetchDescriptor)
            } catch {
                fatalError("Unable to fetch title data from the database")
            }
            
        case "Date Range":
            // 2️⃣ Define the Fetch Descriptor
            let titleFetchDescriptor = FetchDescriptor<Photo>(
                sortBy: [SortDescriptor(\Photo.title, order: .forward)]
            )
            
            // 3️⃣ Execute the Fetch Request
            do {
                 let temp = try modelContext.fetch(titleFetchDescriptor)
                databaseSearchResultsPhotos = temp.filter({dateFormatter.date(from: $0.date_created)! > date1 && dateFormatter.date(from: $0.date_created)! < date2})
            } catch {
                fatalError("Unable to fetch title data from the database")
            }
        default:
            print("Search category is out of range!")
        }
        
    case 1:
        switch searchCategory {
            
        case "Title, Description or Center":
            // 1️⃣ Define the Search Criterion (Predicate)
            let titlePredicate = #Predicate<Video> {
                $0.title.localizedStandardContains(searchQuery) ||
                $0.video_description.localizedStandardContains(searchQuery) ||
                $0.center.localizedStandardContains(searchQuery)
                // Perform CASE INSENSITIVE Search
            }
            
            // 2️⃣ Define the Fetch Descriptor
            let titleFetchDescriptor = FetchDescriptor<Video>(
                predicate: titlePredicate,
                sortBy: [SortDescriptor(\Video.title, order: .forward)]
            )
            
            // 3️⃣ Execute the Fetch Request
            do {
                databaseSearchResultsVideos = try modelContext.fetch(titleFetchDescriptor)
            } catch {
                fatalError("Unable to fetch title data from the database")
            }
            
        case "Date Range":
            // 2️⃣ Define the Fetch Descriptor
            let titleFetchDescriptor = FetchDescriptor<Video>(
                sortBy: [SortDescriptor(\Video.title, order: .forward)]
            )
            
            // 3️⃣ Execute the Fetch Request
            do {
                 let temp = try modelContext.fetch(titleFetchDescriptor)
                databaseSearchResultsVideos = temp.filter({dateFormatter.date(from: $0.date_created)! > date1 && dateFormatter.date(from: $0.date_created)! < date2})
                print(databaseSearchResultsVideos)
            } catch {
                fatalError("Unable to fetch title data from the database")
            }
        default:
            print("Search category is out of range!")
        }
        
        
    case 2:
        switch searchCategory {
            
        case "Title, Description or Center":
            // 1️⃣ Define the Search Criterion (Predicate)
            let titlePredicate = #Predicate<Audio> {
                $0.title.localizedStandardContains(searchQuery) ||
                $0.audio_description.localizedStandardContains(searchQuery) ||
                $0.center.localizedStandardContains(searchQuery)
                // Perform CASE INSENSITIVE Search
            }
            
            // 2️⃣ Define the Fetch Descriptor
            let titleFetchDescriptor = FetchDescriptor<Audio>(
                predicate: titlePredicate,
                sortBy: [SortDescriptor(\Audio.title, order: .forward)]
            )
            
            // 3️⃣ Execute the Fetch Request
            do {
                databaseSearchResultsAudios = try modelContext.fetch(titleFetchDescriptor)
            } catch {
                fatalError("Unable to fetch title data from the database")
            }
            
        case "Date Range":
            
            // 2️⃣ Define the Fetch Descriptor
            let titleFetchDescriptor = FetchDescriptor<Audio>(
                sortBy: [SortDescriptor(\Audio.title, order: .forward)]
            )
            
            // 3️⃣ Execute the Fetch Request
            do {
                 let temp = try modelContext.fetch(titleFetchDescriptor)
                databaseSearchResultsAudios = temp.filter({dateFormatter.date(from: $0.date_created)! > date1 && dateFormatter.date(from: $0.date_created)! < date2})
            } catch {
                fatalError("Unable to fetch title data from the database")
            }
        default:
            print("Search category is out of range!")
        }
        
    default:
        print("Databse selection is out of range!")
    }
    
    

    
}
