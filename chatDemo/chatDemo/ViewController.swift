//
//  ViewController.swift
//  chatDemo
//
//  Created by 张艺哲 on 2019/5/25.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa
import SnapKit

class ViewController: NSViewController {
    
    var chatDetailView : ChatDetailView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func initView() {
        chatDetailView = ChatDetailView(nibName: "ChatDetailView", bundle: nil)
        
        self.view.addSubview(chatDetailView?.view ?? NSView())
        chatDetailView?.view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
    }


}

