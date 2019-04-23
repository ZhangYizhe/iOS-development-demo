//
//  ViewController.swift
//  ScrollPageDemo
//
//  Created by Yizhe.Zhang on 2019/4/22.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    lazy var scrollView = NSPageScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.scrollDirection = { type in
            
            
        }
        
        scrollView.pageCompletion = { page in
            print(page)
            
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
        
        let _contentView = NSView(frame: CGRect(x: 0, y: 0, width: itemWidth * 3, height: itemHeight))
        _contentView.wantsLayer = true
        
        for i in 0..<3 {
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

class NSPageScrollView: NSScrollView {
    
    var timer : Timer? = nil
    
    var area:NSTrackingArea!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        // scrollerStyle。overlay / legacy。 overlay 的效果，则是 scroller 背景透明，而 legacy 则是 独立出 scroller 的区域
        //        scrollerStyle = .overlay
        
        hasVerticalScroller = false
        hasHorizontalScroller = false
        
        // 滚动条的样式：light、 dark、default。default 的话，其实就是 dark
        scrollerKnobStyle = .dark
        
        //  bounce 的效果。elasticity 是弹性的含义。automatic\allowed\none。
        horizontalScrollElasticity = .automatic
        verticalScrollElasticity = .automatic
//
//        timer = Timer.new(every: 3.second) {
//            self.pageSwitch(direction: true)
//        }
//
//        timer?.start()
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        let opt = (NSTrackingArea.Options.mouseEnteredAndExited.rawValue | NSTrackingArea.Options.mouseMoved.rawValue | NSTrackingArea.Options.activeAlways.rawValue)
        
        area = NSTrackingArea.init(rect: self.bounds, options: NSTrackingArea.Options(rawValue: opt), owner: self, userInfo: nil)
        
        self.addTrackingArea(area)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                    pageSwitch(direction: false)
                } else {
                    pageSwitch(direction: true)
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
    
    // MARK: 滚动动画
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
    
    // MARK: 鼠标监听
    var mouseMove : CGFloat = 0
    override func mouseDragged(with event: NSEvent) {
        documentView?.scroll(NSPoint(x: documentVisibleRect.origin.x - event.deltaX, y: 0))
        mouseMove += event.deltaX
    }
    
    override func mouseDown(with event: NSEvent) {
        mouseMove = 0
    }
    override func mouseUp(with event: NSEvent) {
        if mouseMove > 0 {
            pageSwitch(direction: false)
        } else {
            pageSwitch(direction: true)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
//        timer?.invalidate()
    }
    
    override func mouseExited(with event: NSEvent) {
//        timer = Timer.new(every: 3.second) {
//            self.pageSwitch(direction: true)
//        }
//        timer?.start()
    }
    
    // MARK: 当前页数
    var page = 0 {
        willSet {
            pageCompletion(newValue)
        }
    }
    var pageCompletion = {(page: Int) in}
    
    // MARK: 上一页/下一页动画
    func pageSwitch(direction : Bool) {
        
        var _page = page
        
        if direction { // 下一页
            _page += 1
        } else {
            _page -= 1 // 上一页
        }
        
        let totalPage = Int(((documentView?.bounds.width ?? 0) / self.bounds.width) - 1)
        
        if _page < 0 {
            page = totalPage
        } else if _page > totalPage {
            page = 0
        } else {
            page = _page
        }
        
        scroll(to: NSPoint(x: CGFloat(page) * self.bounds.width, y: 0), animationDuration: 0.3)
    }
    
    // MARK: - 强制设置页
    func pageSet(_ index: Int) {
        let totalPage = Int(((documentView?.bounds.width ?? 0) / self.bounds.width) - 1)
        
        if index < 0 {
            page = totalPage
        } else if index > totalPage {
            page = 0
        } else {
            page = index
        }
        
        documentView?.scroll(NSPoint(x: CGFloat(page) * self.bounds.width, y: 0))
    }
    
    
    deinit {
        self.removeTrackingArea(area)
        timer?.invalidate()
        timer = nil
    }
    
}


