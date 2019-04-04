//
//  VideoControlView.swift
//  VideoMacDemo
//
//  Created by Yizhe.Zhang on 2019/4/4.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Cocoa
import SwiftyTimer

class VideoControlView: NSViewController {
    
    static let sharedVideoControlView = VideoControlView(nibName: "VideoControlView", bundle: Bundle.main)
    
    var timer : Timer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.init(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        
        timer = Timer.every(1) {
            let player = VideoView.sharedVideoView.avPlayerView.player
            print(player?.currentTime().seconds)
            
            
//            // 当前播放到的时间
//            let currentTime = CMTimeGetSeconds(self.avplayer.currentTime())
//            // 总时间
//            let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
//            // timescale 这里表示压缩比例
//            playTotalTimeLabel.text = "\(formatPlayTime(secounds: totalTime))" // 总长度
//            if !playSliderFlag {
//                playNowTimeLabel.text = "\(formatPlayTime(secounds: currentTime))" // 当前进度
//                playSliderView.value = Float(currentTime / totalTime)
//            }
            
        }
    }
    
    deinit {
        timer?.invalidate()
        print("已销毁")
    }
    
}
