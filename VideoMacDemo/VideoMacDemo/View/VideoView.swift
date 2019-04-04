//
//  VideoView.swift
//  VideoMacDemo
//
//  Created by Yizhe.Zhang on 2019/4/4.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

class VideoView: NSViewController {
    
    static let sharedVideoView = VideoView(nibName: "VideoView", bundle: Bundle.main)

    let avPlayerView = AVPlayerView()
    
    var urls : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = .black
        
        urls.append("http://oss-cdn.ipo3.com/ipo3/public/attachment/ad/201809/21/20/origin/20180921201620_788.mp4")
        
        initPlay(0)
        
    }
    
    func initPlay(_ index: Int) {
        let url = urls[index]
        let fileURL = URL(string: url)
        let avAsset = AVURLAsset(url: fileURL!, options: nil)
        
        let playerItem = AVPlayerItem(asset: avAsset)
        let videoPlayer = AVPlayer(playerItem: playerItem)
        avPlayerView.player = videoPlayer
        avPlayerView.controlsStyle = .none
        avPlayerView.frame = self.view.bounds
        self.view.addSubview(avPlayerView)
    }
    
    var isPlay : () -> Bool = {
        if sharedVideoView.avPlayerView.player?.rate == 1.0 {
            return true
        }
        return false
    }
    
    
}
