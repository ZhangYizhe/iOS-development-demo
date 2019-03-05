//
//  DownloadModel.swift
//  MachineLearn
//
//  Created by Yizhe.Zhang on 2019/3/5.
//  Copyright © 2019 com.yizheyun. All rights reserved.
//

import Foundation
import UIKit

class DownloadModel:NSObject, URLSessionDownloadDelegate {
    
    //单例模式
    static var shared = DownloadModel()
    
    //下载进度回调
    var onProgress: ((CGFloat) -> ())?
    
    private lazy var session:URLSession = {
        //只执行一次
        let config = URLSessionConfiguration.default
        let currentSession = URLSession(configuration: config, delegate: self,
                                        delegateQueue: nil)
        return currentSession
        
    }()
    
    
    //下载文件
    func sessionSeniorDownload(){
        //下载地址
        let url = URL(string: "http://qiniu.yizheyun.cn/TextClassifier2.mlmodel")
        //请求
        let request = URLRequest(url: url!)
        
        //下载任务
        let downloadTask = session.downloadTask(with: request)
        
        //使用resume方法启动任务
        downloadTask.resume()
    }
    
    
    //下载代理方法，下载结束
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        //下载结束
        print("下载结束")
        if let onProgress = onProgress {
            onProgress(1)
        }
        
        //输出下载文件原来的存放目录
        print("location:\(location)")
        //location位置转换
        let locationPath = location.path
        //拷贝到用户目录
        let documnets:String = NSHomeDirectory() + "/Documents/TextClassifier.mlmodel"
        //创建文件管理器
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: documnets)
        try! fileManager.moveItem(atPath: locationPath, toPath: documnets)
        print("new location:\(documnets)")
    }
    
    //下载代理方法，监听下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        //获取进度
        let written:CGFloat = (CGFloat)(totalBytesWritten)
        let total:CGFloat = (CGFloat)(totalBytesExpectedToWrite)
        let pro:CGFloat = written/total
        if let onProgress = onProgress {
            onProgress(pro)
        }
    }
    
    //下载代理方法，下载偏移
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //下载偏移，主要用于暂停续传
    }
    
}
