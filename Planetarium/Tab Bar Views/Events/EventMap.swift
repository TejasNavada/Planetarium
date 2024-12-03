//
//  EventMap.swift
//  Planetarium
//
//  Created by Ryan Trieu on 12/2/24.
//  Copyright © 2024 Ryan Trieu. All rights reserved.
//

import SwiftUI
import MapKit

struct EventLocation: Identifiable {
    var id = UUID()
    var event: EventStruct
    var coordinate: CLLocationCoordinate2D
}

struct EventMap: View {
    @State private var listOfEvents: [EventStruct] = []
    @State private var mapPosition: MapCameraPosition = .automatic
    
    var body: some View {
        NavigationStack {
            eventAnnotations
                .navigationTitle("Natural Event Tracker")
                .toolbarTitleDisplayMode(.inline)
                .onAppear {
                    loadEvents()
                }
            
            
        }
    }
    
    var eventAnnotations: some View {
        var annotations = [EventLocation]()
        
        for anEvent in listOfEvents {
            if let firstGeometry = anEvent.geometry.first, firstGeometry.coordinates.count >= 2 {
                annotations.append(
                    EventLocation(event: anEvent, coordinate: CLLocationCoordinate2D(latitude: firstGeometry.coordinates[1], longitude: firstGeometry.coordinates[0]))
                )
            }
        }
        
        return AnyView(
            Map(position: $mapPosition) {
                ForEach(annotations) { loc in
                    Annotation(loc.event.title, coordinate: loc.coordinate) {
                        EventAnnotationView(event: loc.event)
                    }
                }
            }
            .mapStyle(.standard)
        )
    }
    
    private func loadEvents() {
        listOfEvents = getEventFromApi(category: nil, days: "100")
        
        if listOfEvents.isEmpty {
                print("No events were retrieved.")
            } else {
                print("\(listOfEvents.count) events retrieved.")
            }
        
        if let firstEvent = listOfEvents.first,
           let firstGeometry = firstEvent.geometry.first {
            mapPosition = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: firstGeometry.coordinates[1],
                    longitude: firstGeometry.coordinates[0]
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
            ))
        } else {
            mapPosition = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                span: MKCoordinateSpan(latitudeDelta: 180.0, longitudeDelta: 360.0)
            ))
        }
    }

}

struct EventAnnotationView: View {
    let event: EventStruct
    
    @State private var showEventDetails = false
    
    var body: some View {
        VStack(spacing: 0) {
            if showEventDetails {
                NavigationLink(destination: EventDetails(event: event)) {
                    Text(event.title)
                        .font(.caption)
                        .padding(5)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            Image(systemName: "mappin")
                .imageScale(.large)
                .font(Font.title.weight(.regular))
                .foregroundColor(.red)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showEventDetails.toggle()
                    }
                }
        }
    }
}
