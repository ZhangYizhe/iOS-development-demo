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

class VideoControlViewController: NSViewController {
    
    var VideoViewDelegate : VideoViewController?
    
    @IBOutlet weak var currentTimeTextField: NSTextField!
    @IBOutlet weak var totalTimeTextField: NSTextField!
    
    var timer : Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.init(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        
    }
    
    func initListen() {
        initProgress()

        // 监听当前播放状态
        VideoViewDelegate?.player?.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
        
        // 监听是否播放结束
        NotificationCenter.default.addObserver(self, selector: #selector(self.playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        // 初始音量设置
        VideoViewDelegate?.player?.volume = volumeSliderView.floatValue
        
        //界面定时刷新函数
        refreshInterface()

    }
    
    // MARK:- 播放按钮
    @IBOutlet weak var playPauseBtn: NSButton!
    @IBAction func playPauseBtnTap(_ sender: NSButton) {
        if VideoViewDelegate?.player?.rate == 1.0 {
            VideoViewDelegate?.player?.pause()
        } else {
            VideoViewDelegate?.player?.play()
        }
    }
    
    // MARK:- 音量条控制
    @IBOutlet weak var volumeSliderView: NSSlider!
    @IBAction func volumeSliderAction(_ sender: NSSlider) {
        guard let player = VideoViewDelegate?.player else { return }
        player.volume = sender.floatValue
    }

    // MARK:- 界面定时刷新函数
    func refreshInterface() {
        timer?.invalidate()
        timer = Timer.every(0.1) { [weak self] _ in
            guard let self = self else { return }
            self.timeDisplay()
            // 监听缓存进度 ; 监听是否能开始播放
            self.currentItemListen()
        }
    }
    
    // MARK:- 播放时间显示
    func timeDisplay() {
        guard let player = VideoViewDelegate?.player else { return }
        guard let playerItem = VideoViewDelegate?.player?.currentItem else { return }
        
        if playerItem.status == AVPlayerItem.Status.readyToPlay{
            // 当前播放到的时间
            let currentTime = player.currentTime().seconds
            // 总时间
            let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
            // timescale 这里表示压缩比例
            totalTimeTextField.stringValue = "\(formatPlayTime(secounds: totalTime))" // 总长度
            currentTimeTextField.stringValue = "\(formatPlayTime(secounds: currentTime))" // 当前进度
            if !playSliderViewMoveTimerFlag {
                playProgress = CGFloat(currentTime / totalTime)
            }
        }
    }
    
    // MARK: 秒转时间
    func formatPlayTime(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "00:00"
        }
        let Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    // 当前进度
    func avalableDurationWithplayerItem()->TimeInterval{
        guard let player = VideoViewDelegate?.player else { return 0.0 }
        guard let loadedTimeRanges = player.currentItem?.loadedTimeRanges, let first = loadedTimeRanges.first else {fatalError()}
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    
    

    
    // MARK: 下一曲按钮
    @IBAction func nextVideoBtnTap(_ sender: NSButton) {
        playAppointItem(index: nil)
    }
    
    // MARK: 播放完毕
    @objc func playToEndTime(){
        playAppointItem(index: nil)
    }
    
    // MARK: 切换播放
    func playAppointItem(index: Int?) {
        var _index = 0
        if index == nil {
            _index = (VideoViewDelegate?.index ?? 0) + 1
        }
        VideoViewDelegate?.newPlay(_index)
        currentItemListenFlag = false
        
    }
    
    var currentItemListenFlag = false
    func currentItemListen() {
        if currentItemListenFlag {
            return
        }
        guard let playerItem = VideoViewDelegate?.player?.currentItem else { return }
        if playerItem.status == AVPlayerItem.Status.readyToPlay {
            // 监听缓存进度
            VideoViewDelegate?.player?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
            // 监听是否能开始播放
            VideoViewDelegate?.player?.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            currentItemListenFlag = true
        }
        
    }
    
    
    // MARK:- 播放进度控制 初始化
    // MARK: 加载进度条
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
    
    // MARK: 播放进度条
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
    
    // MARK: 进度条钮
    var playSliderView = DownUpNSView()
    var playSliderViewMoveTimer : Timer? = nil
    var playSliderViewMoveTimerFlag = false // 进度条钮移动标记
    var mouseInitialPositionX : CGFloat = 0.0 // 鼠标移动初始位置
    var playSliderViewInitialPositionX : CGFloat = 0.0 // 进度条钮初始位置
    
    
    // MARK: - 播放状态监控
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
    
    // MARK: 设置播放按钮状态
    func setPlayBtnStatus() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            if self.VideoViewDelegate?.player?.rate == 1.0 {
                self.playPauseBtn.image = NSImage(named: "Pause")
            } else {
                self.playPauseBtn.image = NSImage(named: "Play")
            }
        }
    }
    
    // MARK: - 销毁控制器
    deinit {
        VideoViewDelegate?.player?.removeObserver(self, forKeyPath: "rate")
        VideoViewDelegate?.player?.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        VideoViewDelegate?.player?.currentItem?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
//        print("控制器销毁")
    }
}

extension VideoControlViewController {
    func initProgress() {
        addLoadProgress()
        addPlayProgress()
    }
    
    // MARK:- 视频缓存加载进度
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
    
    // MARK: 调整布局
    func reloadLoadProgress(_ newValue: CGFloat) {
        NSAnimationContext.runAnimationGroup({ (_) in
            NSAnimationContext.current.duration = 0.25
            loadProgressView.frame = CGRect(x: 10, y: self.view.bounds.height - 15, width: self.view.bounds.width - 20, height: 5)
            loadProgressSonView.animator().frame = CGRect(x: 0, y: 0, width: newValue * loadProgressView.bounds.width, height: loadProgressView.bounds.height)
        })
    }
    
    // MARK:- 视频播放进度
    func addPlayProgress() {
        playProgressView.removeFromSuperview()
        playProgressView.wantsLayer = true
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
    
    // MARK: 调整布局
    func reloadPlayProgress(_ newValue: CGFloat) {
        if !playSliderViewMoveTimerFlag {
            NSAnimationContext.runAnimationGroup({ (_) in
                NSAnimationContext.current.duration = 0.25
                playProgressView.frame = CGRect(x: 10, y: self.view.bounds.height - 15, width: self.view.bounds.width - 20, height: 5)
                playProgressSonView.animator().frame = CGRect(x: 0, y: 0, width: newValue * playProgressView.bounds.width, height: playProgressView.bounds.height)

                // 调整
                playSliderView.animator().frame = CGRect(x: newValue * (self.view.frame.width - 20), y: playSliderView.frame.minY, width: 20, height: 20)
            })
        }
    }
    
    // MARK:- 视频播放进度控制按钮
    func addplaySliderView() {
        playSliderView.removeFromSuperview()
        playSliderView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        playSliderView.wantsLayer = true
        playSliderView.layer?.backgroundColor = NSColor.white.cgColor
        playSliderView.layer?.cornerRadius = 10
        self.view.addSubview(playSliderView)
        playSliderView.frame = CGRect(x: 0, y: self.view.bounds.height - 13.5, width: 20, height: 20)
        playSliderView.mouseBack = { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .down:
                self.playSliderViewMove(true)
            case .up:
                self.playSliderViewMove(false)
            }
        }
        playSliderView.resignFirstResponder()
    }
    
    // MARK: 视频播放进度控制按钮 移动
    func playSliderViewMove(_ down: Bool) {
        
        if down {
            playSliderViewMoveTimerFlag = down
            playSliderViewInitialPositionX = playSliderView.frame.minX
            mouseInitialPositionX = NSEvent.mouseLocation.x
            playSliderViewMoveTimer = Timer.every(0.01) { [weak self] in
                guard let self = self else { return }
                var playSliderViewNowX = NSEvent.mouseLocation.x - self.mouseInitialPositionX + self.playSliderViewInitialPositionX
                if playSliderViewNowX < 0 {
                    playSliderViewNowX = 0
                } else if playSliderViewNowX > self.playProgressView.frame.width {
                    playSliderViewNowX = self.playProgressView.frame.width
                }
                self.playProgressSonView.frame = CGRect(x: 0, y: 0, width: playSliderViewNowX, height: self.playProgressView.bounds.height)
                self.playSliderView.frame = CGRect(x: playSliderViewNowX, y: self.playSliderView.frame.minY, width: 20, height: 20)
                
                
            }
        } else {
            playSliderViewMoveTimer?.invalidate()
            guard let player = VideoViewDelegate?.player else { return }
            let test = Double(playProgressSonView.bounds.width / playProgressView.bounds.width)
            let duration = test * Double(player.currentItem!.duration.value)
            let seekTime = CMTimeMake(value: Int64(duration), timescale: player.currentItem!.duration.timescale)
            player.seek(to: seekTime, completionHandler: { [weak self] (status) in
                guard let self = self else {return}
                self.playSliderViewMoveTimerFlag = false
            })
            
        }
    }
    
    // MARK:-  进度条钮 特殊类
    class DownUpNSView: NSView {
        enum mouseEvent {
            case down
            case up
        }
        var mouseBack = {(_ status : mouseEvent) in }
        override func mouseDown(with event: NSEvent) {
            mouseBack(.down)
        }
        
        override func mouseUp(with event: NSEvent) {
            mouseBack(.up)
        }
        
    }
}


