//
//  ViewController.swift
//  video
//
//  Created by Yizhe.Zhang on 2019/1/28.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    // 实时进度刷新
    var link:CADisplayLink!

    @IBOutlet weak var playView: UIView! // 播放视图
    @IBOutlet weak var test: NSLayoutConstraint!
    var playerItem: AVPlayerItem! // 媒体资源管理对象
    var avplayer: AVPlayer! // 视频操作对象
    var playerLayer : AVPlayerLayer! // 视频显示

    @IBOutlet weak var loadProgressView: UIProgressView! // 加载缓冲进度
    @IBOutlet weak var playSliderView: UISlider! //播放滑动控件
    var playSliderFlag = false
    @IBOutlet weak var playNowTimeLabel: UILabel! // 当前播放时间
    @IBOutlet weak var playTotalTimeLabel: UILabel! // 当前播放时间
    @IBOutlet weak var horizontalExpansionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()

    }
    
    func initView() {
        // 检测连接是否存在 不存在报错
        guard let url = URL(string: "http://qiniu.yizheyun.cn/iphone1.mp4") else { fatalError("连接错误") }
        playerItem = AVPlayerItem(url: url)
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil) // 监听缓存进度
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil) // 监听是否能开始播放
        avplayer = AVPlayer(playerItem: playerItem)
        avplayer.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil) // 监听当前播放状态
        playerLayer = AVPlayerLayer(player: avplayer)
        //播放进度
        self.link = CADisplayLink(target: self, selector: #selector(update))
        self.link.add(to: RunLoop.main, forMode: RunLoop.Mode.default)

        // 监听滑动控件
        // 按下的时候
        playSliderView.addTarget(self, action: #selector(sliderTouchDown), for: UIControl.Event.touchDown)
        // 弹起的时候
        playSliderView.addTarget(self, action: #selector(sliderTouchUpOut), for: UIControl.Event.touchUpOutside)
        playSliderView.addTarget(self, action: #selector(sliderTouchUpOut), for: UIControl.Event.touchUpInside)
        playSliderView.addTarget(self, action: #selector(sliderTouchUpOut), for: UIControl.Event.touchCancel)
    }
    
    @objc func update(){

        // 当前播放到的时间
        let currentTime = CMTimeGetSeconds(self.avplayer.currentTime())
        // 总时间
        let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
        // timescale 这里表示压缩比例
        playTotalTimeLabel.text = "\(formatPlayTime(secounds: totalTime))" // 总长度
        if !playSliderFlag {
            playNowTimeLabel.text = "\(formatPlayTime(secounds: currentTime))" // 当前进度
            playSliderView.value = Float(currentTime / totalTime)
        }
        
    }
    
    
    @IBOutlet weak var playBtn: UIButton!
    @IBAction func playBtnTap(_ sender: UIButton) {
        if self.avplayer.rate == 1.0 {
            // 只有在这个状态下才能播放
            self.avplayer.pause()
        } else {
            // 只有在这个状态下才能播放
            self.avplayer.play()
        }
       
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is AVPlayerItem {
            guard let playerItem = object as? AVPlayerItem else { return }
            if keyPath == "loadedTimeRanges"{
                // 通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
                let loadedTime = avalableDurationWithplayerItem()
                let totalTime = CMTimeGetSeconds(playerItem.duration)
                let percent = loadedTime/totalTime // 计算出比例
                // 改变进度条
                loadProgressView.progress = Float(percent)
            }else if keyPath == "status"{
                // 监听状态改变
                if playerItem.status == AVPlayerItem.Status.readyToPlay{
                    setPlayBtnTitle()
                    playerLayer.frame = self.playView.bounds
                    self.playView.layer.addSublayer(playerLayer)
                    // 位置放在最底下
                    self.playView.layer.insertSublayer(playerLayer, at: 0)
                }else{
                    playBtn.setImage(UIImage(named: ""), for: .normal)
                }
            }
        } else if object is AVPlayer {
            // 监听播放状态
            if keyPath == "rate"{
                setPlayBtnTitle()
            }
        }
    }
    
    // 设置按钮文字
    func setPlayBtnTitle() {
        if avplayer.rate == 1.0 {
            playBtn.setImage(UIImage(named: "暂停"), for: .normal)
        } else {
            playBtn.setImage(UIImage(named: "播放"), for: .normal)
        }
    }
    
    // 当前进度
    func avalableDurationWithplayerItem()->TimeInterval{
        guard let loadedTimeRanges = avplayer?.currentItem?.loadedTimeRanges, let first = loadedTimeRanges.first else {fatalError()}
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    
    // 播放时间转换
    func formatPlayTime(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "0:00"
        }
        let Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    // 旋转后重新布局
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if toInterfaceOrientation == .landscapeLeft || toInterfaceOrientation == .landscapeRight {
            test.constant = self.view.frame.height
            playerLayer.frame = CGRect(origin: playerLayer.frame.origin, size: self.view.frame.size)
        } else if  toInterfaceOrientation == .portrait || toInterfaceOrientation == .portraitUpsideDown {
            test.constant = 300
            playerLayer.frame = CGRect(origin: playerLayer.frame.origin, size: CGSize(width: self.view.frame.width, height: 300))
        }
    }
    
    // 当滑动时
    
    @objc func sliderTouchDown(slider:UISlider){
        playSliderFlag = true
    }
    @objc func sliderTouchUpOut(slider:UISlider){
        if playerItem.status == AVPlayerItem.Status.readyToPlay{
            let duration = slider.value * Float(CMTimeGetSeconds(avplayer.currentItem!.duration))
            let seekTime = CMTimeMake(value: Int64(duration), timescale: 1)
            self.avplayer.seek(to: seekTime, completionHandler: { (b) in
                self.playSliderFlag = false
            })
        } else {
            self.playSliderFlag = false
        }
        
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

