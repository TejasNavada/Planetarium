//
//  DatabaseClasses.swift
//  Planetarium
//
//  Created by Tejas Navada on 8/14/24.
//

import SwiftUI
import SwiftData

@Model
final class Photo {
    
    var center: String           // Photo center
    var title: String        // Photo title
    var date_created: String        // Date and time photo is taken or picked
    var photo_description: String        // photo description
    var image_url: String       // Photo URL
    
    init(center: String, title: String, date_created: String, photo_description: String, image_url: String) {
        self.center = center
        self.title = title
        self.date_created = date_created
        self.photo_description = photo_description
        self.image_url = image_url
    }
}



@Model
final class Video {
    
    var center: String           // Video center
    var title: String        // Video title
    var date_created: String        // Date and time Video is taken or picked
    var video_description: String        // Video description
    var video_url: String       // Video URL
    var thumbnail_url: String       // thumbnail URL
    var captions_url: String       // captions URL
    
    init(center: String, title: String, date_created: String, video_description: String, video_url: String, thumbnail_url: String, captions_url: String) {
        self.center = center
        self.title = title
        self.date_created = date_created
        self.video_description = video_description
        self.video_url = video_url
        self.thumbnail_url = thumbnail_url
        self.captions_url = captions_url
    }
}
@Model
final class Audio {
    
    var center: String           // Audio center
    var title: String        // Audio title
    var date_created: String        // Date and time Audio is taken or picked
    var audio_description: String        // Audio description
    var audio_url: String       // Audio URL
    
    init(center: String, title: String, date_created: String, audio_description: String, audio_url: String) {
        self.center = center
        self.title = title
        self.date_created = date_created
        self.audio_description = audio_description
        self.audio_url = audio_url
    }
}
