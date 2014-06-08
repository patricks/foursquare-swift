//
//  FoursquareController.swift
//  FoursquareClient
//
//  Created by Patrick Steiner on 05.06.14.
//  Copyright (c) 2014 Patrick Steiner. All rights reserved.
//

import Cocoa
import CoreLocation

class FoursquareController: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var queryData: NSMutableData = NSMutableData()
    
    func query(location: CLLocation) {
        let queryURL = "https://api.foursquare.com/v2/venues/search?client_id=31BCXQMOO4BS40SB2UPQE5S3FMH4WS1WTVHVFXAWN1TAQF1U&client_secret=KIK21T4JDYPLDI5FKJQXAP4SEO1JOENPZKPW3QO5OE1ZX0EX&v=20140604&ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        let urlPath = queryURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        //println("Search Foursquare API at URL \(url)")
        
        connection.start()
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
        println("DBG: venues: \(venues)")
        
        for venue in venues {
            var currentVenue = FoursquareVenue(initDictionary: venue)
            
            println("DBG: found: \(currentVenue.name)")
        }
    }
}
