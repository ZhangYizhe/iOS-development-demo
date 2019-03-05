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
class MachineLearnModel {
    // http://qiniu.yizheyun.cn/TextClassifier.mlmodel
    
    let documnets:String = NSHomeDirectory() + "/Documents/TextClassifier.mlmodel"

    func test() {
        
        guard let url = URL.init(string: documnets) else {
            return
        }
        do{
            let compiledUrl = try MLModel.compileModel(at: url)
            let model = try MLModel(contentsOf: compiledUrl)

            
            
            if let prediction = try? model.prediction(from: TextClassifierInput(text: "zxzxcvcv")) {
                print("运算后标签为\(prediction.featureValue(for: "label"))")
            }
        } catch {
            print("模型错误！")
        }
        
        
        
    }
    
//    func move() {
//        // find the app support directory
//        let fileManager = FileManager.default
//        let appSupportDirectory = try! fileManager.url(for: .applicationSupportDirectory,
//                                                       in: .userDomainMask, appropriateFor: compiledUrl, create: true)
//        // create a permanent URL in the app support directory
//        let permanentUrl = appSupportDirectory.appendingPathComponent(compiledUrl.lastPathComponent)
//        do {
//            // if the file exists, replace it. Otherwise, copy the file to the destination.
//            if fileManager.fileExists(atPath: permanentUrl.absoluteString) {
//                _ = try fileManager.replaceItemAt(permanentUrl, withItemAt: compiledUrl)
//            } else {
//                try fileManager.copyItem(at: compiledUrl, to: permanentUrl)
//            }
//        } catch {
//            print("Error during copy: \(error.localizedDescription)")
//        }
//
//    }
    
}
