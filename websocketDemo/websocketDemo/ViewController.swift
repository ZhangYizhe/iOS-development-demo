//
//  ViewController.swift
//  websocketDemo
//
//  Created by Yizhe.Zhang on 2018/12/18.
//  Copyright © 2018 cn.yizheyun. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController {

    @IBOutlet weak var logTextView: UITextView!
    
    var socket: WebSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let NotifyChatMsgRecv = NSNotification.Name(rawValue:"notifyChatMsgRecv")
        NotificationCenter.default.addObserver(self,selector:#selector(didMsgRecv(notification:)),name: NotifyChatMsgRecv, object: nil)
    }
    
    //子页面的反馈通知响应方法
    //通知处理函数
    @objc func didMsgRecv(notification:NSNotification){
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        
        let new =  notification.object as! String
        
        logTextView.text = logTextView.text + "\n" + dformatter.string(from: Date()) + " : " + new
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}

