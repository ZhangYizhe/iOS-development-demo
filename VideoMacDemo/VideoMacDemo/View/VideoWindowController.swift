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
    
    var urls : [String] = []
    var index = 0

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        
        if videoView == nil || videoControlView == nil {
            videoControlView?.removeFromParent()
            self.contentViewController = nil
            videoView = nil
            videoControlView = nil
            windowDidLoad()
        }
    }

    var videoView : VideoViewController?
    var videoControlView : VideoControlViewController?
    var VideoRightDetailView : VideoRightDetailController?
    
    override func windowDidLoad() {
        super.windowDidLoad()

        videoView = VideoViewController(nibName: "VideoView", bundle: Bundle.main)
        videoView?.urls = urls
        videoView?.index = index
        self.contentViewController = videoView
        
        videoControlView = VideoControlViewController(nibName: "VideoControlView", bundle: Bundle.main)
        
        VideoRightDetailView = VideoRightDetailController(nibName: "VideoRightDetail", bundle: Bundle.main)

        if videoView != nil || videoControlView != nil || VideoRightDetailView != nil {
            self.contentViewController?.view.addSubview(videoControlView!.view)
            videoControlView!.VideoViewDelegate = videoView
            videoControlView?.initListen()
            self.contentViewController?.addChild(videoControlView!)
            self.contentViewController?.view.addSubview(VideoRightDetailView!.view)
            VideoRightDetailView?.videoWindowDelegate = self
            self.contentViewController?.addChild(VideoRightDetailView!)
            
            drawSize()
            self.contentViewController?.view.window?.delegate = self
        }
        
    }
    
    func windowDidResize(_ notification: Notification) {
        drawSize()
    }
    
    func drawSize() {
        videoControlView?.view.frame = CGRect(x: 0, y: 0, width: self.window?.frame.width ?? 100, height: 60)
        videoControlView?.reloadLoadProgress(videoControlView?.loadProgress ?? 0.0)
        videoControlView?.reloadPlayProgress(videoControlView?.playProgress ?? 0.0)
        VideoRightDetailView?.view.frame = CGRect(x:  (self.window?.frame.width ?? 0) - 20, y: 0, width: 400, height: self.window?.frame.height ?? 0)
        guard let videoViewBounds = videoView?.view.bounds else {
            return
        }

        videoView?.playerLayer?.frame = videoViewBounds
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        videoControlView?.removeFromParent()
        VideoRightDetailView?.removeFromParent()
        self.contentViewController = nil
        videoView = nil
        videoControlView = nil
        VideoRightDetailView = nil
        return true
    }
    
//    deinit {
//        print("视频播放器销毁")
//    }
}
