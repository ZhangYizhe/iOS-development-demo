//
//  ViewController.swift
//  xmind
//
//  Created by Yizhe.Zhang on 2019/3/28.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var testView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initView()
    }

    let scrollView = UIScrollView()
    func initView() {
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
//        scrollView.contentOffset = CGPoint(x: 500 - self.view.frame.width/2, y: 500 - self.view.frame.height/2)
//        self.view.addSubview(scrollView)
        
        createBlock()
    }
    
    let label = SpecialLabel()
    let label2 = SpecialLabel()
    func createBlock() {
        
        label.isUserInteractionEnabled = true
        label.textInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        label.backgroundColor = .red
        label.text = "标签1"
        label.frame = CGRect(x: 300, y: 300, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        self.view.addSubview(label)
        // 触摸
        let touch = UIPanGestureRecognizer(target: self, action: #selector(panLabelDid(_:)))
        touch.maximumNumberOfTouches = 1
        label.addGestureRecognizer(touch)
        // 移动通知
        label.addObserver(self, forKeyPath: "center", options: .new, context: UnsafeMutableRawPointer.init(bitPattern: "label1".hashValue))
        
        label2.isUserInteractionEnabled = true
        label2.textInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        label2.backgroundColor = .red
        label2.text = "标签2"
        label2.frame = CGRect(x: 100, y: 300, width: label2.intrinsicContentSize.width, height: label2.intrinsicContentSize.height)
        self.view.addSubview(label2)
        
        // 触摸
        let touch2 = UIPanGestureRecognizer(target: self, action: #selector(panLabel2Did(_:)))
        touch2.maximumNumberOfTouches = 1
        label2.addGestureRecognizer(touch2)
        
        // 移动通知
        label2.addObserver(self, forKeyPath: "center", options: .new, context: UnsafeMutableRawPointer.init(bitPattern: "label2".hashValue))
        
        
        drawBezier()
        
    }
    let pathLayer = CAShapeLayer()
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "center" {
            drawBezier()
        }
    }
    
    @objc func panLabelDid(_ recognizer:UIPanGestureRecognizer){
        let point = recognizer.location(in: self.label)
        if label.center.y + point.y - label.frame.height/2 < UIApplication.shared.statusBarFrame.height {
            return
        }
        label.center = CGPoint(x: label.center.x + point.x - label.frame.width/2, y: label.center.y + point.y - label.frame.height/2)
    }
    
    @objc func panLabel2Did(_ recognizer:UIPanGestureRecognizer){
        let point = recognizer.location(in: self.label2)
        if label2.center.y + point.y - label2.frame.height/2 < UIApplication.shared.statusBarFrame.height {
            return
        }
        label2.center = CGPoint(x: label2.center.x + point.x - label2.frame.width/2, y: label2.center.y + point.y - label2.frame.height/2)
    }
    
    // 绘制曲线
    func drawBezier() {
        pathLayer.removeFromSuperlayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x:label.center.x, y:label.center.y))
        linePath.addCurve(to: CGPoint(x: label2.center.x, y: label2.center.y), controlPoint1: CGPoint(x: (140 + label.center.x)/2, y: 110), controlPoint2: CGPoint(x: (140 + label.center.x)/2, y: 200))
        //设定颜色，并绘制它们
        UIColor.clear.setFill()
        UIColor.black.setStroke()
        linePath.stroke()
        
        pathLayer.lineWidth = 2
        pathLayer.lineDashPhase = 10.0
        pathLayer.lineDashPattern = [10,5]
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.orange.cgColor
        pathLayer.frame = self.view.bounds
        pathLayer.path = linePath.cgPath
        
        self.view.layer.addSublayer(pathLayer)
        self.view.bringSubviewToFront(label)
        self.view.bringSubviewToFront(label2)
    }


}

// label标签外扩
class SpecialLabel: UILabel {
    
    var textInsets: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = textInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}

