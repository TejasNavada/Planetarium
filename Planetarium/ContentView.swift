//
//  ContentView.swift
//  Planetarium
//
//  Created by CS3714 on 12/1/24.
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
                
            }
            Tab("Favorites", systemImage: "star") {
                FavoritesList()
            }
            Tab("Events", systemImage: "globe.europe.africa.fill") {
                
            }
            Tab("Database Images in Slider", systemImage: "photo.on.rectangle.angled.fill") {
                
            }
            Tab("Database Videos in Image Grid", systemImage: "square.grid.3x3.fill") {
                
            }
            Tab("Search Database", systemImage: "rectangle.and.text.magnifyingglass") {
                //SearchCocktailByCategoryAPI()
            }
            Tab("Search Nasa Library API", systemImage: "doc.text.magnifyingglass") {
                SearchNasaApi()
            }
            Tab("Settings", systemImage: "gear") {
                //Settings()
            }
        }   // End of TabView
        .tabViewStyle(.sidebarAdaptable)
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Photo.self, inMemory: true)
}
