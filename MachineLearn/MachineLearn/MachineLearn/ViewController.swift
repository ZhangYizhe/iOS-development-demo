//
//  ViewController.swift
//  MachineLearn
//
//  Created by Yizhe.Zhang on 2019/3/5.
//  Copyright © 2019 com.yizheyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var modelResultLabel: UILabel!
    @IBOutlet weak var modelVersionLabel: UILabel!
    @IBOutlet weak var modelDescribeLabel: UILabel!
    
    var fengMLModel : Any? = nil // 模型
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 12.0, *) {
            fengMLModel = FengMLModel()
            downloadModel()
        } else {
            // Fallback on earlier versions
        }
    }
    
    // 下载模型
    func downloadModel() {
        DownloadModel.shared.sessionSeniorDownload()
        DownloadModel.shared.onProgress = { (progress) in
            OperationQueue.main.addOperation {
                self.progressView.progress = Float(progress) //下载进度刷新
                if Float(progress) == 1 {
                    if #available(iOS 12.0, *) {
                        let _fengMLModel = self.fengMLModel as! FengMLModel
                        _fengMLModel.queue.async(qos: .background) {
                            DispatchQueue.main.async {
                                self.modelVersionLabel.text = _fengMLModel.modelVersion
                                self.modelDescribeLabel.text = _fengMLModel.modelDescribe
                            }
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
    }
    
    @IBAction func CheckBtnTap(_ sender: UIButton) {
        if #available(iOS 12.0, *) {
            let _fengMLModel = self.fengMLModel as! FengMLModel
            _fengMLModel.AdsCheck(content: inputTextView.text, completion: { (status, message) in
                DispatchQueue.main.async {
                    self.modelResultLabel.text = message
                }
            })
        }
    }
}

