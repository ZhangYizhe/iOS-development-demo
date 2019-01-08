//
//  ViewController.swift
//  camera
//
//  Created by Yizhe.Zhang on 2018/12/25.
//  Copyright © 2018 cn.yygdz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    let captureSession = AVCaptureSession()
    var scanPane: UIImageView!///扫描框
    var scanLine: UIImageView!///扫描线

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            authorityJudgment()
            initView()
        }
    }
    
    //扫描框线
    func initScanView(){
        scanPane = UIImageView()
        scanPane.frame = CGRect(x: self.view.center.x - 150, y: self.view.center.y - 150, width: 300, height: 300)
        scanPane.image = UIImage(named: "QRCode_ScanBox")
        self.view.addSubview(scanPane)
        
        scanLine = UIImageView()
        scanLine.frame = CGRect(x: 0, y: 0, width: 300, height: 3)
        scanLine.image = UIImage(named: "QRCode_ScanLine")
        scanPane.addSubview(scanLine)
    }
    
    //其它部分
    func initView() {
        
        // 不能直接加在最底层viewController.view上面，会黑掉 后面没东西显示了
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor =  UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(backgroundView)
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd //  奇偶层显示规则
        let basicPath = UIBezierPath(rect: view.frame) // 底层
        let maskPath = UIBezierPath(rect: CGRect(x: self.view.center.x - 150, y: self.view.center.y - 150, width: 300, height: 300)) //自定义的遮罩图形
        basicPath.append(maskPath) // 重叠
        maskLayer.path = basicPath.cgPath
        backgroundView.layer.mask = maskLayer
        
        //标题
        let titleLabel = UILabel()
        titleLabel.text = "扫描二维码"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: titleLabel.intrinsicContentSize)
        titleLabel.center.x = self.view.center.x
        self.view.addSubview(titleLabel)
        titleLabel.center.y = self.view.center.y - 150 - 20
        
        //提示语
        let subLabel = UILabel()
        subLabel.text = "请将二维码对准至框内，即可自动扫描"
        subLabel.font = UIFont.systemFont(ofSize: 13)
        subLabel.textColor = UIColor.white
        subLabel.frame = CGRect(origin: CGPoint(x: 0, y: self.view.center.y + 150 + 20), size: CGSize(width: 300, height: subLabel.intrinsicContentSize.height))
        subLabel.center.x = self.view.center.x
        subLabel.numberOfLines = 3
        subLabel.textAlignment = .center
        self.view.addSubview(subLabel)
    }
    
    //权限判断
    func authorityJudgment() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized://由于限制，用户无法授予访问权限。
            initCamera(authorizationStatus: "1")
        case .notDetermined://用户之前已授予对相机的访问权限。
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.initCamera(authorizationStatus: "2")
                    }
                }
            }
        case .restricted://尚未要求用户进行相机访问。
            initCamera(authorizationStatus: "由于限制，用户无法授予访问权限。")
        case .denied: //用户先前已拒绝访问。
            initCamera(authorizationStatus: "用户先前已拒绝访问。")
        }
    }
    
    //相机输入初始化
    func initCamera(authorizationStatus: String) {
        if authorizationStatus != "1" && authorizationStatus != "2" {
            print(authorizationStatus)
        }else{
            let videoDevice = AVCaptureDevice.default(for: .video)
            guard
                let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
                captureSession.canAddInput(videoDeviceInput)
            else {
                    print("无法使用输入设备")
                    return
            }
            captureSession.addInput(videoDeviceInput)
            initOutView()
        }
    }
    
    //预览输出初始化
    func initOutView(){
        //设置输出
        let videoOutput = AVCaptureMetadataOutput()
        guard
            captureSession.canAddOutput(videoOutput)
        else {
            print("无法使用输出设备")
            return
        }
        
        captureSession.addOutput(videoOutput)
        videoOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        videoOutput.metadataObjectTypes = [.qr]
        
        //预览视图
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        initScanView()
        
        //传感器开始运行
        startScan()
    }
    
    //开始扫描
    func startScan() {
        if captureSession.isRunning {
            return
        }
        
        scanLine.layer.add(scanAnimation(), forKey: "scanLineAnimation")
        captureSession.startRunning()
    }
    
    //扫描动画
    private func scanAnimation() -> CABasicAnimation{
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        translation.fromValue = NSValue(cgPoint:  CGPoint(x: scanLine.center.x  , y: 0))
        translation.toValue = NSValue(cgPoint: CGPoint(x: scanLine.center.x, y: 300))
        translation.duration = 3.0 // 扫描时长
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        
        return translation
    }
    
    //结束扫描
    func stopScan() {
        if !captureSession.isRunning {
            return
        }
        captureSession.stopRunning()
        self.scanLine.layer.removeAllAnimations()
    }
    
    //扫描结果
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return
        }

        let metadataObj = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let message = metadataObj.stringValue ?? ""
            
            let queryArray = message.components(separatedBy: "_")
            if queryArray.count == 2 && queryArray[0] == "bbs" {
                print("扫描成功")
                stopScan()
                return
            }
        }
    }
    
   
    
}
