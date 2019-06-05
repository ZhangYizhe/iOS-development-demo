//
//  ChatDetailTextView.swift
//  chatDemo
//
//  Created by 张艺哲 on 2019/5/27.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class ChatDetailTextView: NSTextView, NSTextViewDelegate, NSTextDelegate {
    
    private var placeholder : NSLabel? = nil
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if placeholder == nil {
            self.delegate = self
            placeholder = NSLabel()
            placeholder?.stringValue = "文本信息"
            placeholder?.textColor = .init(hex: "#cecece")
            placeholder?.font = .systemFont(ofSize: 13, weight: .regular)
            self.addSubview(placeholder ?? NSView())
            placeholder?.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(1)
                make.left.equalToSuperview().offset(5)
            })
        }
    }
    
    func textDidChange(_ notification: Notification) {
        if inputString == self.textStorage?.string {
            return
        }
        inputString = self.textStorage?.string ?? ""
        inputCompletion()
    }
    
    private var inputString = ""
    var inputCompletion = {() in}
    var enterCompletion = {(content: String) in}
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        
        if event.modifierFlags.intersection(.deviceIndependentFlagsMask).rawValue != 524288 { //判断是否为ctrl+回车
            if event.keyCode == 36 {
                var content = (self.textStorage?.string ?? "")
                content = content.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                if content != "" {
                    enterCompletion(content)
                    
                }
                
                self.textStorage?.mutableString.setString("")
            }
        }
        
        placeholder?.isHidden = !string.isEmpty
        
        if inputString == self.textStorage?.string {
            return
        }
        inputString = self.textStorage?.string ?? ""
        
        inputCompletion()
    }
    
}
