//
//  ChatDetailTextItem.swift
//  chatDemo
//
//  Created by 张艺哲 on 2019/5/27.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa
import SnapKit

class ChatDetailTextItem: NSCollectionViewItem {
    
    private let _imageView = NSImageView()
    
    var from : From = .left {
        willSet {
            switch newValue {
            case .left:
                _imageView.image = imageLeft
                contentLabel.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().offset(10)
                    make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
                    make.left.equalTo(_imageView.snp.left).offset(9)
                }
            case .right:
                _imageView.image = imageRight
                contentLabel.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-10)
                    make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
                    make.right.equalTo(_imageView.snp.right).offset(-9)
                }
            }
        }
    }
    
    enum From {
        case left
        case right
    }
    
    var content = "" {
        willSet {
            self.view.SubviewToFront(contentLabel)
            contentLabel.stringValue = newValue
        }
    }
    let contentLabel = NSLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(contentLabel)
        self.view.addSubview(_imageView)

        contentLabel.usesSingleLineMode = false
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.font = NSFont.systemFont(ofSize: 13, weight: .light)
        contentLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
            make.left.equalTo(_imageView.snp.left).offset(9)
        }
        
        initImage()
        
        _imageView.image = imageLeft
        _imageView.imageScaling = .scaleAxesIndependently
        
        _imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(contentLabel.snp.height).offset(10)
            make.width.equalTo(contentLabel.snp.width).offset(15)
        }
    }
    
    let imageLeft = NSImage(named: "ChatDetail-Dialog-left") ?? NSImage()
    let imageRight = NSImage(named: "ChatDetail-Dialog-right") ?? NSImage()
    func initImage() {
        imageLeft.capInsets = NSEdgeInsets(top: 5, left: 9, bottom: 5, right: 5)
        imageRight.capInsets = NSEdgeInsets(top: 5, left: 9, bottom: 5, right: 9)
    }
}
