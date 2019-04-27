//
//  ViewController.swift
//  DrawingCircleDemo
//
//  Created by Yizhe.Zhang on 2019/4/27.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var canvasCircleView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addCircle(view: &canvasCircleView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func addCircle(view: inout NSView) {
        
        for layer in view.layer?.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
        
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        let progressTextField = NSTextField()
        progressTextField.isBordered = false
        progressTextField.isEditable = false
        progressTextField.stringValue = "59%"
        progressTextField.textColor = NSColor.init(hex: "#3B9AFF")
        progressTextField.font = NSFont.systemFont(ofSize: 22)
        progressTextField.frame = CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        progressTextField.sizeToFit()
        view.addSubview(progressTextField)
        let size = progressTextField.cell!.cellSize(forBounds: progressTextField.frame)
        progressTextField.frame = CGRect(x: (view.bounds.width / 2) - (size.width / 2), y: (view.bounds.width / 2) - (size.height / 2), width: size.width, height:size.height)
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        view.layer?.cornerRadius = 75

        let center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        let inset : CGFloat = 20
        let lineWidth : CGFloat = 10 // 线宽度
        let radius = (view.bounds.width - lineWidth - inset) / 2
        let progress : CGFloat = 0.8
        
        // 圆路径
        let linePath = NSBezierPath()
        linePath.appendArc(withCenter: center, radius: radius,  startAngle: 90,  endAngle: -270, clockwise: true)
        
        
        //画背景
        let lineBGLayer = CAShapeLayer.init()
        lineBGLayer.frame = view.bounds
        lineBGLayer.path = linePath.cgPath // 线条路径
        lineBGLayer.strokeColor = NSColor.init(hex: "#e6f5fe").cgColor
        lineBGLayer.fillColor = NSColor.clear.cgColor // 填充色
        lineBGLayer.lineCap = CAShapeLayerLineCap.round // 圆角
        lineBGLayer.lineWidth = lineWidth // 线条宽度
        view.layer?.addSublayer(lineBGLayer)
        
        //画进度条
        let progressLayer = CAShapeLayer.init()
        progressLayer.frame = view.bounds
        progressLayer.path = linePath.cgPath // 线条路径
        progressLayer.strokeColor = NSColor.black.cgColor
        progressLayer.fillColor = NSColor.clear.cgColor // 填充色
        progressLayer.lineCap = CAShapeLayerLineCap.round // 圆角
        progressLayer.lineWidth = lineWidth // 线条宽度
        progressLayer.strokeEnd = progress // 结束点
        view.layer?.addSublayer(progressLayer)
        
        
        //绘制左侧的渐变层（从上往下是：由黄变蓝）
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [NSColor.init(hex: "#018FF1").cgColor,
                                 NSColor.init(hex: "#1EDEFA").cgColor]

        let bgLayer = CALayer()
        bgLayer.addSublayer(gradientLayer)
        view.layer?.addSublayer(bgLayer)
        
        bgLayer.mask = progressLayer // 遮罩
        
    }
}

public extension NSBezierPath {
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                fatalError()
            }
        }
        return path
    }
}

extension NSColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            self.init()
        } else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
        }
    }
    
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> NSColor {
        return NSColor.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
}


