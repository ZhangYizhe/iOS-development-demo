//
//  CarouselView.swift
//  CarouselDemo
//
//  Created by 张艺哲 on 2019/5/6.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class NSCarouselView: NSViewController {
    
    let topImageView = NSImageView()
    let bottomImageView = NSImageView()
    
    let carouseltoolView = CarouselToolView()
    
    var index = 0 {
        willSet {
            setIndex(newValue)
        }
    }
    var imageUrl = ["1.jpeg","2.jpeg","3.jpeg","4.jpeg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topImageView.frame = self.view.frame
        bottomImageView.frame = self.view.frame
        
        self.view.addSubview(bottomImageView)
        self.view.addSubview(topImageView)
        
        carouseltoolView.frame = NSRect(x: 0, y: 10, width: self.view.bounds.width, height: 30)
        carouseltoolView.totalNum = imageUrl.count
        carouseltoolView.indexCompletion = { [weak self] _index in
            guard let self = self else {return}
            self.index = _index - 1
        }

        self.view.addSubview(carouseltoolView)
        
        
        index = 0
        
    }
    
    func setIndex(_ _index: Int) {
        if imageUrl.count <= 0 {
            return
        }
        
        if _index > imageUrl.count - 1 {
            return
        }
        NSAnimationContext.endGrouping()
        topImageView.wantsLayer = true
        topImageView.alphaValue = 1
        bottomImageView.image = NSImage(named: imageUrl[_index])
        NSAnimationContext.runAnimationGroup({ (_) in
            NSAnimationContext.current.duration = 0.25
            topImageView.animator().alphaValue = 0
        }, completionHandler: {
            self.topImageView.image = NSImage(named: self.imageUrl[_index])
            self.topImageView.alphaValue = 1
        })
    }
    
    override func viewDidLayout() {
        topImageView.frame = self.view.frame
        bottomImageView.frame = self.view.frame
        carouseltoolView.frame = NSRect(x: 0, y: 10, width: self.view.bounds.width, height: 30)
        
        if area != nil { self.view.removeTrackingArea(area) }
        
        let opt = (NSTrackingArea.Options.mouseEnteredAndExited.rawValue | NSTrackingArea.Options.mouseMoved.rawValue | NSTrackingArea.Options.activeAlways.rawValue)
        
        area = NSTrackingArea.init(rect: self.view.bounds, options: NSTrackingArea.Options(rawValue: opt), owner: self, userInfo: nil)
        self.view.addTrackingArea(area)
    }
    
    var area:NSTrackingArea!

    
    override func mouseEntered(with event: NSEvent) {
        
    }
    
    override func mouseExited(with event: NSEvent) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        print("按下")
    }
    
    
    deinit {
        self.view.removeTrackingArea(area)
    }
    
    
}
