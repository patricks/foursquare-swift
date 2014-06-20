//
//  MainViewController.swift
//  FoursquareClient
//
//  Created by Patrick Steiner on 07.06.14.
//  Copyright (c) 2014 Patrick Steiner. All rights reserved.
//

import Cocoa
import CoreLocation

class MainViewController: NSViewController, LocationControllerDelegate, FoursquareControllerDelegate {
    
    @IBOutlet var locationLabel: NSTextField
    @IBOutlet var searchButton: NSButton
    @IBOutlet var venueTableView : NSTableView
    
    var mCurrentLocation: CLLocation?
    var mFoursquareController = FoursquareController()
    var mLocationController = LocationController()
    
    var venues: FoursquareVenue[]? = nil

    override func awakeFromNib()  {
        mLocationController.delegate = self
        mFoursquareController.delegate = self
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
    
    func tableView(tableView: NSTableView!, viewForTableColumn tableColumn: NSTableColumn!, row: Int) -> NSView! {
        var cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn.identifier, owner: self) as NSTableCellView
        
        if tableColumn.identifier == "VenueColumn" {
            cellView.textField.stringValue = venues![row].name
            
            return cellView
        }
        
        return cellView
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView!) -> Int {
        return !venues ? 0 : venues!.count
    }
    
    func foundVenusForLocation(venues: FoursquareVenue[]) {
        self.venues = venues
        
        venueTableView.reloadData()
    }
}
