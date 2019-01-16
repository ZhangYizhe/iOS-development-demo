//
//  MLModel.swift
//  fengNplServer
//
//  Created by Yizhe.Zhang on 2019/1/16.
//  Copyright © 2019 cn.yygdz. All rights reserved.
//

import Foundation

class _MLModel {
    
    let mlmodel = processmessagefilter()
    
    func description() -> String {
        return "\(mlmodel.model.modelDescription.metadata[.description] ?? "未知")"
    }
    
    func versionString() -> String {
        return "\(mlmodel.model.modelDescription.metadata[.versionString] ?? "未知")"
    }
    
    func getLabel(content: String) -> String {
        guard let output = try? mlmodel.prediction(text: content) else {
            return ""
        }
        return output.label
    }
    
}
