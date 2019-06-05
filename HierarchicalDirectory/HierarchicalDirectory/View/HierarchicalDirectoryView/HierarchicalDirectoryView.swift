//
//  HierarchicalDirectoryView.swift
//  HierarchicalDirectory
//
//  Created by 张艺哲 on 2019/6/5.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class HierarchicalDirectoryViewController: NSViewController,NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    @IBOutlet weak var outlineView: NSOutlineView!

    var items = Item()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        items.name = "公司名称"
        
        items.childs = [Item(),Item(),Item()]
        
        items.childs[0] = items
        items.childs[0].childs = [items]
        items.childs[2] = items
        items.childs[2] = items
        items.childs[2] = items
        
        
        initOutlineView()
    }
    
    func initOutlineView() {
        
        outlineView.rowHeight = 36
        outlineView.delegate = self
        outlineView.dataSource = self
        outlineView.action = #selector(onItemClicked)
        
        outlineView.register(NSNib(nibNamed: "HierarchicalDirectoryTableCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HierarchicalDirectoryTableCell"))
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return items
        } else if let item = item as? Item {
            return item.childs[index]
        } else {
            return self
        }
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return 1
        } else if let item = item as? Item {
            return item.childs.count
        } else {
            return 0
        }
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? Item{
            return item.childs.count == 0 ? false : true
        } else {
            return false
        }
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        guard let item = item as? Item else {
            return nil
        }
        
        let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HierarchicalDirectoryTableCell"), owner: self)  as! HierarchicalDirectoryTableCell
        cell.title = item.name
        return cell
    }
    
    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        return HierarchicalDirectoryOutlineViewNSTableRowView()
    }

    @objc private func onItemClicked() {
        
        let clickItem = outlineView.item(atRow: outlineView.clickedRow)
        
        if !outlineView.isItemExpanded(clickItem) {
            outlineView.expandItem(clickItem)
        } else {
            outlineView.collapseItem(clickItem)
        }
    }
    
    struct Item {
        var id : String
        var icon : String
        var name : String
        var childs : [Item]
        
        init() {
            self.id = UUID().uuidString
            self.icon = ""
            self.name = "这里是标题"
            self.childs = []
        }
    }

}


