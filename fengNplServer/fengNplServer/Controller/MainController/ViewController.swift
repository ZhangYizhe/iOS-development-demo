//
//  ViewController.swift
//  fengNplServer
//
//  Created by Yizhe.Zhang on 2019/1/9.
//  Copyright © 2019 cn.yygdz. All rights reserved.
//

import Cocoa
import Swifter
import SwiftyTimer

class ViewController: NSViewController {
    
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var requestNumLabel: NSTextField!
    @IBOutlet weak var errorNumLabel: NSTextField!
    @IBOutlet weak var timeConsumingLabel: NSTextField!
    @IBOutlet weak var modelNameLabel: NSTextField!
    @IBOutlet weak var modelVersionLabel: NSTextField!
    
    @IBOutlet weak var portTextField: NSTextField!
    @IBOutlet weak var startBtn: NSButton!
    
    let server = HttpServer()
    
    let mlmodel = processmessagefilter()
    var startTime = 0
    
    var _timeConsumingNum = 0
    var timeConsumingNum: Int64 {
        set {
            _timeConsumingNum = Int(newValue)
            DispatchQueue.main.async {
                self.timeConsumingLabel.stringValue = "单次最长耗时：\(self.timeConsumingNum) ms"
            }
        }
        get {
            return Int64(_timeConsumingNum)
        }
    }
    
    
    var _requestNum = 0
    var requestNum: Int {
        set {
            _requestNum = newValue
            DispatchQueue.main.async {
                self.requestNumLabel.stringValue = "处理请求数：\(self.requestNum)"
            }
            
        }
        get {
            return _requestNum
        }
    }
    
    var _errorRequestNum = 0
    var errorRequestNum: Int {
        set {
            _errorRequestNum = newValue
            DispatchQueue.main.async {
                self.errorNumLabel.stringValue = "错误请求数：\(self.errorRequestNum)"
            }
        }
        get {
            return _errorRequestNum
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestNum = 0
        errorRequestNum = 0
        timeConsumingNum = 0
        
        modelNameLabel.stringValue = "模型名称：\( mlmodel.model.modelDescription.metadata[.description] ?? "未知")"
        modelVersionLabel.stringValue = "模型版本：\( mlmodel.model.modelDescription.metadata[.versionString] ?? "未知")"
    }
    
    @IBAction func startBtnTap(_ sender: NSButton) {
        if server.state == .running || server.state == .starting {
            endServer()
        }else{
            startServer()
        }
    }
    
    
    func startServer() {
        
        if server.state == .running || server.state == .starting {
            return
        }
        
        requestNum = 0
        errorRequestNum = 0
        timeConsumingNum = 0
        
        
        do {
            var port = 80
            if isPurnInt(string: portTextField.stringValue) {
                port = Int(portTextField.stringValue) ?? 80
            }else{
                portTextField.stringValue = "\(port)"
            }
            try server.start(in_port_t(port), forceIPv4: true)
            portTextField.isEditable = false
            startBtn.title = "停止"
            runTimer(type: 0)
            print("Server has started ( port = \(try server.port()) ). Try to connect now...")
        } catch {
            portTextField.isEditable = true
            startBtn.title = "开启"
            runTimer(type: 1)
            print("Server start error: \(error)")
        }
    }
    
    func endServer() {
        if server.state == .running || server.state == .starting {
            server.stop()
            runTimer(type: 1)
            portTextField.isEditable = true
            startBtn.title = "开启"
        }
    }
    
    var timer : Timer?
    func runTimer(type: Int) {
        if timer == nil {
            timer = Timer.new(every: 1.second) {
                //获取当前时间
                let now = Date()
                let timeInterval:TimeInterval = now.timeIntervalSince1970
                let nowTime = Int(timeInterval)
                self.timeLabel.stringValue = "已运行：\(self.getMMSSFromSS(time: nowTime - self.startTime))"
            }
        }
        

        if type == 0 {
            self.startTime = 0
            //获取当前时间
            let now = Date()
            let timeInterval:TimeInterval = now.timeIntervalSince1970
            self.startTime = Int(timeInterval)
            self.timeLabel.stringValue = "已运行：\(self.getMMSSFromSS(time: 0))"
            
            timer?.start()
        }else{
            self.startTime = 0
            timer?.invalidate()
            timer = nil
            self.timeLabel.stringValue = "尚未运行"
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
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
    
    func millisecondTimestamp() -> Int64 {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond
    }
    
}
