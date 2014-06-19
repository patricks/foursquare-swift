//
//  FoursquareVenue.swift
//  FoursquareClient
//
//  Created by Patrick Steiner on 08.06.14.
//  Copyright (c) 2014 Patrick Steiner. All rights reserved.
//

import Cocoa

class FoursquareVenue: NSObject {
    
    var name = ""
    
    init(initDictionary: NSDictionary) {
        super.init()
        
        name = initDictionary["name"] as String
    }
}
