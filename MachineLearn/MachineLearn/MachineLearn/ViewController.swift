//
//  ViewController.swift
//  MachineLearn
//
//  Created by Yizhe.Zhang on 2019/3/5.
//  Copyright © 2019 com.yizheyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DownloadModel.shared.sessionSeniorDownload()
        DownloadModel.shared.onProgress = { (progress) in
            OperationQueue.main.addOperation {
                self.progressView.progress = Float(progress)
                if Float(progress) == 1 {
                    if #available(iOS 12.0, *) {
                        MachineLearnModel().test()
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
    }


}

