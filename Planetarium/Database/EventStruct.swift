//
//  EventStruct.swift
//  Planetarium
//
//  Created by Ryan Trieu on 12/2/24.
//  Copyright © 2024 Ryan Trieu. All rights reserved.
//

import SwiftUI

public struct EventStruct: Decodable {
    
    var title: String
    var geometry: [Geometry]
    var description: String?
    let categories: [Category]
    var sources: [Source]
}

public struct Geometry: Decodable {
    
    var magnitudeValue: Double?
    var magnitudeUnit: String?
    var type: String
    var coordinates: [Double]
    
}

public struct Category: Decodable {
    
    var id: String
    var title: String
    
}
public struct Source: Decodable {
    
    var id: String
    var url: String
    
}
