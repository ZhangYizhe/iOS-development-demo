//
//  MediaModel.swift
//  video
//
//  Created by Yizhe.Zhang on 2019/1/30.
//  Copyright © 2019 com.yizheyun. All rights reserved.
//

import Foundation
import AVFoundation

class MediaModel {
    
    // 设置具体音量控制
    func setVolume(_avPlayer: AVPlayer, _volume: Float) -> AVPlayer {
        if _volume > 1.0 {
            _avPlayer.volume = 1.0
        } else if _volume < 0.0 {
            _avPlayer.volume = 0.0
        } else {
            _avPlayer.volume = _volume
        }
        return _avPlayer
    }
    
    // 调大音量
    
    // 设置静音
    func setMuted(_avPlayer: AVPlayer, _isMuted: Bool) -> AVPlayer {
        _avPlayer.isMuted = _isMuted
        return _avPlayer
    }
}
