//
//  EONETApi.swift
//  Planetarium
//
//  Created by Ryan Trieu on 12/2/24.
//  Copyright © 2024 Ryan Trieu. All rights reserved.
//

import Foundation

var foundEventsList = [EventStruct]()

public func getEventFromApi(category: String?, days: String) -> [EventStruct] {
    
    foundEventsList = [EventStruct]()
    
    var apiUrlString = "https://eonet.gsfc.nasa.gov/api/v3/events?days=\(days)"
    
    if let category = category, !category.isEmpty {
        apiUrlString += "&category=\(category)"
    }
    
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders:[:], apiUrl: apiUrlString, timeout: 30.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return []
    }
    
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                           options: JSONSerialization.ReadingOptions.mutableContainers)
        
        var searchResultsJsonArray = [Any]()
        
        if let jsonObject = jsonResponse as? [String: Any],
           let businessesArray = jsonObject["events"] as? [Any] {
            searchResultsJsonArray = businessesArray
        } else {
            return []
        }
        
        for eventJsonObject in searchResultsJsonArray {
            
            guard let eventDataDictionary = eventJsonObject as? [String: Any] else {
                continue
            }
            
            let title = eventDataDictionary["title"] as? String ?? ""
            let description = eventDataDictionary["description"] as? String
            
            var categories = [Category]()
            if let categoriesArray = eventDataDictionary["categories"] as? [[String: Any]] {
                for categoryDict in categoriesArray {
                    if let id = categoryDict["id"] as? String, let title = categoryDict["title"] as? String {
                        categories.append(Category(id: id, title: title))
                    }
                }
            }
            
            var geometry = [Geometry]()
            if let geometryArray = eventDataDictionary["geometry"] as? [[String: Any]] {
                for geometryDict in geometryArray {
                    if let type = geometryDict["type"] as? String,
                       let coordinates = geometryDict["coordinates"] as? [Double] {
                        let magnitudeValue = geometryDict["magnitudeValue"] as? Double
                        let magnitudeUnit = geometryDict["magnitudeUnit"] as? String
                        geometry.append(Geometry(magnitudeValue: magnitudeValue,
                                                                 magnitudeUnit: magnitudeUnit,
                                                                 type: type,
                                                                 coordinates: coordinates))
                    }
                }
            }
            
            let event = EventStruct(title: title, geometry: geometry, description: description, categories: categories)
            foundEventsList.append(event)
            
        }
        
    } catch {
        return []
    }
    
    return []
}
