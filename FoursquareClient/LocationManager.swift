//
//  LocationManager.swift
//  FoursquareClient
//
//  Created by Patrick Steiner on 05.06.14.
//  Copyright (c) 2014 Patrick Steiner. All rights reserved.
//

import Cocoa
import CoreLocation

protocol LocationControllerDelegate {
    func didUpdateLocation(location : CLLocation)
}

class LocationController: NSObject, CLLocationManagerDelegate {
    
    var coreLocation = CLLocationManager()
    var delegate: LocationControllerDelegate?
    
    init() {
        super.init()
        setupCoreLocation()
    }
    
    func coreLocationAvailable() -> Bool {
        if (CLLocationManager.locationServicesEnabled()) {
            return true
        } else {
            println("ERROR: Location is NOT available")
            return false
        }
    }
    
    func setupCoreLocation() {
        if (coreLocationAvailable()) {
            coreLocation.delegate = self
            coreLocation.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didUpdateLocations locations: AnyObject[]!) {
            for location in locations as CLLocation[] {
                delegate?.didUpdateLocation(location)
            }
    }
    
    func locationManager(manager: CLLocationManager!,
        didFailWithError error: NSError!) {
            println("ERROR: Failed to get location");
    }
}
