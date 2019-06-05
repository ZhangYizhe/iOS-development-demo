//
//  ChatDetailTimeHeader.swift
//  chatDemo
//
//  Created by 张艺哲 on 2019/5/28.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class ChatDetailTimeHeader: NSView {
    
    var time : String = "" {
        willSet {
            timeLabel.stringValue = newValue
        }
    }
    
    private let timeLabel = NSLabel()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        initView()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView() {
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        self.addSubview(timeLabel)
        timeLabel.stringValue = "时间"
        timeLabel.textColor = .init(hex: "908f95")
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(7)
            make.centerX.equalToSuperview()
        }
        
    }
    
}
