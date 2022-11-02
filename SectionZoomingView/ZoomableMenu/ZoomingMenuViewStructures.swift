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
            self.configure(forCompression: .normal)
        } else if columnCount > 2,
                  isVisible == false {
            self.configure(forCompression: .compressed)
        }
    }

    func configure(forCompression style: EntryMagnificationStyle) {
        let views = self.view.subviews
            .compactMap({ ($0 as? EntryView) ?? $0.subviews.first as? EntryView })
        UIView.animate(withDuration: 0.18) {
            views.forEach ({ aView in aView.configure(compression: style) })
        }
    }
}

typealias PinchState = UIPinchGestureRecognizer.State // convenience

protocol ZoomableViewProvider: class {
    func zoomableView(for frame: CGRect) -> SectionedView
}

