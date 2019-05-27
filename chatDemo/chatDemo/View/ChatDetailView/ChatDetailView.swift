//
//  ChatDetailView.swift
//  chatDemo
//
//  Created by 张艺哲 on 2019/5/25.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class ChatDetailView: NSViewController, NSWindowDelegate, NSCollectionViewDelegate, NSCollectionViewDataSource {

    let collectionView = AutoItemSizeCollectionView()
    let collectionScrollView = NSScrollView()
    
    let inputCanvasView = NSView()
    let inputTextViewBGCanvas = NSView()
    let inputTextView = ChatDetailTextView()
    let inputTextViewScroll = NSScrollView()
    var inputAttributedHeight : CGFloat = 0
    
    var contentArr = [[
        "每天早上，我的母亲总是先于我醒来，她会先准备好我的午餐，然后出门。 ",
        "每天傍晚，我的母亲",
        "会在外面吃过晚餐之后才回家，静静",
        "地梳洗完毕",
        "后就又回到属于她的房",
        "间，打开",
        "收音",
        "机关上房门，在晚上九点睡去。 ",
        "我们生活在相同的空间里，但几十年来，我们就像是同个屋檐下的陌生人，唯一的交集是她为我准备的吃食，我们之间没有嘘寒问暖、没有母女间的心里话、没有“我爱你”。 ",
        "我爱你",
        "这天，我终于鼓起勇气与她开启对话，但我真的准备去好面对她将给出的答案了吗？ ",
        "我们又是否都能够好好面对那些已经被埋藏许久的过去？"
        ]
        ] {
        didSet {
            guard let lfkasjl : ChatDetailCollectionviewFlowLayout = collectionView.collectionViewLayout as? ChatDetailCollectionviewFlowLayout else {return}
            lfkasjl.contentArr = contentArr
            
            var indexPathItems : Set<IndexPath> = []
            indexPathItems.insert(IndexPath(item: contentArr[contentArr.count - 1].count - 1, section: contentArr.count - 1))
            
            self.collectionView.reloadItems(at: indexPathItems)
            self.view.displayIfNeeded()
            
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 0.3
            NSAnimationContext.current.allowsImplicitAnimation = true
            collectionView.animator().scrollToItems(at: indexPathItems, scrollPosition: .bottom)
            NSAnimationContext.endGrouping()

            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        collectionView.collectionViewLayout?.invalidateLayout()
        self.view.window?.delegate = self
    }
    
    func windowDidResize(_ notification: Notification) {
        updateInputView()
    }
    


    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return contentArr.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArr[section].count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChatDetailTextItem"), for: indexPath) as! ChatDetailTextItem
        if indexPath.item % 2 == 1 {
            item.from = .right
        } else {
            item.from = .left
        }
        item.content = contentArr[indexPath.section][indexPath.item]
        return item
    }

}

extension ChatDetailView {
    func initView() {
        self.view.setBackgroundColor(.white)
        
        initInputView()
        
        collectionScrollView.scrollerStyle = .overlay
        self.view.addSubview(collectionScrollView)
        collectionScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(inputCanvasView.snp.top)
        }
        
        initCollectionView()
        
    }
    
    func initCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = ChatDetailCollectionviewFlowLayout()
        layout.sectionInset = NSEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.minimumInteritemSpacing = 10 // item之间距离
        layout.contentArr = contentArr
        collectionView.collectionViewLayout = layout
        collectionScrollView.documentView = collectionView
        
        collectionView.register(ChatDetailTextItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChatDetailTextItem"))
        
    }
    
    func initInputView() {
        self.view.addSubview(inputCanvasView)
        self.inputCanvasView.addSubview(inputTextViewBGCanvas)
        self.inputTextViewBGCanvas.addSubview(inputTextViewScroll)
        
        inputCanvasView.setBackgroundColor(.init(hex: "#f0f0f0"))
        inputCanvasView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(inputTextViewBGCanvas).offset(20)
        }
        
        inputTextViewBGCanvas.setBackgroundColor(.white)
        inputTextViewBGCanvas.layer?.borderColor = NSColor.init(hex: "#cccccc").cgColor
        inputTextViewBGCanvas.layer?.borderWidth = 1
        inputTextViewBGCanvas.layer?.cornerRadius = 14
        inputTextViewBGCanvas.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-30)
            make.height.equalTo(inputTextViewScroll).offset(10)
        }
        
        inputTextView.textStorage?.mutableString.setString("")
        inputTextView.textStorage?.append("".toAttributedByLineSpacing)
        inputTextView.textColor = .black
        inputTextView.font = .systemFont(ofSize: 13, weight: .regular)
        
        inputTextView.inputCompletion = { [weak self] in
            guard let self = self else {
                return
            }
            self.updateInputView()
        }
        
        // 按下回车
        inputTextView.enterCompletion = { [weak self] content in
            guard let self = self else {
                return
            }
            
            self.contentArr[0].append(content)
        }

        inputTextView.frame.size.width = inputTextViewScroll.bounds.width
        
        inputTextViewScroll.documentView = inputTextView
        
        inputTextView.enclosingScrollView?.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-10)
            make.height.equalTo(16)
        }
    }
    
    func updateInputView() {
        
        inputTextView.frame.size.width = inputTextViewScroll.bounds.width
        
        let newInputAttributedHeight = self.inputTextView.attributedString().height(width: self.inputTextView.bounds.width - 10)
        if abs(inputAttributedHeight - newInputAttributedHeight) > 2 {
            inputAttributedHeight = newInputAttributedHeight
        }
        
        if inputAttributedHeight < 16 {
            inputAttributedHeight = 16
        } else if inputAttributedHeight > 96 {
            inputAttributedHeight = 96
        }
        
        self.inputTextView.enclosingScrollView?.snp.updateConstraints { (make) in
            make.height.equalTo(inputAttributedHeight)
            
        }
    }

}
