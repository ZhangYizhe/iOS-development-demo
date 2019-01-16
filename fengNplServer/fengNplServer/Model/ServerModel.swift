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
    
    var startTime : Int = 0 // 开始运行时间戳var
    
    var timeConsumingNum : Int64 = 0 //最新一次处理耗时
    
    // MARK: - server初始化
    func initServer() {
        server[""] = { request in
            let content = request.queryParams.first?.1 ?? ""
            if content == "" {
                let test : Dictionary<String, String>  = [
                    "status" : "",
                    "content" : content,
                    "label" : "",
                    "message" : "内容不能为空"
                ]
//
//                var curArr:[Dictionary<String, Any>] = [
//                    [
//                        "status" : "",
//                        "content" : content,
//                        "label" : "",
//                        "message" : "内容不能为空"
//                    ]
//                ]
//
//
//                let jsonData = try? JSONSerialization.data(withJSONObject: test, options: [])
                return HttpResponse.ok(.json(testd))
            }
            
            _MLModel().getLabel(content: content, completion: { (status, message) in
                if status {
                    return HttpResponse.ok(.json())
                }else {
                    return HttpResponse.ok(.json())
                }
            })
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
    
}
