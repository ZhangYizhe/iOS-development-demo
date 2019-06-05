//
//  NSCollectionViewFlowLayout.swift
//  chatDemo
//
//  Created by 张艺哲 on 2019/5/27.
//  Copyright © 2019 张艺哲. All rights reserved.
//

import Cocoa

class ChatDetailCollectionviewFlowLayout: NSCollectionViewFlowLayout {
    
    var contentBounds = NSRect.zero
    var cachedAttributes = [NSCollectionViewLayoutAttributes]()
    
    var contentArr = [[String]]()
    
    
    override func prepare() {
        super.prepare()
        guard let cv = collectionView else { return }
        
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: CGSize(width: cv.bounds.width, height: .zero))
        
        createAttributes()
        
    }
    
    override var collectionViewContentSize: NSSize {
        return contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        guard let cv = collectionView else { return false }
        return !newBounds.size.equalTo(cv.bounds.size)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
        return cachedAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        return cachedAttributes.filter({ (attributes: NSCollectionViewLayoutAttributes) -> Bool in
            return rect.intersects(attributes.frame)
        })
    }
    
    func createAttributes() {
        guard let cv = collectionView else { return }
        
        for section in 0..<cv.numberOfSections {
            let items = cv.numberOfItems(inSection: section)
            
            // header头尺寸计算
            if headerReferenceSize.height != 0 {
                let header = NSCollectionViewLayoutAttributes(forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                header.frame = CGRect(x: 0, y: contentBounds.height, width: contentBounds.width, height: headerReferenceSize.height)
                cachedAttributes.append(header)
                contentBounds.size.height += header.frame.height
            }
            
            contentBounds.size.height += sectionInset.top
            
            // 项目尺寸计算
            for item in 0..<items {
                let itemWidth : CGFloat = cv.bounds.width - sectionInset.left - sectionInset.right
                let itemHeight : CGFloat = CalculateSize(content:contentArr[section][item], cv: cv).height
                
                
                
                let attributes = NSCollectionViewLayoutAttributes(forItemWith: IndexPath(item: item, section: section))
                
                let x : CGFloat = sectionInset.left
                let y : CGFloat = contentBounds.size.height
                
                attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
                cachedAttributes.append(attributes)
                
                contentBounds.size.height += attributes.frame.height + minimumLineSpacing
            }
            
            contentBounds.size.height -= minimumLineSpacing
            contentBounds.size.height += sectionInset.bottom
            
            // footer尾尺寸计算
            if footerReferenceSize.height != 0 {
                let footer = NSCollectionViewLayoutAttributes(forSupplementaryViewOfKind: NSCollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
                footer.frame = CGRect(x: 0, y: contentBounds.height, width: contentBounds.width, height: footerReferenceSize.height)
                cachedAttributes.append(footer)
                contentBounds.size.height += footer.frame.height
            }
        }
    }
    
    // 计算尺寸
    func CalculateSize(content: String, cv: NSCollectionView) -> NSSize {
        // 高度计算
        let simulateLabel = NSTextField(frame: CGRect(x: 0, y: 0, width: cv.bounds.width * 0.8 - 20, height: CGFloat.greatestFiniteMagnitude))
        simulateLabel.font = NSFont.systemFont(ofSize: 13, weight: .light)
        
        simulateLabel.isEditable = false
        simulateLabel.drawsBackground = false
        simulateLabel.isBordered = false
        simulateLabel.usesSingleLineMode = false
        simulateLabel.lineBreakMode = .byWordWrapping
        
        simulateLabel.stringValue = content
        
        var size = simulateLabel.cell!.cellSize(forBounds: simulateLabel.frame)
        size.height += 10
        return size
    }
}
