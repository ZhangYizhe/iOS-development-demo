//
//  ViewController.swift
//  VideoMacDemo
//
//  Created by Yizhe.Zhang on 2019/4/4.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var videoWindowController : VideoWindowController? = VideoWindowController(windowNibName: "VideoWindow")

    @IBAction func openBtnTap(_ sender: NSButton) {
        VideoWindowController.sharedViewWindowController.showWindow(self)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

