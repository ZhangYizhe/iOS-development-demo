//
//  sonViewController.swift
//  NavigationControllerPopTest
//
//  Created by Yizhe.Zhang on 2019/3/26.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import UIKit

class sonViewController: UIViewController {
    
    var flag = 0
    
    var delegate : UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        if flag == 2 {
            delegate = self
        }

        initView()
    }

    
    // push
    @objc func tapTarget() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "sonViewController") as! sonViewController
        newVC.delegate = delegate
        newVC.flag = flag + 1
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // pop
    @objc func popTarget() {
        
        self.navigationController?.popToViewController(delegate!, animated: true)
    }
}


extension sonViewController {
    func initView()  {
        
        UILabel().create(_title: "\(flag)", selfCon: self) { (status) in
            switch status {
            case let .success(message):
                print(message.0)
                print(message.1)
            case .failure(_):
                break
            }
        }
        
        
        let touchBtn = UIButton.init(type: .system)
        touchBtn.setTitle("push", for: .normal)
        touchBtn.frame = CGRect(x: 0, y: 0, width: touchBtn.intrinsicContentSize.width, height: touchBtn.intrinsicContentSize.height)
        touchBtn.center = self.view.center
        touchBtn.addTarget(self, action: #selector(tapTarget), for: .touchUpInside)
        self.view.addSubview(touchBtn)
        
        let popBtn = UIButton.init(type: .system)
        popBtn.setTitle("跳转到第二页", for: .normal)
        popBtn.frame = CGRect(x: 0, y: 0, width: popBtn.intrinsicContentSize.width, height: popBtn.intrinsicContentSize.height)
        popBtn.addTarget(self, action: #selector(popTarget), for: .touchUpInside)
        popBtn.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 50)
        self.view.addSubview(popBtn)
        
    }
    
    
}

extension UILabel {
    
    enum typeError: Error {
        case code_1
        case code_2
    }
    
    func create(_title: String,selfCon: UIViewController, completion: (Result<(String,Bool),typeError>)->()) {
        let title = UILabel()
        title.text = _title
        title.frame = CGRect(x: 0, y: 0, width: title.intrinsicContentSize.width, height: title.intrinsicContentSize.height)
        title.center = CGPoint(x: selfCon.view.center.x, y: selfCon.view.center.y - 50)
        selfCon.view.addSubview(title)
        completion(.success(("asdf",true)))
    }
    
}
