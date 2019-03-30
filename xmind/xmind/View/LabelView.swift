//
//  LabelView.swift
//  xmind
//
//  Created by Yizhe.Zhang on 2019/3/30.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Foundation
import UIKit

class LabelView {
    
    static let sharedLabelView = LabelView()
    private init() { }
    
    func create(_ _self: UIViewController,view: UIView, location: [Int], title: String, point: CGPoint) -> UILabel {
        let label = SpecialLabel()
        label.text = title
        label.location = location
        label.isUserInteractionEnabled = true
        label.textInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        label.backgroundColor = .red
        label.textColor = .white
        label.frame = CGRect(x: point.x, y: point.y, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        view.addSubview(label)
        
        if point.x == 0 && point.y == 0 {
            label.center = view.center
        }
        
        // 触摸
        let touch = UIPanGestureRecognizer(target: _self, action: #selector(panDid(_:)))
        touch.maximumNumberOfTouches = 1
        label.addGestureRecognizer(touch)
        
        // 移动通知
        label.addObserver(_self, forKeyPath: "center", options: .new, context: UnsafeMutableRawPointer.init(bitPattern: "\(location)".hashValue))
        
        return label
    }
    
    @objc func panDid(_ recognizer:UIPanGestureRecognizer){ }
}

// label标签
class SpecialLabel: UILabel {
    
    var location : [Int] = [] //标签位置
    
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
    
    // MARK: - 新增/删除节点菜单
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        isUserInteractionEnabled = true
        
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu(_:))))
    }
    
    private lazy var menuController:UIMenuController = {
        let menu = UIMenuController.shared
        let deleteItem = UIMenuItem(title: "增加子节点", action: #selector(addNode(_:)))
        let editItems = UIMenuItem(title: "删除节点", action: #selector(deleteNode(_:)))
        menu.menuItems = [deleteItem ,editItems]
        menu.arrowDirection = .down
        return menu
    }()
    
    @objc func showMenu(_ sender: UILongPressGestureRecognizer) {
        becomeFirstResponder()
        let menu = menuController
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    // 闭包回调
    var addHandle = { (location : [Int]) in }
    var deleteHandle = { (location : [Int]) in }
    
    @objc func addNode(_ sender: Any?) {
        let menu = menuController
        menu.setMenuVisible(false, animated: true)
        addHandle(location)
    }
    
    @objc func deleteNode(_ sender: Any?) {
        let menu = menuController
        menu.setMenuVisible(false, animated: true)
        deleteHandle(location)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?)
        -> Bool {
            if action == #selector(addNode(_:)) {
                return true
            } else if action == #selector(deleteNode(_:)) {
                return true
            }
            return false
    }
}
