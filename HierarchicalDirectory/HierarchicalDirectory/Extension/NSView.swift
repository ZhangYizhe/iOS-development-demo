//
//  NSView.swift
//  RhinoStar-EU
//
//  Created by Yizhe.Zhang on 2019/4/13.
//  Copyright © 2019 GenJin Mao. All rights reserved.
//

import Cocoa

extension NSView {
    
    /// 视图置于最顶
    ///
    /// - Parameter view: 子视图
    func SubviewToFront(_ view: NSView) {
        var theView = view
        self.sortSubviews({(viewA,viewB,rawPointer) in
            let view = rawPointer?.load(as: NSView.self)
            
            switch view {
            case viewA:
                return ComparisonResult.orderedDescending
            case viewB:
                return ComparisonResult.orderedAscending
            default:
                return ComparisonResult.orderedSame
            }
        }, context: &theView)
    }

    /// 视图置于最底
    ///
    /// - Parameter view: 子视图
    func SubviewToBack(_ view: NSView) {
        var theView = view
        self.sortSubviews({(viewA,viewB,rawPointer) in
            let view = rawPointer?.load(as: NSView.self)
            
            switch view {
            case viewA:
                return ComparisonResult.orderedAscending
            case viewB:
                return ComparisonResult.orderedDescending
            default:
                return ComparisonResult.orderedSame
            }
        }, context: &theView)
    }
    
    func setBackgroundColor(_ color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
    
}

class BorderView: NSView {
    override func awakeFromNib() {
        self.wantsLayer = true
        self.layer?.borderColor = NSColor.init(hex: "#EEEEEE").cgColor
        self.layer?.borderWidth = 1
    }
}

class ResponseView: NSView {

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    override var acceptsTouchEvents: Bool {
        get {
            return true
        }
        set {
            
        }
    }
    
    var mouseDownUpComplection = {(event: NSEvent) in}
    
    override func mouseDown(with event: NSEvent) {
        mouseDownUpComplection(event)

    }

    override func mouseUp(with event: NSEvent) {
        mouseDownUpComplection(event)
    }
}
