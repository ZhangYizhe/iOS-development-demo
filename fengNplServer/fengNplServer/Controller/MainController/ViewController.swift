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
    
    let serverModel = ServerModel()
    
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
        
        modelNameLabel.stringValue = "模型名称：\(_MLModel().description())"
        modelVersionLabel.stringValue = "模型版本：\(_MLModel().versionString())"
    }
    
    @IBAction func startBtnTap(_ sender: NSButton) {
        if serverModel.server.state == .running || serverModel.server.state == .starting {
            endServer()
        }else{
            startServer()
        }
    }
    
    
    func startServer() {
        
        if serverModel.server.state == .running || serverModel.server.state == .starting {
            return
        }
        
        requestNum = 0
        errorRequestNum = 0
        timeConsumingNum = 0
        
        let port = Int(portTextField.stringValue) ?? 80
        serverModel.start(port: port) { (status, message) in
            print(message)
            if status {
                self.portTextField.isEditable = false
                self.startBtn.title = "停止"
                self.runTimer(type: 0)
            }else{
                self.portTextField.isEditable = true
                self.startBtn.title = "开启"
                self.runTimer(type: 1)
            }
        }
        
    
    }
    
    func endServer() {
        if serverModel.server.state == .running || serverModel.server.state == .starting {
            serverModel.end()
            runTimer(type: 1)
            portTextField.isEditable = true
            startBtn.title = "开启"
        }
    }
    
    var timer : Timer?
    func runTimer(type: Int) {
        if timer == nil {
            timer = Timer.new(every: 1.second) {
                self.timeLabel.stringValue = "已运行：\(ExtendModel().getMMSSFromSS(time: self.serverModel.getRunningTime()))"
                self.requestNum = self.serverModel.requestNum
                self.errorRequestNum = self.serverModel.errorRequestNum
                self.timeConsumingNum = self.serverModel.timeConsumingNum
            }
        }
        

        if type == 0 {
            self.timeLabel.stringValue = "已运行：\(ExtendModel().getMMSSFromSS(time: serverModel.getRunningTime()))"
            timer?.start()
        }else{
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
    
}
