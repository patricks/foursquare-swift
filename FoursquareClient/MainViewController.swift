//
//  MainViewController.swift
//  FoursquareClient
//
//  Created by Patrick Steiner on 07.06.14.
//  Copyright (c) 2014 Patrick Steiner. All rights reserved.
//

import Cocoa
import CoreLocation

class MainViewController: NSViewController, LocationControllerDelegate {
    
    @IBOutlet var locationLabel: NSTextField
    @IBOutlet var searchButton: NSButton
    
    var mCurrentLocation: CLLocation?
    var mFoursquareController = FoursquareController()
    var mLocationController = LocationController()

    override func awakeFromNib()  {
        mLocationController.delegate = self
        searchButton.enabled = false
    }
    
    @IBAction func searchButtonClicked(sender: AnyObject) {
        mFoursquareController.query(mCurrentLocation!)
    }
    
    func didUpdateLocation(location: CLLocation) {
        mCurrentLocation = location
        
        // TODO: implement KVO
        updateLocation()
    }
    
    func updateLocation() {
        if mCurrentLocation {
            var latitude = NSString(format:"%.6f", mCurrentLocation!.coordinate.latitude)
            var longitude = NSString(format:"%.6f", mCurrentLocation!.coordinate.longitude)
            
            var labelText = "Current Latitude: \(latitude) Longitude: \(longitude)"
            locationLabel.stringValue = labelText
            
            searchButton.enabled = true
        }
    }
}
