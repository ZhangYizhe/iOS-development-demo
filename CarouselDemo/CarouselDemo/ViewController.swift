//
//  ViewController.swift
//  CarouselDemo
//
//  Created by 张艺哲 on 2019/5/6.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let content = NSCarouselView(nibName: "NSCarouselView", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        content.view.frame = self.view.frame
        

        self.view.addSubview(content.view)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewDidLayout() {
        content.view.frame = self.view.frame
    }


}

