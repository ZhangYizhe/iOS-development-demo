//
//  VideoRightDetail.swift
//  VideoMacDemo
//
//  Created by Yizhe.Zhang on 2019/4/9.
//  Copyright © 2019 cn.yizheyun. All rights reserved.
//

import Cocoa

class VideoRightDetailController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {
    
    
    var videoWindowDelegate : VideoWindowController?
    
    var selectBtn = 0
    @IBOutlet weak var courseBtn: NSButton!
    @IBOutlet weak var commentBtn: NSButton!
    @IBOutlet weak var noteBtn: NSButton!
    @IBOutlet weak var horizontalLineView: NSView!
    

    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(VideoRightDetailItemsCourseItem.self, forItemWithIdentifier:NSUserInterfaceItemIdentifier(rawValue: "VideoRightDetailItemsCourseItem"))
        self.collectionView.register(VideoRightDetailItemCommentSendItem.self, forItemWithIdentifier:NSUserInterfaceItemIdentifier(rawValue: "VideoRightDetailItemCommentSendItem"))
        self.collectionView.register(VideoRightDetailItemCommentItem.self, forItemWithIdentifier:NSUserInterfaceItemIdentifier(rawValue: "VideoRightDetailItemCommentItem"))
        
        
        
        
        collectionView.backgroundColors = [NSColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)]
        
        initView()
    }
    
    func initView() {
        openAndCloseBtn.isBordered = false //Important
        openAndCloseBtn.wantsLayer = true
        openAndCloseBtn.layer?.backgroundColor = NSColor.init(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        
        selectButton()
        
        horizontalLineView.wantsLayer = true
        horizontalLineView.layer?.backgroundColor = NSColor.white.cgColor
        
        
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        if selectBtn == 0 {
            return 2
        } else {
            return 2
        }
    }
    
    // header头高度
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        if selectBtn == 0 {
            return NSSize(width: collectionView.bounds.width - 20, height: 37)
        } else {
            return NSSize(width: collectionView.bounds.width - 20, height: 0)
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        if selectBtn == 0 {
            let headerView = collectionView.makeSupplementaryView(ofKind:NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "VideoRightDetailHeadersCourseView"), for: indexPath)
            
            return headerView
        } else {
            return NSView()
        }
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectBtn == 0 {
            return 3
        } else {
            if section == 0 {
                return 1
            } else {
                return 100
            }
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if selectBtn == 0 {
            let item = collectionView.makeItem(withIdentifier:NSUserInterfaceItemIdentifier(rawValue: "VideoRightDetailItemsCourseItem"), for: indexPath)
            return item
        } else {
            if indexPath.section == 0 {
                let item = collectionView.makeItem(withIdentifier:NSUserInterfaceItemIdentifier(rawValue: "VideoRightDetailItemCommentSendItem"), for: indexPath)
                return item
            } else {
                let item = collectionView.makeItem(withIdentifier:NSUserInterfaceItemIdentifier(rawValue: "VideoRightDetailItemCommentItem"), for: indexPath)
                return item
            }
        }
        
    }

    
    @IBAction func selectBtnTap(_ sender: NSButton) {
        selectBtn = sender.tag
        selectButton()
    }
    
    func selectButton() {
        setButtonColor(&courseBtn)
        setButtonColor(&commentBtn)
        setButtonColor(&noteBtn)
        collectionView.reloadData()
    }
    
    func setButtonColor(_ button : inout NSButton) {
        if button.tag == selectBtn {
            button.contentTintColor = NSColor.white
        } else {
            button.contentTintColor = NSColor.init(white: 1, alpha: 0.8)
        }
        
        button.isBordered = false //Important
        button.wantsLayer = true
        button.layer?.backgroundColor = NSColor.init(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
    }
    
    @IBOutlet weak var openAndCloseBtn: NSButton!
    @IBAction func openAndCloseBtnTap(_ sender: NSButton) {
        var test : CGFloat = 0
        if self.view.animator().frame.minX == (videoWindowDelegate?.window?.frame.width ?? 0) - 20 {
            test = (videoWindowDelegate?.window?.frame.width ?? 0) - 400
        } else {
            test = (videoWindowDelegate?.window?.frame.width ?? 0) - 20
        }
        NSAnimationContext.runAnimationGroup({ (_) in
            NSAnimationContext.current.duration = 0.25
            
            self.view.animator().frame = CGRect(x: test, y: 0, width: 400, height: self.view.frame.height)
        })
    }
}

extension VideoRightDetailController: NSCollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        if selectBtn == 0 {
            return NSSize(width: self.view.frame.width - 20 , height: 37)
        } else {
            if indexPath.section == 0 {
                return NSSize(width: self.view.frame.width - 20 , height: 200)
            } else {
                let test = NSTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 100, height: CGFloat.greatestFiniteMagnitude))

                test.isBezeled = false
                test.isEditable = false
                test.cell?.wraps = true
                test.cell?.truncatesLastVisibleLine = true
                test.maximumNumberOfLines = 3
                                test.stringValue = "asldfkajsdflaksjfsalkfjsaflkasjdfalsdjfaslkdfjasldkfsalkfajsdlfajsdfljslfasjflkasjfasdlkfjasljflsa"
                test.sizeToFit()
                print(test.intrinsicContentSize.height)
                
                return NSSize(width: self.view.frame.width - 20 , height: test.frame.height + 74)
            }
        }
    }
    
    // cell上下距离
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
