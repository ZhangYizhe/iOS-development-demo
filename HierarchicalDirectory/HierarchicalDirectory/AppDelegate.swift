//
//  AppDelegate.swift
//  HierarchicalDirectory
//
//  Created by 张艺哲 on 2019/6/5.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainWindow : MainWindow? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        mainWindow = MainWindow(windowNibName: "MainWindow")
        mainWindow?.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

