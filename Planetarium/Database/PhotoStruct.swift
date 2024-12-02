//
//  PhotoStruct.swift
//  Planetarium
//
//  Created by Tejas Navada on 8/14/24.
//

import SwiftUI

// Used to populate the database with intitial content in PhotosDBInitialContent.json
struct PhotoStruct: Codable {
    
    var center: String           // Photo center
    var title: String        // Photo title
    var date_created: String        // Date and time photo is taken or picked
    var photo_description: String        // photo description
    var image_url: String       // Photo URL
    
    
    enum CodingKeys: String, CodingKey {
            case center
            case title
            case date_created
            case photo_description
            case image_url
        }
}

/*
 {
     "title": "Agra, India",
     "category": "Family Vacation",
     "fullFilename": "8E04045D-EC1F-4A09-ACA1-6E2F06CE8E68.jpg",
     "dateTime": "2019-02-15 at 14:24:52",
     "latitude": 27.167641,
     "longitude": 78.035873,
     "rating": 5.0
 }
 */
