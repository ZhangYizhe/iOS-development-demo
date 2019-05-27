//
//  CarouselToolView.swift
//  CarouselDemo
//
//  Created by 张艺哲 on 2019/5/6.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class CarouselToolView: NSView {

    // MAKR: - 当前所在
    var indexCompletion = {(index: Int) in }
    var index = 1 {
        didSet {
            var dotX : CGFloat = (self.bounds.width / 2) - (((dotDiameter + dotSpacing) * CGFloat(totalNum) - dotSpacing + 10) / 2)
            let dotY = (self.bounds.height / 2) - (dotDiameter / 2)
            
            for (k, dot) in dotArr.enumerated() {
                var _width = dotDiameter
                
                if index - 1 == k {
                    _width += 10
                    self.dotArr[k].layer?.backgroundColor = NSColor.init(hex: "65d045").cgColor
                } else {
                    self.dotArr[k].layer?.backgroundColor = NSColor.init(hex: "282828", alpha: 0.3).cgColor
                }
                
                NSAnimationContext.runAnimationGroup({ (_) in
                    NSAnimationContext.current.duration = 0.25
                    dotArr[k].animator().frame = NSRect(x: dotX, y: dotY, width: _width, height: dotDiameter)
                }, completionHandler: {
                    
                })
                
                dotX = dotX + _width + dotSpacing
            }
        }
        
        willSet {
            indexCompletion(newValue)
        }
    }
    
    // MAKR: - 总数
    var totalNum = 0 {
        willSet {
            for dot in dotArr {
                dot.removeFromSuperview()
            }
            
            dotArr.removeAll()
            
            var dotX : CGFloat = (self.bounds.width / 2) - (((dotDiameter + dotSpacing) * CGFloat(newValue) - dotSpacing + 10) / 2)
            let dotY = (self.bounds.height / 2) - (dotDiameter / 2)
            
            for k in 0..<newValue {
                var _width = dotDiameter
                if index - 1 == k {
                    _width += 10
                }
                
                let dot = CarouselToolDotView(frame: NSRect(x: dotX, y: dotY, width: _width, height: dotDiameter))
                
                if index - 1 == k {
                    dot.layer?.backgroundColor = NSColor.init(hex: "65d045").cgColor
                } else {
                    dot.layer?.backgroundColor = NSColor.init(hex: "282828", alpha: 0.3).cgColor
                }
                
                dotArr.append(dot)
                self.addSubview(dotArr[k])
                dotX = dotX + _width + dotSpacing
            }
        }
    }
    
    private var dotArr : [NSView] = []
    var dotDiameter : CGFloat = 8
    var dotSpacing : CGFloat = 10
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        
    }
    
    var area:NSTrackingArea!
    
    override func updateTrackingAreas() {
        if area != nil {
            self.removeTrackingArea(area)
        }
        
        let opt = (NSTrackingArea.Options.mouseEnteredAndExited.rawValue | NSTrackingArea.Options.mouseMoved.rawValue | NSTrackingArea.Options.activeAlways.rawValue)
        
        area = NSTrackingArea.init(rect: self.bounds, options: NSTrackingArea.Options(rawValue: opt), owner: self, userInfo: nil)
        
        self.addTrackingArea(area)
    }
    
    override func mouseEntered(with event: NSEvent) {
        //       print("进入")
    }
    
    override func mouseMoved(with event: NSEvent) {
        let a = dotArr.first?.frame.minX ?? 0
        let b = (dotArr.last?.frame.maxX ?? 0) - a
        
        let relativeX = event.locationInWindow.x - a
        
        if relativeX > 0 && relativeX < b {
            let newValue = Int(relativeX / (dotDiameter + dotSpacing)) + 1
            if index == newValue {
                return
            }
            index = newValue
        }
        
    }
    
    override func mouseExited(with event: NSEvent) {
        //        print("离开")
    }
    
    
    deinit {
        self.removeTrackingArea(area)
    }
    
}

class CarouselToolDotView: NSView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.layer?.cornerRadius = dirtyRect.height / 2
        self.layer?.masksToBounds = true
        
    }
    
}
