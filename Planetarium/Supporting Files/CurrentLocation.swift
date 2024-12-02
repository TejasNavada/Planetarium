//
//  CurrentLocation.swift
//  Planetarium
//
//  Created by Osman Balci on 8/14/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import Foundation
import CoreLocation
 
/*
 Instantiate a CLLocationManager object globally. If you do this in the getUsersCurrentLocation()
 function below, requestWhenInUseAuthorization() message quickly disappears and the user is not
 given enough time to authorize location determination because exiting the called function
 terminates the locationManager. If it is global, it stays even after exiting the function.
 */
let locationManager = CLLocationManager()
 
/*
 ================================================================
 |   Get User's Permission for Current Location Determination   |
 ================================================================
*/
public func getPermissionForLocation() {
    /*
     We need to obtain the user's permission to access his/her location much before we need it.
     Doing this in the getUsersCurrentLocation() function below would be too late since it
     will not be recorded in time to allow access when the function executes. Therefore,
     we call this function from main app upon app launch and do it here.
    */
    locationManager.requestWhenInUseAuthorization()
}
 
/*
 ===============================================================================
 |   Obtain and Return the User's Current Location as CLLocationCoordinate2D   |
 ===============================================================================
*/
public func getUsersCurrentLocation() -> CLLocationCoordinate2D {
    /*
     🔴 Current GPS location cannot be accurately determined under the iOS Simulator
        on your laptop or desktop computer because those computers do NOT have a GPS antenna.
        *** Therefore, do NOT expect the code herein to work under the iOS Simulator! ***
   
     You must deploy your location-aware app to an iOS device to be able to test it properly.
 
     Monitoring the user's current location is a serious privacy issue!
     🔴 Set one of the "Privacy - Location ..." keys in the Info.plist
        to display an alert message asking for user's permission.
     */
 
    // Instantiate a CLLocationCoordinate2D object with initial values
    var currentLocationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
   
    // Branch out w.r.t. locationManager's attribute authorizationStatus
    switch locationManager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
        // Location services are enabled by the user.
     
        // Set up locationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
     
        // Ask locationManager to obtain the user's current location coordinate
        if let location = locationManager.location {
            currentLocationCoordinate = location.coordinate
        }
        break
       
    case .restricted, .denied:  // Location services are not enabled by the user.
        // Return the initial value of currentLocationCoordinate as (0.0, 0.0)
        break
       
    case .notDetermined:
        // Return the initial value of currentLocationCoordinate as (0.0, 0.0)
        break
       
    default:
        break
    }
   
    // Stop updating location when not needed to save battery of the device
    locationManager.stopUpdatingLocation()
 
    return currentLocationCoordinate
}
 
