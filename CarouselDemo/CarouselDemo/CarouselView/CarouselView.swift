//
//  CarouselView.swift
//  CarouselDemo
//
//  Created by 张艺哲 on 2019/5/6.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class CarouselView: NSViewController {
    
    let firImageView = NSImageView()
    let secImageView = NSImageView()
    
    let carouseltoolView = CarouselToolView()
    
    var index = 0 {
        willSet {
            setIndex()
        }
    }
    var imageUrl = ["1.jpeg","2.jpeg","3.jpeg","4.jpeg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firImageView.frame = self.view.frame
        secImageView.frame = self.view.frame
        
        self.view.addSubview(firImageView)
        self.view.addSubview(secImageView)
        
        self.view.SubviewToBack(secImageView)
        
        carouseltoolView.frame = NSRect(x: 0, y: 10, width: self.view.bounds.width, height: 20)
        carouseltoolView.totalNum = imageUrl.count
        carouseltoolView.indexCompletion = { [weak self] _index in
            guard let self = self else {return}
            self.index = _index - 1
            self.setIndex()
        }

        self.view.addSubview(carouseltoolView)
        
        
        index = 0
        
    }
    
    override func viewDidLayout() {
        firImageView.frame = self.view.frame
        secImageView.frame = self.view.frame
        carouseltoolView.frame = NSRect(x: 0, y: 10, width: self.view.bounds.width, height: 30)
    }
    
    func setIndex() {
        
        if imageUrl.count <= 0 {
            return
        }
        
        if index > imageUrl.count - 1 {
            index = 0
        }
        
        firImageView.image = NSImage(named: imageUrl[index])
        
        if index + 1 > imageUrl.count - 1 {
            secImageView.image = NSImage(named: imageUrl[0])
        } else {
            secImageView.image = NSImage(named: imageUrl[index + 1])
        }
        
    }
    
    
}
