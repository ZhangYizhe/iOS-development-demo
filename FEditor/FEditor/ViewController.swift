//
//  ViewController.swift
//  FEditor
//
//  Created by Yizhe.Zhang on 2019/2/26.
//  Copyright © 2019 com.yizheyun. All rights reserved.
//

import UIKit
import Aztec
import WordPressEditor

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
//        let mediaItem = makeToolbarButton(identifier: .media)
        let scrollableItems = scrollableItemsForToolbar
        
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
        
//        toolbar.leadingItem = mediaItem
        toolbar.overflowToolbar(expand: true)
        toolbar.setDefaultItems(scrollableItems)
        
        toolbar.barItemHandler = { [weak self] item in
//            self?.handleAction(for: item)
            
            self!.toggleHeader(fromItem: item)
        }
        
        toolbar.leadingItemHandler = { [weak self] item in
//            self?.showImagePicker()
        }
        
        let hideKeyboardBtnView = UIView()
        hideKeyboardBtnView.frame = CGRect(origin: CGPoint(x: toolbar.frame.width - toolbar.frame.height, y: 0), size: CGSize(width: toolbar.frame.height, height: toolbar.frame.height - 2))
        hideKeyboardBtnView.backgroundColor = toolbar.backgroundColor
        toolbar.addSubview(hideKeyboardBtnView)
        hideKeyboardBtnView.center.y = toolbar.center.y
        
        let test = UIButton()
        test.setImage(UIImage(named: "editor_keyboard_hide")!, for: .normal)
        test.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: test.intrinsicContentSize)
        hideKeyboardBtnView.addSubview(test)
        test.center = CGPoint(x: hideKeyboardBtnView.frame.width / 2, y: hideKeyboardBtnView.frame.height / 2)
        return toolbar
    }
    
    func makeToolbarButton(identifier: FormattingIdentifier) -> FormatBarItem {
        let button = FormatBarItem(image:  identifier.iconImage, identifier: identifier.rawValue)
//        button.accessibilityLabel = identifier.accessibilityLabel
//        button.accessibilityIdentifier = identifier.accessibilityIdentifier
        return button
    }

    // MARK: - Toolbar 菜单初始化
    var scrollableItemsForToolbar: [FormatBarItem] {
        let headerButton = makeToolbarButton(identifier: .media)
        
        var alternativeIcons = [String: UIImage]()
        let headings = Constants.headers.suffix(from: 1) // Remove paragraph style
        for heading in headings {
            alternativeIcons[heading.formattingIdentifier.rawValue] = heading.iconImage
        }
        
        headerButton.alternativeIcons = alternativeIcons
        
        
        let listButton = makeToolbarButton(identifier: .more)
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
            makeToolbarButton(identifier: .link),
            makeToolbarButton(identifier: .underline),
            makeToolbarButton(identifier: .strikethrough),
            makeToolbarButton(identifier: .unorderedlist)
        ]
    }
    
    // MARK: - 字号选择
    
    private lazy var optionsTablePresenter = OptionsTablePresenter(presentingViewController: self, presentingTextView: textView)
    func toggleHeader(fromItem item: FormatBarItem) {
        guard !optionsTablePresenter.isOnScreen() else {
            optionsTablePresenter.dismiss()
            return
        }
        
        let options = Constants.headers.map { headerType -> OptionsTableViewOption in
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: CGFloat(headerType.fontSize))
            ]
            
            let title = NSAttributedString(string: headerType.description, attributes: attributes)
            return OptionsTableViewOption(image: headerType.iconImage, title: title)
        }
        
        let selectedIndex = Constants.headers.index(of: headerLevelForSelectedText())
        let optionsTableViewController = OptionsTableViewController(options: options)
        optionsTableViewController.cellDeselectedTintColor = .gray
        
        optionsTablePresenter.present(
            optionsTableViewController,
            fromBarItem: item,
            selectedRowIndex: selectedIndex,
            onSelect: { [weak self] selected in
                guard let range = self?.textView.selectedRange else {
                    return
                }
                
                self?.textView.toggleHeader(Constants.headers[selected], range: range)
                self?.optionsTablePresenter.dismiss()
        })
    }
    
    func headerLevelForSelectedText() -> Header.HeaderType {
        var identifiers = Set<FormattingIdentifier>()
        if (textView.selectedRange.length > 0) {
            identifiers = textView.formattingIdentifiersSpanningRange(textView.selectedRange)
        } else {
            identifiers = textView.formattingIdentifiersForTypingAttributes()
        }
        let mapping: [FormattingIdentifier: Header.HeaderType] = [
            .header1 : .h1,
            .header2 : .h2,
            .header3 : .h3,
            .header4 : .h4,
            .header5 : .h5,
            .header6 : .h6,
            ]
        for (key,value) in mapping {
            if identifiers.contains(key) {
                return value
            }
        }
        return .none
    }


}

// MARK: - 输入框代理
extension ViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        textView.inputAccessoryView = formatBar
        
        return true
    }
}

// MARK: - 标准样式
extension ViewController {
    struct Constants {
        static let defaultContentFont   = UIFont.systemFont(ofSize: 16)
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

// MARK: - 拓展键盘图标
extension FormattingIdentifier {
    var iconImage: UIImage {
        
        switch(self) {
        case .media:
            return UIImage(named: "editor_media_normal")!
        case .p:
            return UIImage(named: "editor_keyboard_hide")!
        case .bold:
            return UIImage(named: "editor_bold_normal")!
        case .italic:
            return UIImage(named: "editor_italic_normal")!
        case .underline:
            return UIImage(named: "editor_underline_normal")!
        case .strikethrough:
            return UIImage(named: "editor_strikethrough_normal")!
        case .blockquote:
            return UIImage(named: "editor_block_normal")!
        case .orderedlist:
            return UIImage(named: "editor_orderlist_normal")!
        case .unorderedlist:
            return UIImage(named: "editor_unorderlist_normal")!
        case .link:
            return UIImage(named: "editor_link_normal")!
        case .horizontalruler:
            return UIImage(named: "missingImage")!
        case .sourcecode:
            return UIImage(named: "missingImage")!
        case .more:
            return UIImage(named: "editor_heading_normal")!
        case .header1:
            return UIImage()
        case .header2:
            return UIImage()
        case .header3:
            return UIImage()
        case .header4:
            return UIImage()
        case .header5:
            return UIImage()
        case .header6:
            return UIImage()
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
        case .none: return NSLocalizedString("默认", comment: "Description of the default paragraph formatting style in the editor.")
        case .h1: return "字号一"
        case .h2: return "字号二"
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

