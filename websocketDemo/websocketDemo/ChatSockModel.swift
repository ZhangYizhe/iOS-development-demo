//
//  ChatSockModel.swift
//  websocketDemo
//
//  Created by Yizhe.Zhang on 2018/12/18.
//  Copyright © 2018 cn.yizheyun. All rights reserved.
//

import Starscream
import SwiftyTimer

extension AppDelegate: WebSocketDelegate {

    func websocketDidConnect(socket: WebSocketClient) {
        printLogMessage(text: "已连接")
        Timer.every(5.seconds) {
            socket.write(string: "0")
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print(error.debugDescription)
        printLogMessage(text: "断开连接")
        Timer.after(5) {
            socket.connect()
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if text == "1" {
            return
        }
        
        printLogMessage(text: text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    func printLogMessage(text : String){
        let NotifyChatMsgRecv = NSNotification.Name(rawValue:"notifyChatMsgRecv")
        NotificationCenter.default.post(name:NotifyChatMsgRecv, object: text)
    }
    
}
