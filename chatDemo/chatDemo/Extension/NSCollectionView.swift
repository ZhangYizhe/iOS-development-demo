//
//  NSCollectionView.swift
//  chatDemo
//
//  Created by 张艺哲 on 2019/5/27.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class AutoItemSizeCollectionView : NSCollectionView {
    override var frame: NSRect {
        didSet {
            collectionViewLayout?.invalidateLayout()
        }
    }
}
