//
//  ViewController.swift
//  FilePreviewDemo
//
//  Created by Yizhe.Zhang on 2019/4/17.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//


import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadProgressIndicator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let myURL = URL(string:"https://www.apple.com/privacy/docs/Differential_Privacy_Overview.pdf")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)

    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("开始加载")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("结束加载")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            loadProgressIndicator.doubleValue = webView.estimatedProgress
        }
    }

}
