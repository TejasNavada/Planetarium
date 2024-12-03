//
//  EventDetails.swift
//  Planetarium
//
//  Created by Thomas McNamara on 12/2/24.
//  Copyright © 2024 Thomas McNamara. All rights reserved.
//

import SwiftUI

struct EventDetails: View {
    
    let event: EventStruct
    
    var body: some View {
        
        return AnyView(
            Form {
                Section(header: Text("Event Title")) {
                    Text(event.title)
                }
                Section(header: Text("Event Description")) {
                    Text(event.description ?? "")
                }
                if let firstCoordinate = event.geometry.first?.coordinates{
                    Section(header: Text("Coordinates")) {
                        Text("Latitude: " + String(firstCoordinate[0]))
                        Text("Longitude: " + String(firstCoordinate[1]))
                    }
                } else {
                    Section(header: Text("Coordinates")) {
                        Text("No coordinates")
                            .foregroundColor(.gray)
                    }
                }
                if let firstCategory = event.categories.first{
                    Section(header: Text("Category")) {
                        Text(firstCategory.title)
                    }
                } else {
                    Section(header: Text("Category")) {
                        Text("None")
                    }
                }
                
                if let firstSource = event.sources.first{
                    Section(header: Text("Report Website")) {
                        Link(destination: URL(string: firstSource.url)!) {
                            HStack {
                                Image(systemName: "globe")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Show Report Website")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                } else {
                    Section(header: Text("Report Website")) {
                        Text("No report website found")
                    }
                }
                
                
            }
        )
    }
}
