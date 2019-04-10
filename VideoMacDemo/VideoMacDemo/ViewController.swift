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
        
        let url1 = "http://oss-cdn.ipo3.com/ipo3/public/attachment/ad/201809/21/20/origin/20180921201620_788.mp4"
        let url2 = "https://www.apple.com/105/media/cn/iphone-xs/2018/674b340a-40f1-4156-bbea-00f386459d3c/films/design/iphone-xs-design-tpl-cn-2018_1280x720h.mp4"
        
        var url: [String] = []
        url.append(url1)
        url.append(url2)
        
         VideoWindowController.sharedViewWindowController.urls = url
        VideoWindowController.sharedViewWindowController.index = 0
        
        VideoWindowController.sharedViewWindowController.showWindow(self)
        
        VideoWindowController.sharedViewWindowController.window?.center()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

