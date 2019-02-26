//
//  ViewController.swift
//  FEditor
//
//  Created by Yizhe.Zhang on 2019/2/26.
//  Copyright © 2019 com.yizheyun. All rights reserved.
//

import UIKit
import Aztec

class ViewController: UIViewController {
    @IBOutlet weak var textCanvasView: UIView!
    
    let textView = Aztec.TextView(defaultFont: Constants.defaultContentFont, defaultMissingImage: Constants.defaultMissingImage)
    
    lazy var formatBar: Aztec.FormatBar = {
        return self.createToolbar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textView.delegate = self
        initView()
    }
    
    func initView() {
       
        textView.frame = textCanvasView.frame
        
        textCanvasView.addSubview(textView)
    }
    
    
    func createToolbar() -> Aztec.FormatBar {
        let mediaItem = makeToolbarButton(identifier: .media)
        let scrollableItems = scrollableItemsForToolbar
        let overflowItems = overflowItemsForToolbar //更多操作
        
        let toolbar = Aztec.FormatBar()
        
        toolbar.tintColor = .gray
        toolbar.highlightedTintColor = .blue
        toolbar.selectedTintColor = view.tintColor
        toolbar.disabledTintColor = .lightGray
        toolbar.dividerTintColor = .gray
        
        toolbar.overflowToggleIcon = UIImage(named: "missingImage")!
        toolbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44.0)
        toolbar.autoresizingMask = [ .flexibleHeight ]
        toolbar.formatter = self
        
        toolbar.leadingItem = mediaItem
        toolbar.setDefaultItems(scrollableItems, overflowItems: overflowItems)
        toolbar.overflowToolbar(expand: true)
        
//        toolbar.setDefaultItems(scrollableItems) // 一次性全部显示
        
        toolbar.barItemHandler = { [weak self] item in
//            self?.handleAction(for: item)
        }
        
        toolbar.leadingItemHandler = { [weak self] item in
//            self?.showImagePicker()
        }
        
        return toolbar
    }
    
    func makeToolbarButton(identifier: FormattingIdentifier) -> FormatBarItem {
        let button = FormatBarItem(image:  identifier.iconImage, identifier: identifier.rawValue)
//        button.accessibilityLabel = identifier.accessibilityLabel
//        button.accessibilityIdentifier = identifier.accessibilityIdentifier
        return button
    }

    var scrollableItemsForToolbar: [FormatBarItem] {
        let headerButton = makeToolbarButton(identifier: .p)
        
        var alternativeIcons = [String: UIImage]()
        let headings = Constants.headers.suffix(from: 1) // Remove paragraph style
        for heading in headings {
            alternativeIcons[heading.formattingIdentifier.rawValue] = heading.iconImage
        }
        
        headerButton.alternativeIcons = alternativeIcons
        
        
        let listButton = makeToolbarButton(identifier: .unorderedlist)
        var listIcons = [String: UIImage]()
        for list in Constants.lists {
            listIcons[list.formattingIdentifier.rawValue] = list.iconImage
        }
        
        listButton.alternativeIcons = listIcons
        
        return [
            headerButton,
            listButton,
            makeToolbarButton(identifier: .blockquote),
            makeToolbarButton(identifier: .bold),
            makeToolbarButton(identifier: .italic),
            makeToolbarButton(identifier: .link)
        ]
    }
    
    var overflowItemsForToolbar: [FormatBarItem] {
        return [
            makeToolbarButton(identifier: .underline),
            makeToolbarButton(identifier: .strikethrough),
            makeToolbarButton(identifier: .code),
            makeToolbarButton(identifier: .horizontalruler),
            makeToolbarButton(identifier: .more),
            makeToolbarButton(identifier: .sourcecode)
        ]
    }

}

// 输入框代理
extension ViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        textView.inputAccessoryView = formatBar
        
        return true
    }
}

// 标准样式
extension ViewController {
    struct Constants {
        static let defaultContentFont   = UIFont.systemFont(ofSize: 14)
        static let defaultHtmlFont      = UIFont.systemFont(ofSize: 24)
        static let defaultMissingImage  = UIImage(named: "missingImage")!
        static let formatBarIconSize    = CGSize(width: 20.0, height: 20.0)
        static let headers              = [Header.HeaderType.none, .h1, .h2, .h3, .h4, .h5, .h6]
        static let lists                = [TextList.Style.unordered, .ordered]
        static let moreAttachmentText   = "more"
        static let titleInsets          = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
}

// MARK: - Format Bar Delegate

extension ViewController : Aztec.FormatBarDelegate {
    func formatBarTouchesBegan(_ formatBar: FormatBar) {
    }
    
    func formatBar(_ formatBar: FormatBar, didChangeOverflowState state: FormatBarOverflowState) {
        switch state {
        case .hidden:
            print("Format bar collapsed")
        case .visible:
            print("Format bar expanded")
        }
    }
}

// 拓展键盘图标
extension FormattingIdentifier {
    var iconImage: UIImage {
        
        switch(self) {
        case .media:
            return UIImage(named: "missingImage")!
        case .p:
            return UIImage(named: "missingImage")!
        case .bold:
            return UIImage(named: "missingImage")!
        case .italic:
            return UIImage(named: "missingImage")!
        case .underline:
            return UIImage(named: "missingImage")!
        case .strikethrough:
            return UIImage(named: "missingImage")!
        case .blockquote:
            return UIImage(named: "missingImage")!
        case .orderedlist:
            return UIImage(named: "missingImage")!
        case .unorderedlist:
            return UIImage(named: "missingImage")!
        case .link:
            return UIImage(named: "missingImage")!
        case .horizontalruler:
            return UIImage(named: "missingImage")!
        case .sourcecode:
            return UIImage(named: "missingImage")!
        case .more:
            return UIImage(named: "missingImage")!
        case .header1:
            return UIImage(named: "missingImage")!
        case .header2:
            return UIImage(named: "missingImage")!
        case .header3:
            return UIImage(named: "missingImage")!
        case .header4:
            return UIImage(named: "missingImage")!
        case .header5:
            return UIImage(named: "missingImage")!
        case .header6:
            return UIImage(named: "missingImage")!
        case .code:
            return UIImage(named: "missingImage")!
        default:
            return UIImage(named: "missingImage")!
        }
    }
}

// MARK: - Header and List presentation extensions

private extension Header.HeaderType {
    var formattingIdentifier: FormattingIdentifier {
        switch self {
        case .none: return FormattingIdentifier.p
        case .h1:   return FormattingIdentifier.header1
        case .h2:   return FormattingIdentifier.header2
        case .h3:   return FormattingIdentifier.header3
        case .h4:   return FormattingIdentifier.header4
        case .h5:   return FormattingIdentifier.header5
        case .h6:   return FormattingIdentifier.header6
        }
    }
    
    var description: String {
        switch self {
        case .none: return NSLocalizedString("Default", comment: "Description of the default paragraph formatting style in the editor.")
        case .h1: return "Heading 1"
        case .h2: return "Heading 2"
        case .h3: return "Heading 3"
        case .h4: return "Heading 4"
        case .h5: return "Heading 5"
        case .h6: return "Heading 6"
        }
    }
    
    var iconImage: UIImage? {
        return UIImage(named: "missingImage")!
    }
}
private extension TextList.Style {
    var formattingIdentifier: FormattingIdentifier {
        switch self {
        case .ordered:   return FormattingIdentifier.orderedlist
        case .unordered: return FormattingIdentifier.unorderedlist
        }
    }
    
    var description: String {
        switch self {
        case .ordered: return "Ordered List"
        case .unordered: return "Unordered List"
        }
    }
    
    var iconImage: UIImage? {
        return UIImage(named: "missingImage")!
    }
}

