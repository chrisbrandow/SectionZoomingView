//
//  ZoomingMenuViewStructures.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 11/1/22.
//

import UIKit

typealias ColRect = CGRect

extension ColRect {

    static func columnRectForResizing(sectionedView: SectionedView, in scrollView: UIScrollView) -> ColRect {
        let contentSize = scrollView.contentSize
        let origin = scrollView.contentOffset
        let columnCount = sectionedView.numberOfColumns
        // what should happen here, is that when the view is first added, it should calculate
        let numberOfColumns = CGFloat(columnCount)
        let columnWidth = contentSize.width/numberOfColumns
        let rawOriginX = origin.x/columnWidth

        let columnOriginX = Int(round(rawOriginX))

        let columnHeight = contentSize.height/numberOfColumns
        let rawOriginY = origin.y/columnHeight

        let columnOriginY = Int(round(rawOriginY))

        let resizedColumnCount = Int(round(numberOfColumns*scrollView.frame.width/contentSize.width))
        let resizedRowCount = Int(round(numberOfColumns*scrollView.frame.height/contentSize.height))
        return ColRect(x: columnOriginX, y: columnOriginY, width: resizedColumnCount, height: resizedRowCount)
    }
}

struct SectionedView {
    var bigIsVisible = true
    let view: UIView
    let numberOfColumns: Int
    let margin: CGFloat
    public func parentWillAnimate(numberOfColumnsTo newColumnCount: Int, from oldColumnCount: Int, with animation: (() ->()), completion: (() ->())) {
        /// this is wrong. i need to provide the animation blocks, not receive them.
        // this is for modifying my own view based on what's happening
        // also need a method for search
        // also need a method for "is zooming"
    }

    @discardableResult
    func highlight(text: String) -> Bool {
        guard text.count > 2 else {
            self.view.subviews
                .compactMap({ ($0 as? EntryView) ?? $0.subviews.first as? EntryView })
                .forEach ({ $0.configure(style: .normal) })
            return false
        }
        // would be nice to be able to create plural/singular variant
        // would be nice to have a dictionary of words that would highlight specific items based
        // on generic words like
        //TODO: Chris Brandow  2021-02-10 need to deal with section headers
        var isAnyHighlighted = false
        for entryView in self.view.subviews.compactMap({ ($0 as? EntryView) ?? $0.subviews.first as? EntryView }) {
            entryView.configure(style: .normal)
            if entryView.item?.name.lowercased().contains(text.lowercased()) == true {
                entryView.configure(style: .highlightTitle(text: text))
                isAnyHighlighted = true
            }
            if entryView.item?.itemDescription?.lowercased().contains(text.lowercased()) == true {
                entryView.configure(style: .highlightDescription(text: text))
                isAnyHighlighted = true
            }
        }
        return isAnyHighlighted
    }

    func setButtons(enabled: Bool) {
        for entryView in self.view.subviews.compactMap({ ($0 as? EntryView) ?? $0.subviews.first as? EntryView }) {
            entryView.button.isEnabled = enabled
        }
    }

    mutating
    func setStyle(columnCount: Int) {
        let e = self.view.subviews.first() { $0 is EntryView } as? EntryView
        let isVisible = e?.bigTitleLabel.layer.opacity == 1
        if columnCount <= 2, isVisible {
            self.configure(for: .normal)
        } else if columnCount > 2,
                  isVisible == false {
            self.configure(for: .compressed)
        }
    }

    func configure(for style: EntryMagnificationStyle) {
        let views = self.view.subviews
            .compactMap({ ($0 as? EntryView) ?? $0.subviews.first as? EntryView })
        UIView.animate(withDuration: 0.18) {
            views.forEach ({ aView in aView.configure(compression: style) })
        }
    }
}

enum EntryViewStyle {
    case normal
    case highlightDescription(text: String)
    case highlightTitle(text: String)
}

enum EntryMagnificationStyle {
    case normal
    case compressed
}

extension EntryView {

    func configure(compression style: EntryMagnificationStyle) {
        switch style {
        case .normal:
            self.bigTitleLabel.layer.opacity = 0.0
            self.titleLabel.layer.opacity = 1.0
            self.descriptionLabel.layer.opacity = 1.0
            self.priceLabel.layer.opacity = 1.0
        case .compressed:
            self.bigTitleLabel.layer.opacity = 1.0
            self.titleLabel.layer.opacity = 0.0
            self.descriptionLabel.layer.opacity = 0.0
            self.priceLabel.layer.opacity = 0.0
        }
    }
    func configure(style: EntryViewStyle) {
        switch style {
        case .normal:
            self.backgroundColor = .otk_white
            self.titleLabel.textColor = .otk_ashDarker
            self.descriptionLabel.textColor = .otk_ashLight
            self.descriptionLabel.text = self.descriptionLabel.text
            self.titleLabel.text = self.titleLabel.text
        case let .highlightDescription(text):
            self.backgroundColor = .otk_greenLighter
            self.descriptionLabel.textColor = .otk_ashDarker
            self.descriptionLabel.setHightlightedString(tintColor: UIColor.otk_red, tintingString: text)
        case let .highlightTitle(text):
            self.descriptionLabel.textColor = .otk_ashDark
            self.backgroundColor = .otk_greenLighter
            self.titleLabel.setHightlightedString(tintColor: UIColor.otk_red, tintingString: text)
        }
    }
}

extension UILabel {

    public func setHightlightedString(tintColor: UIColor, tintingString: String) {
        guard let string = self.text,
              string.isEmpty == false
        else { return }
        let tintRange = NSString(string: (self.text ?? "").lowercased()).range(of: tintingString.lowercased())
        let mutable = NSMutableAttributedString(string: string, attributes: [
            .font: self.font as Any,
            .foregroundColor: self.textColor as Any
        ])
        mutable.addAttributes([
            .font: UIFont.boldSystemFont(ofSize: self.font.pointSize),
            .foregroundColor: tintColor
        ], range: tintRange)
        print(mutable)
        self.attributedText = (mutable.copy() as? NSAttributedString) ?? NSAttributedString()
    }
}

typealias PinchState = UIPinchGestureRecognizer.State // convenience

protocol ZoomableViewProvider: class {
    func zoomableView(for frame: CGRect) -> SectionedView
}

