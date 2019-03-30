//
//  LabelModel.swift
//  xmind
//
//  Created by Yizhe.Zhang on 2019/3/30.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Foundation
import UIKit


class NodeModel {
    // MARK:- 节点结构体
    struct node {
        var type : String // 节点属性
        var location : [Int] // 当前节点位置
        var parent : [node] // 父节点
        var childrens : [node] // 子节点
        var line : CAShapeLayer // 子到父线
        var view : UILabel? // label实例
    }
}
