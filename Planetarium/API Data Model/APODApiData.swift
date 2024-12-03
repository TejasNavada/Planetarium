//
//  BookSearchApiData.swift
//  Planetarium
//
//  Created by Tejas Navada on 11/05/24.
//

import Foundation

// Global variable to hold the API search results

var Apod = APODStruct(title: "", date_created: "", photo_description: "", image_url: "")

public func getAPODFromApi() -> APODStruct? {
    

    let apiUrlString = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
    
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
        return APODStruct(title: "title", date_created: "date_created", photo_description: "photo_description", image_url: "image_url")
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
            var date_created = ""
            var title = ""
            var image_url = ""
            var photo_description = ""
            
            if let imagePath = jsonObject["url"] as? String{
                image_url = imagePath
            }
            if let descPath = jsonObject["explanation"] as? String{
                photo_description = descPath
            }
            if let titlePath = jsonObject["title"] as? String{
                title = titlePath
            }
            if let datePath = jsonObject["date"] as? String{
                date_created = datePath
            }
            print(image_url)
            let picture = APODStruct(title: title, date_created: date_created, photo_description: photo_description, image_url: image_url)
            Apod = picture
            return picture
               
                
        } else { return APODStruct(title: "title", date_created: "date_created", photo_description: "photo_description", image_url: "image_url") }
    } catch { return  APODStruct(title: "title", date_created: "date_created", photo_description: "photo_description", image_url: "image_url")}
  
}
