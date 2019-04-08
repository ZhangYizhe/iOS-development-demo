//
//  VideoControlView.swift
//  VideoMacDemo
//
//  Created by Yizhe.Zhang on 2019/4/4.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Cocoa
import SwiftyTimer
import AVKit
import AVFoundation

class VideoControlView: NSViewController {
    
    var VideoViewDelegate : VideoView?
    
    @IBOutlet weak var currentTimeTextField: NSTextField!
    @IBOutlet weak var totalTimeTextField: NSTextField!
    
    var timer : Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.init(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
    
    func initListen() {
        initProgress { [weak self] in
            guard let self = self else { return }
            // 监听缓存进度
            self.VideoViewDelegate?.playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
            // 监听是否能开始播放
            self.VideoViewDelegate?.playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            // 监听当前播放状态
            self.VideoViewDelegate?.avPlayerView.player?.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
            
            // 监听是否播放结束
            NotificationCenter.default.addObserver(self, selector: #selector(self.playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            
            // 初始音量设置
            self.VideoViewDelegate?.avPlayerView.player?.volume = self.volumeSliderView.floatValue
            
            self.refreshInterface()
        }
        

    }
    
    // MARK:- 播放按钮
    @IBOutlet weak var playPauseBtn: NSButton!
    @IBAction func playPauseBtnTap(_ sender: NSButton) {
        if VideoViewDelegate?.avPlayerView.player?.rate == 1.0 {
            VideoViewDelegate?.avPlayerView.player?.pause()
        } else {
            VideoViewDelegate?.avPlayerView.player?.play()
        }
    }
    
    // MARK:- 音量条控制
    @IBOutlet weak var volumeSliderView: NSSlider!
    @IBAction func volumeSliderAction(_ sender: NSSlider) {
        guard let player = VideoViewDelegate?.avPlayerView.player else { return }
        player.volume = sender.floatValue
    }
    
    // MARK:- 进度条控制
    var playSliderFlag = false // 是否正在活动
//    @IBOutlet weak var loadProgressView: NSProgressIndicator! // 缓存进度
//    @IBOutlet weak var playSliderView: NSSlider!
//    @IBAction func playSliderAction(_ sender: NSSlider) {
//        guard let event = NSApplication.shared.currentEvent else { return }
//        guard let player = VideoViewDelegate?.avPlayerView.player else { return }
//        guard let playerItem = VideoViewDelegate?.playerItem else { return }
//        switch event.type {
//        case .leftMouseDown, .rightMouseDown: // 按下
//            playSliderFlag = true
//        case .leftMouseUp, .rightMouseUp: // 抬起
//            if playerItem.status == AVPlayerItem.Status.readyToPlay{
//                let duration = sender.doubleValue * CMTimeGetSeconds(player.currentItem!.duration)
//                let seekTime = CMTimeMake(value: Int64(duration), timescale: 1)
//                player.seek(to: seekTime, completionHandler: { [weak self] (status) in
//                    guard let self = self else { return }
//                    self.playSliderFlag = false
//                    self.setPlayBtnStatus()
//                })
//            } else {
//                playSliderFlag = false
//                setPlayBtnStatus()
//            }
//        case .leftMouseDragged, .rightMouseDragged:  // 移动
//            let value = sender.doubleValue
//            let duration = value * Double(TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale))
//            self.currentTimeTextField.stringValue = "\(formatPlayTime(secounds: TimeInterval(duration)))" // 当前进度
//        default:
//            break
//        }
//    }
    
    
    // MARK:- 播放时间转换
    func formatPlayTime(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "00:00"
        }
        let Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    // MARK: - 监控
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is AVPlayerItem {
            guard let playerItem = object as? AVPlayerItem else { return }
            if keyPath == "loadedTimeRanges"{
                // 通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
                let loadedTime = avalableDurationWithplayerItem()
                let totalTime = CMTimeGetSeconds(playerItem.duration)
                let percent = loadedTime/totalTime // 计算出比例
                // 改变进度条
                loadProgress = CGFloat(percent)
            }else if keyPath == "status"{
                // 监听状态改变
                if playerItem.status == AVPlayerItem.Status.readyToPlay{
                    playPauseBtn.isEnabled = true
                    setPlayBtnStatus()
                }else{
                    playPauseBtn.isEnabled = false
                }
            }
        } else if object is AVPlayer {
            // 监听播放状态
            if keyPath == "rate" {
                setPlayBtnStatus()
            }
        }
    }
    
    // MARK:- 界面定时刷新函数
    func refreshInterface() {
        timer?.invalidate()
        timer = Timer.every(0.1) { [weak self] _ in
            guard let self = self else { return }
            self.timeDisplay()
        }
    }
    
    func timeDisplay() {
        guard let player = VideoViewDelegate?.avPlayerView.player else { return }
        guard let playerItem = VideoViewDelegate?.playerItem else { return }
        
        
        // 当前播放到的时间
        let currentTime = player.currentTime().seconds
        // 总时间
        let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
        // timescale 这里表示压缩比例
        self.totalTimeTextField.stringValue = "\(self.formatPlayTime(secounds: totalTime))" // 总长度
        if !self.playSliderFlag {
            self.currentTimeTextField.stringValue = "\(self.formatPlayTime(secounds: currentTime))" // 当前进度
            self.playProgress = CGFloat(currentTime / totalTime)
        }
    }
    
    // 当前进度
    func avalableDurationWithplayerItem()->TimeInterval{
        guard let player = VideoViewDelegate?.avPlayerView.player else { return 0.0 }
        guard let loadedTimeRanges = player.currentItem?.loadedTimeRanges, let first = loadedTimeRanges.first else {fatalError()}
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    
    
    // MARK: 设置播放按钮状态
    func setPlayBtnStatus() {
        DispatchQueue.main.async {
            if self.VideoViewDelegate?.avPlayerView.player?.rate == 1.0 {
                self.playPauseBtn.image = NSImage(named: "Pause")
            } else {
                self.playPauseBtn.image = NSImage(named: "Play")
            }
        }
    }
    
    // MARK: 播放完毕
    @objc func playToEndTime(){
        guard let player = VideoViewDelegate?.avPlayerView.player else { return }
        guard let playerItem = VideoViewDelegate?.playerItem else { return }
        
        if playerItem.status == AVPlayerItem.Status.readyToPlay {
            let seekTime = CMTimeMake(value: Int64(0), timescale: 1)
            player.seek(to: seekTime)
        }
        
        timeDisplay()
    }
    
    
    deinit {
        VideoViewDelegate?.avPlayerView.player?.removeObserver(self, forKeyPath: "rate")
        VideoViewDelegate?.playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        VideoViewDelegate?.playerItem?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
    }
    
    // 加载进度条
    let loadProgressView = NSView()
    let loadProgressSonView = NSView()
    var _loadProgress: CGFloat = 0.0
    var loadProgress: CGFloat {
        get {
            return _loadProgress
        }
        set {
            _loadProgress = newValue
            reloadLoadProgress(newValue)
        }
    }
    
    // 播放进度条
    var playProgressView = NSView()
    var playProgressSonView = NSView()
    var _playProgress: CGFloat = 0.0
    var playProgress: CGFloat {
        get {
            return _playProgress
        }
        set {
            _playProgress = newValue
            reloadPlayProgress(newValue)
        }
    }
    
    var playSliderView = NSView()
    var test = false
}

extension VideoControlView {
    func initProgress(completion: @escaping () -> ()) {
        addLoadProgress()
        addPlayProgress()
        Timer.after(1) {
            completion()
        }
    }
    
    
    func addLoadProgress() {
        loadProgressView.removeFromSuperview()
        loadProgressView.wantsLayer = true
        loadProgressView.layer?.backgroundColor = NSColor.gray.cgColor
        loadProgressView.frame = CGRect(x: 10, y: self.view.bounds.height - 15, width: self.view.bounds.width - 20, height: 5)
        loadProgressView.layer?.cornerRadius = 2
        self.view.addSubview(loadProgressView)
        
        loadProgressSonView.wantsLayer = true
        loadProgressSonView.layer?.backgroundColor = NSColor.lightGray.cgColor
        loadProgressSonView.frame = CGRect(x: 0, y: 0, width: loadProgress * loadProgressView.bounds.width, height: loadProgressView.bounds.height)
        loadProgressView.addSubview(loadProgressSonView)
    }
    
    func reloadLoadProgress(_ newValue: CGFloat) {
        NSAnimationContext.runAnimationGroup({ (_) in
            NSAnimationContext.current.duration = 0.25
            loadProgressView.frame = CGRect(x: 10, y: self.view.bounds.height - 15, width: self.view.bounds.width - 20, height: 5)
            loadProgressSonView.animator().frame = CGRect(x: 0, y: 0, width: newValue * loadProgressView.bounds.width, height: loadProgressView.bounds.height)
        })
    }
    
    func addPlayProgress() {
        playProgressView.removeFromSuperview()
        playProgressView.wantsLayer = true
        playProgressView.layer?.masksToBounds = false
        playProgressView.layer?.backgroundColor = NSColor.clear.cgColor
        playProgressView.frame = CGRect(x: 10, y: self.view.bounds.height - 15, width: self.view.bounds.width - 20, height: 5)
        playProgressView.layer?.cornerRadius = 2
        self.view.addSubview(playProgressView)
        
        playProgressSonView.wantsLayer = true
        playProgressSonView.layer?.backgroundColor = NSColor.red.cgColor
        playProgressSonView.frame = CGRect(x: 0, y: 0, width: playProgress * playProgressView.bounds.width, height: playProgressView.bounds.height)
        playProgressView.addSubview(playProgressSonView)
        
        addplaySliderView()
    }
    
    func reloadPlayProgress(_ newValue: CGFloat) {
        NSAnimationContext.runAnimationGroup({ (_) in
            NSAnimationContext.current.duration = 0.25
            playProgressView.frame = CGRect(x: 10, y: self.view.bounds.height - 15, width: self.view.bounds.width - 20, height: 5)
            playProgressSonView.animator().frame = CGRect(x: 0, y: 0, width: newValue * playProgressView.bounds.width, height: playProgressView.bounds.height)
            
//            playSliderView.animator().frame = CGRect(x: -10 + newValue * playProgressView.bounds.width, y: -8.5, width: 20, height: 20)
        })
        
//        reloadPlaySliderView(newValue)
    }
    
    func addplaySliderView() {
        playSliderView.removeFromSuperview()
        playSliderView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        playSliderView.wantsLayer = true
        playSliderView.layer?.backgroundColor = NSColor.red.cgColor
        playSliderView.layer?.cornerRadius = 10
        playProgressView.addSubview(playSliderView)
        playSliderView.frame = CGRect(x: -10, y: -8.5, width: 20, height: 20)
        
        
        playSliderView.addTrackingRect(playSliderView.frame, owner: playSliderView, userData: nil, assumeInside: false)

        var trackingOptions: NSTrackingArea.Options = [.activeInActiveApp, .mouseMoved]
        // note: NSTrackingActiveAlways flags turns off the cursor updating feature
        var myTrackingArea = NSTrackingArea(rect: playSliderView.bounds /* in our case track the entire view */, options: trackingOptions, owner: playSliderView, userInfo: nil)
        playSliderView.addTrackingArea(myTrackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        print(123)
    }
    
    override func mouseExited(with event: NSEvent) {
        print(456)
    }
    
    
    override func mouseDown(with event: NSEvent) {
        test = true
    }
    
    override func mouseMoved(with event: NSEvent) {
//        print(event.deltaX)
        playSliderView.frame = CGRect(x: event.locationInWindow.x - 20, y: -8.5, width: 20, height: 20)
    }
}
