//
//  VideoRightDetailItemCommentSendItem.swift
//  VideoMacDemo
//
//  Created by Yizhe.Zhang on 2019/4/9.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Cocoa

class VideoRightDetailItemCommentSendItem: NSCollectionViewItem, NSTextViewDelegate {
    @IBOutlet weak var inputCanvasView: NSView!
    @IBOutlet var inputTextView: NSTextView!
    @IBOutlet weak var placeholderLabel: NSTextField!
    @IBOutlet weak var wordCountLabel: NSTextField!
    
    var macWordNum = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.delegate = self
        inputCanvasView.wantsLayer = true
        inputCanvasView.layer?.backgroundColor = NSColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
        inputCanvasView.layer?.cornerRadius = 2
         inputTextView.backgroundColor = NSColor.clear
        let inputString = inputTextView?.string ?? ""
        wordCountLabel.stringValue = "还可以输入\(macWordNum - inputString.count)个字"
    }
    
    func textDidChange(_ notification: Notification) {
        if inputTextView?.string == "" {
            placeholderLabel.alphaValue = 1.0
        } else {
            placeholderLabel.alphaValue = 0.0
        }
        
        let inputString = inputTextView?.string ?? ""
        wordCountLabel.stringValue = "还可以输入\(macWordNum - inputString.count)个字"
    }
    
}
