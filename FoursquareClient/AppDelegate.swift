//
//  AppDelegate.swift
//  FoursquareClient
//
//  Created by Patrick Steiner on 05.06.14.
//  Copyright (c) 2014 Patrick Steiner. All rights reserved.
//

import Cocoa
import CoreLocation

class AppDelegate: NSObject, NSApplicationDelegate, LocationControllerDelegate {
                            
    @IBOutlet var window: NSWindow
    @IBOutlet var locationLabel : NSTextField
    @IBOutlet var searchButton : NSButton
    
    var currentLocation : CLLocation?
    
    var mLocationController : LocationController = LocationController()

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        mLocationController.delegate = self
        searchButton.enabled = false
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    @IBAction func searchButtonClicked(sender : AnyObject) {
        // TODO: implement foursquare search here
    }
    
    func didUpdateLocation(location : CLLocation) {
        currentLocation = location
        
        // TODO: implement KVO
        updateLocation()
    }
    
    func updateLocation() {
        if currentLocation {
            var latitude = NSString(format:"%.6f", currentLocation!.coordinate.latitude)
            var longitude = NSString(format:"%.6f", currentLocation!.coordinate.longitude)
            
            var labelText = "Current Latitude: \(latitude) Longitude: \(longitude)"
            locationLabel.stringValue = labelText
            
            searchButton.enabled = true
        }
    }
}

