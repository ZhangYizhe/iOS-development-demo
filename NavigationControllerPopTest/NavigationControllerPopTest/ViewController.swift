//
//  ViewController.swift
//  NavigationControllerPopTest
//
//  Created by Yizhe.Zhang on 2019/3/26.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initView()
    }

    
    @objc func tapTarget() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "sonViewController")
        self.navigationController?.pushViewController(newVC, animated: true)
    }


}

extension ViewController {
    func initView()  {
        let touchBtn = UIButton.init(type: .system)
        touchBtn.setTitle("push", for: .normal)
        touchBtn.frame = CGRect(x: 0, y: 0, width: touchBtn.intrinsicContentSize.width, height: touchBtn.intrinsicContentSize.height)
        touchBtn.center = self.view.center
        touchBtn.addTarget(self, action: #selector(tapTarget), for: .touchUpInside)
        self.view.addSubview(touchBtn)
        
        
        let inputTextView = UITextField()
        inputTextView.borderStyle = .line
        inputTextView.placeholder = "1·2341243"
        inputTextView.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        inputTextView.center = self.view.center
        inputTextView.setValue(UIColor.red, forKeyPath: "_placeholderLabel.textColor")
        self.view.addSubview(inputTextView)
        
        var count: UInt32  = 0
        let ivars = class_copyIvarList(UITextField.self,  &count)
        for i in 0 ..< count {
            let ivar = ivars![Int(i)]
            let name = ivar_getName(ivar)
            print(String(cString: name!))
        }
        free(ivars)

        
    }
}

