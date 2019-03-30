//
//  LineView.swift
//  xmind
//
//  Created by Yizhe.Zhang on 2019/3/30.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Foundation
import UIKit

class LineView {
    
    // MARK:- 绘制曲线
    static func drawBezier(_ view: UIView,line pathLayer: CAShapeLayer,a: inout UILabel?, b: inout UILabel?) {
        guard let a = a, let b = b else { return }
        
        
        pathLayer.removeFromSuperlayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x:a.center.x, y:a.center.y))
        let lineX : CGFloat = a.center.x - b.center.x
        let lineY : CGFloat = a.center.y - b.center.y
        
        linePath.addCurve(to: CGPoint(x: b.center.x, y: b.center.y), controlPoint1: CGPoint(x: a.center.x + lineX / 4, y: b.center.y - lineY / 4), controlPoint2: CGPoint(x: b.center.x, y: b.center.y))
        //设定颜色，并绘制它们
        UIColor.clear.setFill()
        UIColor.black.setStroke()
        linePath.stroke()
        
        pathLayer.lineWidth = 2
        pathLayer.lineDashPhase = 10.0
        pathLayer.lineDashPattern = [10,5]
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.orange.cgColor
        pathLayer.frame = view.bounds
        pathLayer.path = linePath.cgPath
        
        view.layer.addSublayer(pathLayer)
        view.bringSubviewToFront(a)
        view.bringSubviewToFront(b)
    }
}
