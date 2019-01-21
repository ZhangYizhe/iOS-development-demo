//
//  ViewController.swift
//  themeManage
//
//  Created by Yizhe.Zhang on 2018/12/28.
//  Copyright © 2018 cn.yygdz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.window?.backgroundColor = UIColor.black
        self.view.window?.alpha = 0.6
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
//        self.view.backgroundColor = Theme().background
//        button.tintColor = Theme().button
//        uilabel.textColor = Theme().label
//        lineView.backgroundColor = Theme().line
    }
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var uilabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    

}

