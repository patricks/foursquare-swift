//
//  FoursquareController.swift
//  FoursquareClient
//
//  Created by Patrick Steiner on 05.06.14.
//  Copyright (c) 2014 Patrick Steiner. All rights reserved.
//

import Cocoa
import CoreLocation

protocol FoursquareControllerDelegate {
    func foundVenusForLocation(venues: FoursquareVenue[])
}

class FoursquareController: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var queryData: NSMutableData = NSMutableData()
    var delegate: FoursquareControllerDelegate?
    
    var clientID = ""
    var clientSecret = ""
    
    init()  {
        super.init()
        readFoursquareSettings()
    }
    
    func query(location: CLLocation) {
        
        if clientID.isEmpty && clientSecret.isEmpty {
            println("ERROR: client_id and/or client_secret is missing")
            return
        }
        
        let queryURL = "https://api.foursquare.com/v2/venues/search?client_id=\(clientID)&client_secret=\(clientSecret)&v=20140604&ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        let urlPath = queryURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        //println("DBG: Search Foursquare API at URL \(url)")
        
        connection.start()
    }
    
    func readFoursquareSettings() {
        let path = NSBundle.mainBundle().pathForResource("Foursquare", ofType: "plist")
        let fileManager = NSFileManager.defaultManager()
        
        if (fileManager.fileExistsAtPath(path)) {
            let plistDict = NSDictionary(contentsOfFile: path)
            
            if plistDict.count > 0 {
                clientID = plistDict["clientID"] as String
                clientSecret = plistDict["clientSecret"] as String
            } else {
                println("ERROR: Can not read plist file")
            }
        } else {
            println("ERROR: Foursquare.plist file not found")
        }
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        queryData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        queryData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(queryData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        if jsonResult.count > 0 {
            //println("DBG: json: \(jsonResult)")
            
            let metaResult: NSDictionary = jsonResult["meta"] as NSDictionary
            
            let result = metaResult["code"] as Int
            
            if result == 200 {
                let responseResult: NSDictionary = jsonResult["response"] as NSDictionary
                let responseVenues: NSDictionary[] = responseResult["venues"] as NSDictionary[]
                
                printVenues(responseVenues)
            }
        }
    }
    
    func printVenues(venues: NSDictionary[]) {
        //println("DBG: venues: \(venues)")
        
        var currentVenues = FoursquareVenue[]()
        
        for venue in venues {
            var currentVenue = FoursquareVenue(initDictionary: venue)
            
            currentVenues.append(currentVenue)
            
            //println("DBG: found: \(currentVenue.name)")
        }
        
        delegate?.foundVenusForLocation(currentVenues)
    }
}
