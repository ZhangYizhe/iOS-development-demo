//
//  MainWindow.swift
//  HierarchicalDirectory
//
//  Created by 张艺哲 on 2019/6/5.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa
import SnapKit

class MainWindow: NSWindowController, NSWindowDelegate{
    
    let hierarchicalDirectoryViewController : HierarchicalDirectoryViewController = HierarchicalDirectoryViewController(nibName: "HierarchicalDirectoryView", bundle: nil)
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        self.window?.center()
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.delegate = self
        
        self.contentViewController = hierarchicalDirectoryViewController
//        hierarchicalDirectoryViewController.view.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }

    }
    
}
