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

class VideoViewController: NSViewController {

    var playerLayer: AVPlayerLayer?
    var player : AVQueuePlayer?
    var playerItem : AVPlayerItem? = nil
    var urls : [String] = []
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = .black
        
        initPlay()
        
    }
    
    // MARK: - 初始化播放
    func initPlay() {
        player = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.view.bounds
        guard let playerLayer = playerLayer else { fatalError("Error creating player layer") }
        self.view.layer?.addSublayer(playerLayer)
        
        if urls.count == 0 {
            return
        } else if index > urls.count - 1 {
            index = 0
        }
        
        let url = urls[index]
        let avAsset = AVURLAsset(url: URL(string: url)!, options: nil)
        let playerItem = AVPlayerItem(asset: avAsset)
        player?.removeAllItems()
        player?.insert(playerItem, after: nil)
    }
    
    // MARK: - 新播放
    func newPlay(_ _index: Int) {
        player?.pause()
        player?.seek(to: CMTime.zero)
        if urls.count == 0 {
            return
        } else if _index > urls.count - 1 {
            index = 0
        } else {
            index = _index
        }
        
        let url = urls[index]
        
        let avAsset = AVURLAsset(url: URL(string: url)!, options: nil)
        let playerItem = AVPlayerItem(asset: avAsset)
        player?.removeAllItems()
        
        player?.insert(playerItem, after: nil)
        player?.play()
    }
    
//    deinit {
//        print("视频销毁")
//    }
}
