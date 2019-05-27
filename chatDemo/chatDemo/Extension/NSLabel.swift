//
//  NSLabel.swift
//  chatDemo
//
//  Created by 张艺哲 on 2019/5/25.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class NSLabel: NSTextField {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    init(string : String) {
        super.init(frame: .zero)
        self.stringValue = string
        initLabel()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initLabel()
    }
    
    func initLabel() {
        self.isEditable = false
        self.drawsBackground = false
        self.isBordered = false
        self.textColor = NSColor.black
        self.usesSingleLineMode = true
        self.lineBreakMode = .byTruncatingTail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
