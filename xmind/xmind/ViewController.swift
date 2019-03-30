//
//  ViewController.swift
//  xmind
//
//  Created by Yizhe.Zhang on 2019/3/28.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate,UIScrollViewDelegate {

    var nodes = NodeModel.node(type: "", location: [0], parent: [], childrens: [], line: CAShapeLayer(), view: nil) // 根标签
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    

    func initView() {
        initCanvas()

        // 创建根标签
        let label = LabelView.sharedLabelView.create(self, view: canvasView, location: [0], title: "根标签", point: CGPoint(x: 0, y: 0)) as! SpecialLabel
        label.addHandle = { [weak self] (result) in
            guard let self = self else { return }
            self.addNode(nodes: &self.nodes, location: result)
            self.createLine(nodes: self.nodes)
        }
        nodes.view = label
        scrollView.setContentOffset(CGPoint(x: (1000 - self.view.frame.width + label.intrinsicContentSize.width) / 2, y: (1000 - self.view.frame.height) / 2), animated: true)
        createLine(nodes: nodes)
    }
    

    // MARK: - 新增标签
    func addNode(nodes: inout NodeModel.node,location: [Int]) {
        var _location = location
        if _location.count > 1 {
            _location.removeFirst()
            return addNode(nodes: &nodes.childrens[_location.first ?? 0], location: _location)
        }
        _location = nodes.location
        _location.append(nodes.childrens.count)
        for i in 0..<nodes.childrens.count{
            if nodes.childrens[i].location.last != i {
                _location[_location.count - 1] = i
            }
        }
        
        let label = LabelView.sharedLabelView.create(self, view: canvasView, location: _location, title: "\(_location)", point: CGPoint(x: nodes.view?.frame.maxX ?? 30, y: nodes.view?.frame.maxY ?? 30)) as! SpecialLabel
        label.addHandle = {[weak self](result) in
            guard let self = self else { return }
            self.addNode(nodes: &self.nodes, location: result)
            self.createLine(nodes: self.nodes)
        }
        label.deleteHandle = { [weak self] (result) in
            guard let self = self else { return }
            self.deleteNode(nodes: &self.nodes, location: result)
            self.createLine(nodes: self.nodes)
        }
        nodes.childrens.insert(NodeModel.node(type: "", location: _location, parent: [nodes], childrens: [], line: CAShapeLayer(), view: label), at: _location.last ?? nodes.childrens.count)
    }
    
    // MARK: - 删除标签及其子标签
    func deleteNode(nodes: inout NodeModel.node, location: [Int]){
        var _location = location
        if _location.count > 2 {
            _location.removeFirst()
            deleteNode(nodes: &nodes.childrens[_location.first ?? 0], location: _location)
            return
        }
        _location.removeFirst()
        deleteAllNode(nodes: nodes.childrens[_location.first ?? 0]) //
        nodes.childrens.remove(at: location.last ?? 0)
    }
    
    // 遍历删除子标签视图
    func deleteAllNode(nodes: NodeModel.node) {
        for node in nodes.childrens{
            deleteAllNode(nodes: node)
        }
        nodes.line.removeFromSuperlayer()
        nodes.view?.removeFromSuperview()
    }

    // MARK:- 创建线标签
    func createLine(nodes : NodeModel.node) {
        for node in nodes.childrens {
            let line = node.line
            var parents: UILabel? = nodes.view
            var children: UILabel? = node.view
            LineView.drawBezier(canvasView, line: line, a: &parents, b: &children)
            if node.childrens.count > 0 {
                createLine(nodes: node)
            }
        }
    }

    // MARK: - 监听并移动标签位置
    @objc func panDid(_ recognizer:UIPanGestureRecognizer){
        guard let touchView = recognizer.view else {
            return
        }
        let point = recognizer.location(in: touchView)
        if touchView.center.y + point.y - touchView.frame.height/2 < UIApplication.shared.statusBarFrame.height {
            return
        }
        touchView.center = CGPoint(x: touchView.center.x + point.x - touchView.frame.width/2, y: touchView.center.y + point.y - touchView.frame.height/2)
    }
    
    // MARK: - 发生标签移动时动态刷新线
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "center" {
            createLine(nodes: nodes)
        }
    }
    
    // MARK: - 创建画布
    var scrollView: UIScrollView!
    let canvasView = UIView()
    func initCanvas() {
        scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.6 //最小比例
        scrollView.maximumZoomScale = 2 //最大比例
        scrollView.delegate = self
        scrollView.frame = self.view.bounds
        canvasView.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        scrollView.contentSize = canvasView.bounds.size
        scrollView.addSubview(canvasView)
        self.view.addSubview(scrollView)
    }

}

extension ViewController {
    // MARK: - 画布放大缩小
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for subview : AnyObject in scrollView.subviews {
            if subview.isKind(of: UIView.self) {
                return subview as? UIView
            }
        }
        return nil
    }
}


