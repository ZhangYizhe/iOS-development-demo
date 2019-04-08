//
//  ViewWindowController.swift
//  VideoMacDemo
//
//  Created by Yizhe.Zhang on 2019/4/4.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Cocoa

class VideoWindowController: NSWindowController, NSWindowDelegate {
    
    var url = "http://qiniu.yizheyun.cn/ipad-pro-product-tpl-cn-2018_1280x720h.mp4"
    
    static let sharedViewWindowController = VideoWindowController(windowNibName: "VideoWindow")
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

    var videoView : VideoView?
    var videoControlView : VideoControlView?
    
    override func windowDidLoad() {
        super.windowDidLoad()

        videoView = VideoView(nibName: "VideoView", bundle: Bundle.main)
        videoView?.urls.append(url)
        self.contentViewController = videoView
        
        videoControlView = VideoControlView(nibName: "VideoControlView", bundle: Bundle.main)
        
        
        if videoView != nil || videoControlView != nil {
            self.contentViewController?.view.addSubview(videoControlView!.view)
            videoControlView!.VideoViewDelegate = videoView
            videoControlView?.initListen()
            self.contentViewController?.addChild(videoControlView!)
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
        guard let videoViewBounds = videoView?.view.bounds else {
            return
        }
       videoView?.avPlayerView.frame = videoViewBounds
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        videoControlView?.removeFromParent()
        self.contentViewController = nil
        videoView = nil
        videoControlView = nil
        return true
    }
    
//    deinit {
//        print("视频播放器销毁")
//    }
}
