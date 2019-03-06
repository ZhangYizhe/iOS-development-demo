//
//  MachineLearnModel.swift
//  MachineLearn
//
//  Created by Yizhe.Zhang on 2019/3/5.
//  Copyright © 2019 com.yizheyun. All rights reserved.
//

import Foundation
import CoreML

@available(iOS 12.0, *)
class FengMLModel {

    let documnets:String = NSHomeDirectory() + "/Documents/TextClassifier.mlmodel" //引入下载后新模型
    
    var netModel : MLModel? = nil
    var localModel = TextClassifier() // 不存在使用预编译模型

    var _modelVersion = "" // 模型版本
    var modelVersion: String {
        set {
            _modelVersion = newValue
        }
        get {
            if _modelVersion == "" {
                return "未知"
            }
            return _modelVersion
        }
    }
    var modelDescribe = "" // 模型描述
    
    let queue = DispatchQueue(label: "backgroundQueue") //qos为背景执行的子队列
    
    init() { //初始化
        installModel()
    }
    
    // 装载模型
    func installModel() {
        modelVersion = "\(localModel.model.modelDescription.metadata[.versionString]!)"
        modelDescribe = localModel.model.modelDescription.metadata[.description] as! String
        
        
        queue.async(qos: .background) {
            guard let url = URL.init(string: self.documnets) else { // 检查模型地址是否正确
                // 网络模型引入失败
                return
            }
            do{
                //创建文件管理器
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: self.documnets) {
                    // 存在即引入网络模型
                    let compiledUrl = try MLModel.compileModel(at: url) // 编译模型
                    self.netModel = try MLModel(contentsOf: compiledUrl) // 引入模型
                    
                    self.modelVersion = "\(self.netModel?.modelDescription.metadata[.versionString] ?? "")"
                    self.modelDescribe = "\(self.netModel?.modelDescription.metadata[.description] ?? "未知")"
                }
            } catch {
                // 网络模型引入失败
            }
        }
    }

    
    func AdsCheck(content: String, completion : @escaping (Bool,String) -> Void) { // 广告检查方法
        queue.async(qos: .background) {
            if self.netModel != nil {
                if let prediction = try? self.netModel!.prediction(from: TextClassifierInput(text: content)) { // 检查内容
                    let label = prediction.featureValue(for: "label")?.stringValue ?? "" // 结果转化为string标签
                    if label == "" { // 无结果
                        completion(false, "无法判断")
                        return
                    }
                    completion(true, label) // 确认标签
                    return
                }
            } else{
                let model = TextClassifier() // 不存在使用预编译模型
                if let prediction = try? model.prediction(text: content) { // 检查内容
                    let label = prediction.label // 结果转化为string标签
                    if label == "" { // 无结果
                        completion(false, "无法判断")
                        return
                    }
                    completion(true, label) // 确认标签
                    return
                }
            }
        }
    }
}
