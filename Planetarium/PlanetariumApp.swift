//
//  PlanetariumApp.swift
//  Planetarium
//
//  Created by Tejas Navada on 12/1/24.
//

import SwiftUI
import SwiftData

@main
struct PlanetariumApp: App {
    
    init() {
        createDatabase()
        
        setUpJigsawPuzzle()
        
        getPermissionForLocation()
    }
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Change the color mode of the entire app to Dark or Light
                .preferredColorScheme(darkMode ? .dark : .light)
            
                /*
                 Inject the Model Container into the environment so that you can access its Model Context
                 in a SwiftUI file by using @Environment(\.modelContext) private var modelContext
                 */
                .modelContainer(for: [Photo.self, Video.self, Audio.self], isUndoEnabled: true)
        }
    }}
