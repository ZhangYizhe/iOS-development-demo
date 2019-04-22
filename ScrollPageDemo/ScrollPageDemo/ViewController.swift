//
//  ViewController.swift
//  ScrollPageDemo
//
//  Created by Yizhe.Zhang on 2019/4/22.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    lazy var scrollView: PageScrollView = {
        let scrollView = PageScrollView()
        
        // scrollerStyle。overlay / legacy。 overlay 的效果，则是 scroller 背景透明，而 legacy 则是 独立出 scroller 的区域
        scrollView.scrollerStyle = .overlay

        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        
        // 滚动条的样式：light、 dark、default。default 的话，其实就是 dark
        scrollView.scrollerKnobStyle = .dark
        
        //  bounce 的效果。elasticity 是弹性的含义。automatic\allowed\none。
        scrollView.horizontalScrollElasticity = .automatic
        scrollView.verticalScrollElasticity = .automatic
        
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.scrollDirection = { type in
            switch type {
            case .left:
                let newValue = self.scrollView.documentVisibleRect.origin.x + self.scrollView.bounds.width
                if newValue < self.scrollView.documentView?.frame.size.width ?? 0 {
                    self.scrollView.scroll(to: NSPoint(x: newValue, y: 0), animationDuration: 0.3)
                } else {
                    self.scrollView.documentView?.scroll(NSPoint(x: 0, y: 0))
                }
            case .right:
                let newValue = self.scrollView.documentVisibleRect.origin.x - self.scrollView.bounds.width
                if newValue >= 0 {
                    self.scrollView.scroll(to: NSPoint(x: newValue, y: 0), animationDuration: 0.3)
                } else {
                    self.scrollView.documentView?.scroll(NSPoint(x: self.scrollView.documentView?.bounds.width ?? 0 - self.scrollView.bounds.width, y: 0))
                    
                }
            default:
                break
            }
            
        }
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        initView()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func initView() {
        scrollView.frame = self.view.frame
        self.view.addSubview(scrollView)
        initDocumentView()
    }
    
    func initDocumentView() {
        
        let itemWidth = self.scrollView.bounds.width
        let itemHeight = self.scrollView.bounds.height
        
        let _contentView = NSView(frame: CGRect(x: 0, y: 0, width: itemWidth * 10, height: itemHeight))
        _contentView.wantsLayer = true
        
        for i in 0..<10 {
            let sonView = NSView(frame: CGRect(x: CGFloat(i) * itemWidth, y: 0, width: itemWidth, height: itemHeight))
            
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            sonView.wantsLayer = true
            sonView.layer?.backgroundColor = NSColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
            _contentView.addSubview(sonView)
        }
        
        scrollView.documentView = _contentView
    }

}

class PageScrollView: NSScrollView {
    
    enum directionType {
        case down
        case up
        case left
        case right
    }
    
    var scrollDirection = {(type: directionType) in}
    
    override func scrollWheel(with event: NSEvent) {
        switch event.momentumPhase {
        case NSEvent.Phase.began:
            if abs(event.deltaX) > abs(event.deltaY) {
                if event.deltaX > 0 {
                    scrollDirection(.right)
                } else {
                    scrollDirection(.left)
                }
            } else {
                if event.deltaY > 0 {
                    scrollDirection(.down)
                } else {
                    scrollDirection(.up)
                }
            }
        default:
            break
        }
    }
    
    var scrollAnimation = false
    func scroll(to point: NSPoint, animationDuration: Double) {
        if scrollAnimation {
            return
        }
        scrollAnimation = true
        NSAnimationContext.current.duration = animationDuration
        NSAnimationContext.runAnimationGroup({(NSAnimationContext) in
            contentView.animator().setBoundsOrigin(point)
            reflectScrolledClipView(contentView)
        }) { [weak self] in
            guard let self = self else {return}
            self.scrollAnimation = false
        }
    }

    
    var test : CGFloat = 0
    override func mouseDragged(with event: NSEvent) {
        documentView?.scroll(NSPoint(x: documentVisibleRect.origin.x - event.deltaX, y: 0))
        test += event.deltaX
    }
    
    override func mouseDown(with event: NSEvent) {
        test = 0
    }
    override func mouseUp(with event: NSEvent) {
        if test > 0 {
            pageSet(test: false)
        } else {
            pageSet(test: true)
        }
    }
    
    var page = 0
    
    func pageSet(test : Bool) {
        
        if test {
            page += 1
        } else {
            page -= 1
        }
        
        let totalPage = Int(((documentView?.bounds.width ?? 0) / self.bounds.width) - 1)
        
        if page < 0 {
            page = totalPage
        } else if page > totalPage {
            page = 0
        }
        
        scroll(to: NSPoint(x: CGFloat(page) * self.bounds.width, y: 0), animationDuration: 0.3)
    }

}

