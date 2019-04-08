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
    
    func initListen() {
        
        // 监听是否能开始播放
        VideoViewDelegate?.playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
//        // 监听当前播放状态
        VideoViewDelegate?.avPlayerView.player?.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
        
        // 监听是否播放结束
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        // 初始音量设置
        VideoViewDelegate?.avPlayerView.player?.volume = volumeSliderView.floatValue
        
        refreshInterface()
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
    @IBOutlet weak var playSliderView: NSSlider!
    @IBAction func playSliderAction(_ sender: NSSlider) {
        guard let event = NSApplication.shared.currentEvent else { return }
        guard let player = VideoViewDelegate?.avPlayerView.player else { return }
        guard let playerItem = VideoViewDelegate?.playerItem else { return }
        switch event.type {
        case .leftMouseDown, .rightMouseDown: // 按下
            playSliderFlag = true
        case .leftMouseUp, .rightMouseUp: // 抬起
            if playerItem.status == AVPlayerItem.Status.readyToPlay{
                let duration = sender.doubleValue * CMTimeGetSeconds(player.currentItem!.duration)
                let seekTime = CMTimeMake(value: Int64(duration), timescale: 1)
                player.seek(to: seekTime, completionHandler: { [weak self] (status) in
                    guard let self = self else { return }
                    self.playSliderFlag = false
                    self.setPlayBtnStatus()
                })
            } else {
                playSliderFlag = false
                setPlayBtnStatus()
            }
        case .leftMouseDragged, .rightMouseDragged:  // 移动
            let value = sender.doubleValue
            let duration = value * Double(TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale))
            self.currentTimeTextField.stringValue = "\(formatPlayTime(secounds: TimeInterval(duration)))" // 当前进度
        default:
            break
        }
    }
    
    
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
                //                // 通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
                //                let loadedTime = avalableDurationWithplayerItem()
                //                let totalTime = CMTimeGetSeconds(playerItem.duration)
                //                let percent = loadedTime/totalTime // 计算出比例
                //                // 改变进度条
                //                loadProgressView.progress = Float(percent)
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
            self.playSliderView.doubleValue = currentTime / totalTime
            
        }
    }
    
    
    // MARK: 设置播放按钮状态
    func setPlayBtnStatus() {
        print(123)
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
        VideoViewDelegate?.playerItem?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
    }
    
}


