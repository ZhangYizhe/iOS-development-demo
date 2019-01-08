//
//  ImagePreviewViewController.swift
//  pictureWindow
//
//  Created by Yizhe.Zhang on 2018/12/28.
//  Copyright © 2018 cn.yygdz. All rights reserved.
//

import UIKit
import Photos
import Kingfisher
import FTIndicator

class ImagePreviewViewController: UIViewController,UIScrollViewDelegate {
    
    var imageUrl = ""
    
    //滚动视图
    var scrollView:UIScrollView!
    
    //用于显示图片的imageView
    var imageView:UIImageView!
    
    //加载进度
    var activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        //scrollView初始化
        scrollView = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(scrollView)
        scrollView.delegate = self
        //scrollView缩放范围 1~3
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        
        //imageView初始化
        imageView = UIImageView()
        imageView.frame = scrollView.bounds
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.hidesWhenStopped = true
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        imageView.kf.setImage(with: URL.init(string: imageUrl),completionHandler: { (image, _, _, _) in
            self.activityIndicatorView.stopAnimating()
        })
        
        //取消顶部留白
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        //单击监听
        let tapSingle=UITapGestureRecognizer(target:self, action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        //双击监听
        let tapDouble=UITapGestureRecognizer(target:self, action:#selector(tapDoubleDid(_:)))
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        //声明点击事件需要双击事件检测失败后才会执行
        tapSingle.require(toFail: tapDouble)
        self.imageView.addGestureRecognizer(tapSingle)
        self.imageView.addGestureRecognizer(tapDouble)
        
        //长按
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPress.numberOfTapsRequired = 0 //默认为0
        longPress.numberOfTouchesRequired = 1  //默认为1
        self.imageView.addGestureRecognizer(longPress)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetSize()
    }
    
    //重置单元格内元素尺寸
    func resetSize(){
        //scrollView重置，不缩放
        scrollView.frame = self.view.bounds
        scrollView.zoomScale = 1.0
        //imageView重置
        if let image = self.imageView.image {
            //设置imageView的尺寸确保一屏能显示的下
            imageView.frame.size = scaleSize(size: image.size)
            //imageView居中
            imageView.center = scrollView.center
        }
    }
    
    //获取imageView的缩放尺寸（确保首次显示是可以完整显示整张图片）
    func scaleSize(size:CGSize) -> CGSize {
        let width = size.width
        let height = size.height
        let widthRatio = width/UIScreen.main.bounds.width
        let heightRatio = height/UIScreen.main.bounds.height
        let ratio = max(heightRatio, widthRatio)
        return CGSize(width: width/ratio, height: height/ratio)
    }
    
    //缩放视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    //缩放响应，设置imageView的中心位置
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ?
            scrollView.contentSize.width/2:centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ?
            scrollView.contentSize.height/2:centerY
        imageView.center = CGPoint(x: centerX, y: centerY)
    }
    
    //图片单击事件响应
    @objc func tapSingleDid(_ ges:UITapGestureRecognizer){
        
    }
    
    //图片双击事件响应
    @objc func tapDoubleDid(_ ges:UITapGestureRecognizer){
        //缩放视图（带有动画效果）
        UIView.animate(withDuration: 0.2, animations: {
            //如果当前不缩放，则放大到3倍。否则就还原
            if self.scrollView.zoomScale == 1.0 {
                //以点击的位置为中心，放大3倍
                let pointInView = ges.location(in: self.imageView)
                let newZoomScale:CGFloat = 3
                let scrollViewSize = self.scrollView.bounds.size
                let w = scrollViewSize.width / newZoomScale
                let h = scrollViewSize.height / newZoomScale
                let x = pointInView.x - (w / 2.0)
                let y = pointInView.y - (h / 2.0)
                let rectToZoomTo = CGRect(x:x, y:y, width:w, height:h)
                self.scrollView.zoom(to: rectToZoomTo, animated: true)
            }else{
                self.scrollView.zoomScale = 1.0
            }
        })
    }
    
    //响应长按手势
    @objc func longPress(_ longPress:UILongPressGestureRecognizer) {
        if longPress.state == .began {
            let ac = UIAlertController(title: "您是否要保存该图片", message: "将图片保存到您的相册应用", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "保存", style: .default) {  (ACTION : UIAlertAction) -> Void in
                self.authorityJudgment()
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            ac.addAction(action)
            ac.addAction(cancel)
            var selfCon = UIApplication.shared.keyWindow?.rootViewController
            while ((selfCon?.presentedViewController) != nil)
            {
                selfCon = selfCon?.presentedViewController;
            }
            
            selfCon?.present(ac, animated: true, completion: nil)
        }
    }
    
    //权限判断
    func authorityJudgment() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized: // User has authorized this application to access photos data.
            DispatchQueue.main.async {
                self.savePhoto()
            }
        case .notDetermined://用户之前已授予对相机的访问权限。
            PHPhotoLibrary.requestAuthorization { (granted) in
                switch granted {
                case .authorized:
                    DispatchQueue.main.async {
                        self.savePhoto()
                    }
                default:
                    FTIndicator.showError(withMessage: "请在iPhone的“设置-隐私-照片”中允许访问")
                }
            }
        case .restricted: break//尚未要求用户进行相机访问。
        //            FTIndicator.showError(withMessage: "请在iPhone的“设置-隐私-照片”中允许访问")
        case .denied: //用户先前已拒绝访问。
            FTIndicator.showError(withMessage: "请在iPhone的“设置-隐私-照片”中允许访问")
        }
    }
    
    //保存图片
    func savePhoto() {
        if self.imageView.image == nil {
            return
        }
        let image = self.imageView.image!
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                FTIndicator.showSuccess(withMessage: "保存成功!")
            } else{
                //error!.localizedDescription
                FTIndicator.showError(withMessage: "请在iPhone的“设置-隐私-照片”中允许访问")
            }
        }
    }
}
