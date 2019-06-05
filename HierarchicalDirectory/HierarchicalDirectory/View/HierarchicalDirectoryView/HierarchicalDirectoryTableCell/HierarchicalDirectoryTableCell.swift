//
//  HierarchicalDirectoryCell.swift
//  HierarchicalDirectory
//
//  Created by 张艺哲 on 2019/6/5.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class HierarchicalDirectoryTableCell: NSTableCellView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 当使用xib生成的时 需要自定义初始化的代码
        initView()
    }

    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
    
    var title = "标题" {
        willSet {
            titleLabel.stringValue = newValue
        }
    }
    
    var icon = NSImage() {
        willSet {
            iconImageView.image = newValue
        }
    }
    
    private let titleLabel = NSLabel()
    private let iconImageView = NSImageView()
    
    var initViewFlag = false
    func initView() {
        self.wantsLayer = true
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)

        iconImageView.setBackgroundColor(.init(hex: "#ececec"))
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
            make.left.equalToSuperview().offset(5)
        }
        
        titleLabel.stringValue = title
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
        
    }
}
