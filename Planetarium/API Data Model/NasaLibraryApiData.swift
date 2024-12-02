//
//  BookSearchApiData.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/05/24.
//

import Foundation

// Global variable to hold the API search results

var foundPhotosList = [PhotoStruct]()
var foundVideosList = [VideoStruct]()
var foundAudiosList = [AudioStruct]()

public func getVideosFromApi(queryTitle: String) {
    
    // Initialize the global variable to hold the API search results
    foundVideosList = [VideoStruct]()

    let apiUrlString = "https://images-api.nasa.gov/search?q=\(queryTitle)&media_type=video"
    
    /*
    ***************************************************
    *   Fetch JSON Data from the API Asynchronously   *
    ***************************************************
    */
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders:[:], apiUrl: apiUrlString, timeout: 30.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return
    }

    /*
    **************************************************
    *   Process the JSON Data Fetched from the API   *
    **************************************************
    */
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                           options: JSONSerialization.ReadingOptions.mutableContainers)

        if let jsonObject = jsonResponse as? [String: Any] {
            
            if let items = jsonObject["collection"] as? [String: Any] {
                if let arrayOfVideos = items["items"] as? [Any] {
                    // Iterate over the array
                    for foundVideo in arrayOfVideos {
                        
                        // Intializations of PhotoStruct
                        var center = ""
                        var title = ""
                        var date_created = ""
                        var video_description = ""
                        var video_url = ""
                        var captions_url = ""
                        var thumbnail_url = ""
                        
                        
                        
                        
                        let video = foundVideo as? [String: Any]
                        if let dataArray = video!["data"] as? [Any] {
                            if let data = dataArray[0] as? [String: Any]{
                                if let created_at = data["date_created"] as? String {

                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "en_US")
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                    let date = dateFormatter.date(from:created_at)!
                                    let formatter = DateFormatter()
                                    formatter.dateStyle = .medium
                                    formatter.timeStyle = .short
                                    date_created = formatter.string(from: date)
                                }
                                if let descriptionPath = data["description"] as? String {
                                    video_description = descriptionPath
                                }
                                if let centerPath = data["center"] as? String {
                                    center = centerPath
                                }
                                if let titlePath = data["title"] as? String {
                                    title = titlePath
                                }
                            }
                            
                        }
                        var collection = ""
                        if let id = video!["href"] as? String {
                            collection = id
                        } else {
                            continue
                        }
                        
                        var jsonDataFromApiInternal: Data
                        
                        
                        let jsonDataFetchedFromApiInternal = getJsonDataFromApi(apiHeaders:[:], apiUrl: collection, timeout: 10.0)
                        
                        if let jsonDataInternal = jsonDataFetchedFromApiInternal {
                            jsonDataFromApiInternal = jsonDataInternal
                        } else {
                            continue
                        }
                        let jsonResponseInternal = try JSONSerialization.jsonObject(with: jsonDataFromApiInternal,
                                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        var collectionData = [String]()
                        
                        if let jsonObjectInternal = jsonResponseInternal as? [String] {
                            collectionData = jsonObjectInternal
                            if let val = collectionData.first(where: { $0.hasSuffix("orig.mp4")}) {
                                video_url = val
                            }
                            if let val = collectionData.first(where: { $0.hasSuffix(".jpg")}) {
                                thumbnail_url = val
                            }
                            if let val = collectionData.first(where: { $0.hasSuffix(".srt")}) {
                                captions_url = val
                            }
                        } else {
                            print("jsonResponseInternal is not a JSON file!")
                            continue
                        }
                        
                        
                        
                        
                        
                        //-------------------------------------------------------------------
                        // Create an Instance of Photo Struct and Append it to the List
                        //-------------------------------------------------------------------
                        let newVideoFound = VideoStruct(center: center, title: title, date_created: date_created, video_description: video_description, video_url: video_url, thumbnail_url: thumbnail_url, captions_url: captions_url)
                        
                        foundVideosList.append(newVideoFound)
                        
                        

                    }// End of for loop
                    
                    foundVideosList = foundVideosList.sorted(by: { $0.title < $1.title })// Sort the list in alphabetical order with respect to Title
                    
                } else { return }
                
                
               
                
            } else { return }
        } else { return }
    } catch { return }
  
}


public func getPhotosFromApi(queryTitle: String) {
    
    // Initialize the global variable to hold the API search results
    foundPhotosList = [PhotoStruct]()

    let apiUrlString = "https://images-api.nasa.gov/search?q=\(queryTitle)&media_type=image"
    
    /*
    ***************************************************
    *   Fetch JSON Data from the API Asynchronously   *
    ***************************************************
    */
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders:[:], apiUrl: apiUrlString, timeout: 30.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return
    }

    /*
    **************************************************
    *   Process the JSON Data Fetched from the API   *
    **************************************************
    */
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                           options: JSONSerialization.ReadingOptions.mutableContainers)

        if let jsonObject = jsonResponse as? [String: Any] {
            
            if let items = jsonObject["collection"] as? [String: Any] {
                if let arrayOfPhotos = items["items"] as? [Any] {
                    // Iterate over the array
                    for foundPhoto in arrayOfPhotos {
                        
                        // Intializations of PhotoStruct
                        var center = ""
                        var title = ""
                        var date_created = ""
                        var photo_description = ""
                        var image_url = ""
                        
                        
                        
                        
                        let photo = foundPhoto as? [String: Any]
                        if let dataArray = photo!["data"] as? [Any] {
                            if let data = dataArray[0] as? [String: Any]{
                                if let created_at = data["date_created"] as? String {

                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "en_US")
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                    let date = dateFormatter.date(from:created_at)!
                                    let formatter = DateFormatter()
                                    formatter.dateStyle = .medium
                                    formatter.timeStyle = .short
                                    date_created = formatter.string(from: date)
                                }
                                if let descriptionPath = data["description"] as? String {
                                    photo_description = descriptionPath
                                }
                                if let centerPath = data["center"] as? String {
                                    center = centerPath
                                }
                                if let titlePath = data["title"] as? String {
                                    title = titlePath
                                }
                            }
                            
                        }
                        var collection = ""
                        if let id = photo!["href"] as? String {
                            collection = id
                        } else {
                            continue
                        }
                        
                        var jsonDataFromApiInternal: Data
                        
                        
                        let jsonDataFetchedFromApiInternal = getJsonDataFromApi(apiHeaders:[:], apiUrl: collection, timeout: 10.0)
                        
                        if let jsonDataInternal = jsonDataFetchedFromApiInternal {
                            jsonDataFromApiInternal = jsonDataInternal
                        } else {
                            continue
                        }
                        let jsonResponseInternal = try JSONSerialization.jsonObject(with: jsonDataFromApiInternal,
                                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        var collectionData = [String]()
                        
                        if let jsonObjectInternal = jsonResponseInternal as? [String] {
                            collectionData = jsonObjectInternal
                            image_url = collectionData[1]
                        } else {
                            print("jsonResponseInternal is not a JSON file!")
                            continue
                        }
                        
                        
                        
                        
                        
                        //-------------------------------------------------------------------
                        // Create an Instance of Photo Struct and Append it to the List
                        //-------------------------------------------------------------------
                        let newPhotoFound = PhotoStruct(center: center, title: title, date_created: date_created, photo_description: photo_description, image_url: image_url)
                        
                        foundPhotosList.append(newPhotoFound)

                    }// End of for loop
                    foundPhotosList = foundPhotosList.sorted(by: { $0.title < $1.title })// Sort the list in alphabetical order with respect to Title
                    
                } else { return }
                
                
               
                
            } else { return }
        } else { return }
    } catch { return }
  
}

public func getAudiosFromApi(queryTitle: String) {
    
    // Initialize the global variable to hold the API search results
    foundPhotosList = [PhotoStruct]()

    let apiUrlString = "https://images-api.nasa.gov/search?q=\(queryTitle)&media_type=audio"
    
    /*
    ***************************************************
    *   Fetch JSON Data from the API Asynchronously   *
    ***************************************************
    */
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders:[:], apiUrl: apiUrlString, timeout: 30.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return
    }

    /*
    **************************************************
    *   Process the JSON Data Fetched from the API   *
    **************************************************
    */
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                           options: JSONSerialization.ReadingOptions.mutableContainers)

        if let jsonObject = jsonResponse as? [String: Any] {
            
            if let items = jsonObject["collection"] as? [String: Any] {
                if let arrayOfAudios = items["items"] as? [Any] {
                    // Iterate over the array
                    for foundAudio in arrayOfAudios {
                        
                        // Intializations of PhotoStruct
                        var center = ""
                        var title = ""
                        var date_created = ""
                        var audio_description = ""
                        var audio_url = ""
                        
                        
                        
                        
                        let audio = foundAudio as? [String: Any]
                        if let dataArray = audio!["data"] as? [Any] {
                            if let data = dataArray[0] as? [String: Any]{
                                if let created_at = data["date_created"] as? String {

                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "en_US")
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                    let date = dateFormatter.date(from:created_at)!
                                    let formatter = DateFormatter()
                                    formatter.dateStyle = .medium
                                    formatter.timeStyle = .short
                                    date_created = formatter.string(from: date)
                                }
                                if let descriptionPath = data["description"] as? String {
                                    audio_description = descriptionPath
                                }
                                if let centerPath = data["center"] as? String {
                                    center = centerPath
                                }
                                if let titlePath = data["title"] as? String {
                                    title = titlePath
                                }
                            }
                            
                        }
                        var collection = ""
                        if let id = audio!["href"] as? String {
                            collection = id
                        } else {
                            continue
                        }
                        
                        var jsonDataFromApiInternal: Data
                        
                        
                        let jsonDataFetchedFromApiInternal = getJsonDataFromApi(apiHeaders:[:], apiUrl: collection, timeout: 10.0)
                        
                        if let jsonDataInternal = jsonDataFetchedFromApiInternal {
                            jsonDataFromApiInternal = jsonDataInternal
                        } else {
                            continue
                        }
                        let jsonResponseInternal = try JSONSerialization.jsonObject(with: jsonDataFromApiInternal,
                                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        var collectionData = [String]()
                        
                        if let jsonObjectInternal = jsonResponseInternal as? [String] {
                            collectionData = jsonObjectInternal
                            audio_url = collectionData[2]
                        } else {
                            print("jsonResponseInternal is not a JSON file!")
                            continue
                        }
                        
                        
                        
                        
                        
                        //-------------------------------------------------------------------
                        // Create an Instance of Photo Struct and Append it to the List
                        //-------------------------------------------------------------------
                        let newAudioFound = AudioStruct(center: center, title: title, date_created: date_created, audio_description: audio_description, audio_url: audio_url)
                        
                        foundAudiosList.append(newAudioFound)

                    }// End of for loop
                    foundAudiosList = foundAudiosList.sorted(by: { $0.title < $1.title })// Sort the list in alphabetical order with respect to Title
                    
                } else { return }
                
                
               
                
            } else { return }
        } else { return }
    } catch { return }
  
}
