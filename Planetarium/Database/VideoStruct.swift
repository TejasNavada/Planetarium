//
//  VideoStruct.swift
//  Planetarium
//
//  Created by Tejas Navada on 12/11/24.
//

import SwiftUI

// Used to populate the database with intitial content in VideosDBInitialContent.json
struct VideoStruct: Decodable, Encodable {
    
    var center: String           // Video center
    var title: String        // Video title
    var date_created: String        // Date and time Video is taken or picked
    var video_description: String        // Video description
    var video_url: String       // Video URL
    var thumbnail_url: String       // thumbnail URL
    var captions_url: String       // captions URL
}
/*
 {
     "title": "Barcelona, Spain",
     "category": "Boys-Only Trip",
     "fullFilename": "ED286A58-689E-4B65-90B7-BF7EE65E0CD1.mp4",
     "dateTime": "2022-01-10 at 14:45:30",
     "latitude": 41.385063,
     "longitude": 2.173404,
     "rating": 3.0
 }
 */
