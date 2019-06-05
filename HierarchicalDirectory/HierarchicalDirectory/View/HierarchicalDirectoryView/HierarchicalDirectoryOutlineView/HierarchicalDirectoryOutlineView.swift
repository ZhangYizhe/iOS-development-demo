//
//  HierarchicalDirectoryOutlineView.swift
//  HierarchicalDirectory
//
//  Created by 张艺哲 on 2019/6/5.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class HierarchicalDirectoryOutlineView: NSOutlineView {
    override func makeView(withIdentifier identifier: NSUserInterfaceItemIdentifier, owner: Any?) -> NSView? {
        let view = super.makeView(withIdentifier: identifier, owner: owner)
        
        
        
        if identifier == NSOutlineView.disclosureButtonIdentifier {
           
            if let btnView = view as? NSButton {
                btnView.image = NSImage(named: "Knowledge-detail-right")
                btnView.alternateImage = NSImage(named: "Knowledge-detail-down")
                
                // can set properties of the image like the size
                btnView.image?.size = NSSize(width: 4, height: 7)
                btnView.alternateImage?.size = NSSize(width: 7, height: 4)
            }
        }
        return view
    }
}

class HierarchicalDirectoryOutlineViewNSTableRowView: NSTableRowView {
    
    override func drawSelection(in dirtyRect: NSRect) {
        if self.selectionHighlightStyle != .none {
            NSColor.init(hex: "#F6F6F6").setFill()
            let selectionPath = NSBezierPath(rect: dirtyRect)
            selectionPath.fill()
        }
    }
}
