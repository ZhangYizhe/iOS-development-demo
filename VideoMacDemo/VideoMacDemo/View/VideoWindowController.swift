//
//  ViewWindowController.swift
//  VideoMacDemo
//
//  Created by Yizhe.Zhang on 2019/4/4.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Cocoa

class VideoWindowController: NSWindowController, NSWindowDelegate {
    
    static let sharedViewWindowController = VideoWindowController(windowNibName: "VideoWindow")

    override func windowDidLoad() {
        super.windowDidLoad()
        self.contentViewController = VideoView.sharedVideoView
        self.contentViewController?.view.addSubview(VideoControlView.sharedVideoControlView.view)
        self.contentViewController?.addChild(VideoControlView.sharedVideoControlView)
        drawSize()
        self.contentViewController?.view.window?.delegate = self
    }
    
    func windowDidResize(_ notification: Notification) {
        drawSize()
    }
    
    func drawSize() {
        VideoControlView.sharedVideoControlView.view.frame = CGRect(x: 0, y: 0, width: self.window?.frame.width ?? 100, height: 60)
        VideoView.sharedVideoView.avPlayerView.frame = VideoView.sharedVideoView.view.bounds
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        VideoControlView.sharedVideoControlView.timer?.invalidate()
        return true
    }
}
