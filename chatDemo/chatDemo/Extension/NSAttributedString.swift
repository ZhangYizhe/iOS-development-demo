//
//  NSAttributedString.swift
//  RhinoStar
//
//  Created by 张艺哲 on 2019/5/23.
//  Copyright © 2019 GenJin Mao. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    /// 限定宽度计算高度
    ///
    /// - Parameter width: 宽度
    /// - Returns: 所需高度
    public func height(width: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.height
    }
    
    /// 限定高度计算宽度
    ///
    /// - Parameter height: 高度
    /// - Returns: 所需宽度
    public func width(height: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: .greatestFiniteMagnitude, height: height), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.width
    }
}
