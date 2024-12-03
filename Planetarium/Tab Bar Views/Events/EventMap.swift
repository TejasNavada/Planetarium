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
    @State private var numDays = "20"
    
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
            ZStack(alignment: .topLeading){
                Map(position: $mapPosition) {
                    ForEach(annotations) { loc in
                        Annotation(loc.event.title, coordinate: loc.coordinate) {
                            EventAnnotationView(event: loc.event)
                        }
                    }
                }
                .mapStyle(.standard)
                HStack(alignment: .firstTextBaseline) {
                    Text("Enter Days into the past")
                        .padding(.top)
                        .padding(.leading)
                    TextField("Enter Number of Days", text: $numDays)
                        .keyboardType(.numberPad)
                        .onChange(of: numDays) { newValue in
                            // Validate that the input is a valid number
                            if let _ = Int(newValue) {
                                // Valid number, do nothing
                                loadEvents()
                            } else {
                                // Invalid input, reset the value to the previous valid input
                                numDays = String(newValue.dropLast())
                            }
                        }
                        .padding()
                        .textFieldStyle(PlainTextFieldStyle())
                        .background(Color.clear)  // Transparent background
                        .frame(maxWidth: 60)
                        .cornerRadius(8) // Add rounded corners
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2) //  Add border for visibility
                        )
                }
                .background(Color.white.opacity(0.4))
                .cornerRadius(10)
                .padding()
            }
            
        )
    }
    
    private func loadEvents() {
        listOfEvents = getEventFromApi(category: nil, days: numDays)
        
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
                span: MKCoordinateSpan(latitudeDelta: 180.0, longitudeDelta: 360.0
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
