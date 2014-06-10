//
//  AppDelegate.swift
//  FoursquareClient
//
//  Created by Patrick Steiner on 05.06.14.
//  Copyright (c) 2014 Patrick Steiner. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet var window: NSWindow

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        var mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        
        window.contentView.addSubview(mainViewController.view)
        mainViewController.view.frame = window.contentView.bounds
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
}

