//
//  ViewController.swift
//  testArrayDisorderDemo1
//
//  Created by Yizhe.Zhang on 2019/3/26.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import UIKit
import ArrayDisorderSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let disOrder = ArrayDisorder()
        print(disOrder.disorder(array: [1,2,3,4,5,6,7,8,9]))
        // Do any additional setup after loading the view.
    }


}

