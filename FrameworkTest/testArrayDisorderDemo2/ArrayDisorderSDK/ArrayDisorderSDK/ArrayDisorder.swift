//
//  ArrayDisorder.swift
//  ArrayDisorderSDK
//
//  Created by Yizhe.Zhang on 2019/3/26.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import UIKit

open class ArrayDisorder: NSObject {
    open func disorder(array : Array<Int>) -> Array<Int> {
        var temp = array
        var count = temp.count
        while count > 0 {
            let index = Int(arc4random_uniform(UInt32(Int32(count))))
            let last = count - 1
            temp.swapAt(index, last)
            count -= 1
        }
        return temp
    }
}
