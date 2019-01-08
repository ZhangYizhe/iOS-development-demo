//
//  ViewController.swift
//  MultipleColumns
//
//  Created by Yizhe.Zhang on 2019/1/2.
//  Copyright © 2019 cn.yygdz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bigTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var canvasScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        canvasScrollView.delegate = self
         initView()
    }
    
    func initView() {
        let pageWidth = self.view.frame.width
        let pageHeight = self.view.frame.height
        canvasScrollView.frame = CGRect(x:0, y:0,width:pageWidth, height:pageHeight)
        //为了让内容横向滚动，设置横向内容宽度为3个页面的宽度总和
        canvasScrollView.contentSize = CGSize(width: pageWidth * 3,height: 0)
        canvasScrollView.isPagingEnabled = true
        canvasScrollView.showsHorizontalScrollIndicator = false
        canvasScrollView.showsVerticalScrollIndicator = false
        canvasScrollView.scrollsToTop = false
        
        //回帖页面
        let UserPageRepliesStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let UserPageRepliesVc = UserPageRepliesStoryboard.instantiateViewController(withIdentifier: "UserPageRepliesView") as? UserPageRepliesViewController
        UserPageRepliesVc?.view.frame = CGRect(x:pageWidth*0, y:0,width:pageWidth, height:pageHeight)
        self.addChild(UserPageRepliesVc!)
        UserPageRepliesVc?.delegate = self
        canvasScrollView.addSubview(UserPageRepliesVc!.view)
        
        
        let secView = UIView()
        secView.backgroundColor = .red
        secView.frame = CGRect(x:pageWidth*1, y:0,width:pageWidth, height:pageHeight)
        canvasScrollView.addSubview(secView)
    }
    
    
//    // MARK: - 返回滑动手势
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
//    }
    
    // MARK: - segue 通道
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UserPageRepliesViewController
        vc.delegate = self
    }

}

extension ViewController: SpecialScrollDelegate{
    func  UserPageRepliesView(y: CGFloat)  {
        bigTopConstraint.constant = -y
    }
}

protocol SpecialScrollDelegate {
    func UserPageRepliesView(y: CGFloat)
}
