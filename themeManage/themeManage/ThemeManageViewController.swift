//
//  ThemeManageViewController.swift
//  themeManage
//
//  Created by Yizhe.Zhang on 2018/12/28.
//  Copyright © 2018 cn.yygdz. All rights reserved.
//

import UIKit

class ThemeManageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uibutton = UIButton(type: .system)
        uibutton.setTitle("切换主题", for: .normal)
        uibutton.addTarget(self, action: #selector(change(_:)), for: .touchUpInside)
        uibutton.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: uibutton.intrinsicContentSize)
        self.view.addSubview(uibutton)
        uibutton.center = self.view.center

    }
    

    @objc func change(_ sender: UIButton) {
        DispatchQueue.main.async {
            if Theme().now == .day {
                Theme().now = .night
            }else{
                Theme().now = .day
            }
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func closeBtnTap(_ sender: UIButton) {
        
    }
    
}
