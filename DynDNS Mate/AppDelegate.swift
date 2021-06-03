//
//  AppDelegate.swift
//  DynDNS Manager
//
//  Created by Prof. Dr. Luigi on 29.05.21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationShouldTerminateAfterLastWindowClosed (_
        theApplication: NSApplication) -> Bool {
        return true
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        UserDefaults.standard.removeObject(forKey: "HostnameTools")
        UserDefaults.standard.removeObject(forKey: "Admin")
        UserDefaults.standard.removeObject(forKey: "Launchpath")
        UserDefaults.standard.removeObject(forKey: "AppName")
        // Insert code here to tear down your application
    }


}

