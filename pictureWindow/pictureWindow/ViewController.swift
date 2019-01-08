//
//  ViewController.swift
//  pictureWindow
//
//  Created by Yizhe.Zhang on 2018/12/28.
//  Copyright © 2018 cn.yygdz. All rights reserved.
//

import UIKit


class ViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var index = 0
    let images = ["https://desk-fd.zol-img.com.cn/t_s2880x1800c5/g5/M00/08/05/ChMkJlwQ_02IGzDxAAovW7UFYOsAAtvVgMq0OoACi9z517.jpg","http://imgsrc.baidu.com/forum/pic/item/67819e4543a98226f80619338782b9014b90eba0.jpg","https://desk-fd.zol-img.com.cn/t_s1920x1080c5/g5/M00/08/05/ChMkJlwQ_1aIHg_-AAG7zbkIgxcAAtvVwAbSkQAAbvl491.jpg"]
    var dataSouceController = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        self.view.backgroundColor = .black
        
        //底部控件
        initBottomPageView()
        
        for image in images {
            dataSouceController.append(getViewController(imageUrl:image))
        }
        
        //设置首页
        if index < dataSouceController.count && index >= 0  {
            setBottomPage(num: index)
            let viewController = dataSouceController[index]
            setViewControllers([viewController],direction: .forward,animated: true,completion: nil)
        }else{
            index = 0
            setBottomPage(num: index)
            let viewController = dataSouceController[index]
            setViewControllers([viewController],direction: .forward,animated: true,completion: nil)
        }

    }
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataSouceController.index(of: viewController) else {
            return nil
        }
        
        if index - 1 < 0 {
            return nil
        }
        
        return dataSouceController[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataSouceController.index(of: viewController) else {
            return nil
        }
        
        if index  >= dataSouceController.count - 1 {
            return nil
        }
        
        return dataSouceController[index + 1]
    }
    
    func getViewController(imageUrl: String) -> UIViewController {
        let imageViewController = ImagePreviewViewController()
        imageViewController.imageUrl = imageUrl
        return imageViewController
    }
    
    
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        //                print(pendingViewControllers.count)
//        guard let index = dataSouceController.index(of: pendingViewControllers[0]) else {
//            print("error")
//            return
//        }
//        setBottomPage(num: index)
////        if index == dataSouceController.count - 1 {
////            for image in imageArr {
////                dataSouceController.append(getViewController(imageUrl:image))
////            }
////        }
//
//    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let previousIndex = dataSouceController.index(of: previousViewControllers[0]) else {
            print("error")
            return
        }
        if finished || completed {
            if !completed {
                index = previousIndex
                setBottomPage(num: index)
            }else{
                setBottomPage(num: index)
            }
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let pendingIndex = dataSouceController.index(of: pendingViewControllers[0]) else {
            print("error")
            return
        }
        index = pendingIndex
    }
    
    //底部页数空间
    let bottomBtn = UIButton(type: .custom)
    func initBottomPageView() {
        //        bottomBtn.setTitle("1 \\ \(imageArr.count)", for: .normal)
        bottomBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        bottomBtn.contentEdgeInsets.left = 15
        bottomBtn.contentEdgeInsets.right = 15
        bottomBtn.contentEdgeInsets.top = 5
        bottomBtn.contentEdgeInsets.bottom = 5
        bottomBtn.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height - 70), size: bottomBtn.intrinsicContentSize)
        bottomBtn.center.x = self.view.center.x
        bottomBtn.tintColor = .white
        bottomBtn.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        bottomBtn.layer.borderWidth = 1
        bottomBtn.layer.borderColor = UIColor.black.cgColor
        bottomBtn.layer.cornerRadius = 5
        bottomBtn.layer.masksToBounds = true
        self.view.addSubview(bottomBtn)
    }
    
    func setBottomPage(num: Int) {
        bottomBtn.setTitle("\(num + 1)  \\  \(dataSouceController.count)", for: .normal)
        bottomBtn.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height - 70), size: bottomBtn.intrinsicContentSize)
        bottomBtn.center.x = self.view.center.x
    }
    

    
    
}

