//
//  ContentView.swift
//  Planetarium
//
//  Created by Tejas Navada on 12/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                Home()
            }
            Tab("Puzzle", systemImage: "puzzlepiece.extension.fill") {
                PlayJigsawPuzzle()
            }
            Tab("Favorites", systemImage: "star") {
                FavoritesList()
            }
            Tab("Events", systemImage: "globe.europe.africa.fill") {
                EventMap()
            }
            Tab("Database Images in Slider", systemImage: "photo.on.rectangle.angled.fill") {
                Photos()
            }
            Tab("Database Videos in Image Grid", systemImage: "square.grid.3x3.fill") {
                PhotosGrid()
            }
            Tab("Search Database", systemImage: "rectangle.and.text.magnifyingglass") {
                SearchDatabase()
            }
            Tab("Search Nasa Library API", systemImage: "doc.text.magnifyingglass") {
                SearchNasaApi()
            }
            Tab("Settings", systemImage: "gear") {
                Settings()
            }
        }   // End of TabView
        .tabViewStyle(.sidebarAdaptable)
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Photo.self, inMemory: true)
}
