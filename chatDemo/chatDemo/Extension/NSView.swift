//
//  NSView.swift
//  chatDemo
//
//  Created by 张艺哲 on 2019/5/25.
//  Copyright © 2019 张艺哲. All rights reserved.
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
