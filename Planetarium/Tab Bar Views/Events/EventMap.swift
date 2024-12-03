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
    @State private var selectedCategory: String = ""
    @State private var daysFilter: String = "100"
    @FocusState private var isFieldFocused: Bool
    
    let categories = ["All", "Earthquakes", "Volcanoes", "Wildfires", "Drought", "Floods", "Hurricanes"]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                eventAnnotations
                filterBox
                    .padding()
            }
            .navigationTitle("Natural Event Tracker")
            .toolbarTitleDisplayMode(.inline)
            .onAppear {
                loadEvents()
            }
            .onChange(of: selectedCategory) { newValue in
                loadEvents()
            }
            .onChange(of: daysFilter) { newValue in
                loadEvents()
            }
            
        }
    }
    
    var filterBox: some View {
        VStack(spacing: 10) {
            Menu {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        if category == "All" {
                            selectedCategory = ""
                        } else {
                            selectedCategory = category
                        }
                    }) {
                        Text(category)
                    }
                }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(selectedCategory.isEmpty ? "Select" : selectedCategory)
                        .font(.caption)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.9))
            .cornerRadius(8)
            .shadow(radius: 3)
            
            HStack {
                Text("Days:")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter Days Prior", text: $daysFilter)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .focused($isFieldFocused)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.9))
            .cornerRadius(8)
            .shadow(radius: 3)
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
        listOfEvents = getEventFromApi(category: selectedCategory, days: daysFilter)
        
        if listOfEvents.isEmpty {
            print("No events were retrieved.")

            mapPosition = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                span: MKCoordinateSpan(latitudeDelta: 180.0, longitudeDelta: 360.0)
            ))
        } else {
            print("\(listOfEvents.count) events retrieved.")
            
            let coordinates = listOfEvents.compactMap { event -> CLLocationCoordinate2D? in
                guard let firstGeometry = event.geometry.first, firstGeometry.coordinates.count >= 2 else {
                    return nil
                }
                return CLLocationCoordinate2D(latitude: firstGeometry.coordinates[1], longitude: firstGeometry.coordinates[0])
            }
            
            let latitudes = coordinates.map { $0.latitude }
            let longitudes = coordinates.map { $0.longitude }
            
            guard let minLat = latitudes.min(), let maxLat = latitudes.max(),
                  let minLon = longitudes.min(), let maxLon = longitudes.max() else {
                return
            }
            
            let center = CLLocationCoordinate2D(
                latitude: (minLat + maxLat) / 2,
                longitude: (minLon + maxLon) / 2
            )
            let span = MKCoordinateSpan(
                latitudeDelta: max(0.05, (maxLat - minLat) * 1.2),
                longitudeDelta: max(0.05, (maxLon - minLon) * 1.2)
            )
            
            mapPosition = .region(MKCoordinateRegion(center: center, span: span))
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
