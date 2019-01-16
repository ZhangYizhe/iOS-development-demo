//
//  ExtendModel.swift
//  fengNplServer
//
//  Created by Yizhe.Zhang on 2019/1/16.
//  Copyright © 2019 cn.yygdz. All rights reserved.
//

import Foundation

class ExtendModel {
    
    //判断是否为整数
    func isPurnInt(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    
    /**
     * 将秒数转为*天*小时*分*秒的形式
     * @param time 参数：秒
     * @return
     */
    func getMMSSFromSS(time: Int) -> String {
        var dateTimes = ""
        let days: Int = time / (60 * 60 * 24)
        let hours: Int = (time % (60 * 60 * 24)) / (60 * 60)
        let minutes: Int = (time % (60 * 60)) / 60
        let seconds: Int = time % 60
        if days > 0 {
            dateTimes = "\(days)天" + "\(hours)小时" + "\(minutes)分" + "\(seconds)秒"
        } else if hours > 0 {
            dateTimes =  "\(hours)小时" + "\(minutes)分" + "\(seconds)秒"
        } else if minutes > 0 {
            dateTimes =  "\(minutes)分" + "\(seconds)秒"
        } else {
            dateTimes =  "\(seconds)秒"
        }
        return dateTimes
    }
    
    // 获取毫秒级当前时间戳 Int64
    func millisecondTimestamp() -> Int64 {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond
    }
    
    // 获取秒级时间戳
    func secondTimestamp() -> Int {
        //获取当前时间
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let nowTime = Int(timeInterval)
        return nowTime
    }
}
