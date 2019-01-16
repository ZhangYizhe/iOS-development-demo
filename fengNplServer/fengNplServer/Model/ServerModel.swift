//
//  ServerModel.swift
//  fengNplServer
//
//  Created by Yizhe.Zhang on 2019/1/16.
//  Copyright © 2019 cn.yygdz. All rights reserved.
//

import Foundation
import Swifter
import SwiftyTimer

class ServerModel {
    
    let server = HttpServer()
    
    var startTime : Int = 0 // 开始运行时间戳
    
    var requestNum = 0 //成功请求数
    var errorRequestNum = 0 // 错误请求数
    
    var timeConsumingNum : Int64 = 0 //最新一次处理耗时
    
    // MARK: - server初始化
    func initServer() {
        server[""] = { request in
            
            let startMilli = ExtendModel().millisecondTimestamp()
            
            let content = request.queryParams.first?.1 ?? ""
            if content == "" {
                self.errorRequestNum = self.errorRequestNum + 1
                return HttpResponse.ok(.json(self.decoJson(status: 201, message: "缺少参数", content: "", lable: "")))
            }
            
            let label = _MLModel().getLabel(content: content)
            
            if label == "" {
                self.errorRequestNum = self.errorRequestNum + 1
                return HttpResponse.ok(.json(self.decoJson(status: 201, message: "不能打标签", content: content, lable: "")))
            }else {
                self.requestNum = self.requestNum + 1
                self.timeConsumingNum = ExtendModel().millisecondTimestamp() - startMilli
                return HttpResponse.ok(.json(self.decoJson(status: 200, message: "成功", content: content, lable: label)))
            }
        }
    }
    
    // MARK: - 开启连接
    func start(port: Int, completion : @escaping (Bool,String) -> Void) {
        
        end() //若存在连接则关闭
        
        do {
            if 0 > port || port > 65535 {
                //端口号不在区间内
                completion(false,"端口号不正确")
                return
            }
            initServer()
            try server.start(in_port_t(port), forceIPv4: true)
            startTime = ExtendModel().secondTimestamp()
            completion(true,"建立连接成功，端口号为：\(try server.port())")
        } catch {
            end()
            completion(false,"连接建立失败，\(error)")
        }
    }
    
    // MARK: - 关闭连接
    func end()  {
        server.stop()
        startTime = 0 //开始时间清空
        requestNum = 0 //成功请求数清空
        errorRequestNum = 0 // 错误请求数清空
        timeConsumingNum = 0 //最新一次处理耗时清空
    }
    
    // MARK: - 获取已运行时长(秒)
    func getRunningTime() -> Int {
        let now = ExtendModel().secondTimestamp()
        if startTime == 0 || startTime > now {
            startTime = 0
            return 0
        }else{
            return now - startTime
        }
    }
    
    // MARK: - json
    func decoJson(status: Int, message: String, content: String, lable: String) -> AnyObject {
        let result:Dictionary<String,Any> = [
            "status" : status,
            "message" : message,
            "content" : content,
            "label" : lable
        ]
        
        return result as AnyObject
    }
}
