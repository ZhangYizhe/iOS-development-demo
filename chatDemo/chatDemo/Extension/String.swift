//
//  String.swift
//  chatDemo
//
//  Created by 张艺哲 on 2019/5/27.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
    
    /// 添加行间距
    public var toAttributedByLineSpacing: NSAttributedString {
        
        let textParagraph = NSMutableParagraphStyle()
        textParagraph.lineSpacing = 10
        let attrString = NSAttributedString(string: self, attributes: [.paragraphStyle : textParagraph])
        
        return attrString
    }
    
    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}
