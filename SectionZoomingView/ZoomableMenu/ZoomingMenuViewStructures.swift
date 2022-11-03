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

    // would be nice to be able to create plural/singular variant
    // would be nice to have a dictionary of words that would highlight specific items based
    // on generic words
    //TODO: Chris Brandow  2021-02-10 need to deal with section headers
    func highlight(with text: String, tag: MenuTag) {
        for entryView in view.subviews.compactMap({ ($0 as? EntryView) ?? $0.subviews.first as? EntryView }) {
            entryView.configure(style: .normal)
            if let item = entryView.item {
                if text.count > 2,
                   item.name.lowercased().contains(text.lowercased()) {
                    entryView.configure(style: .highlightViaSearch)
                }

                if text.count > 2,
                   let itemDescription = item.itemDescription,
                   itemDescription.lowercased().contains(text.lowercased()) {
                    entryView.configure(style: .highlightViaSearch)
                }

                if item.attributes.contains(tag.rawValue) {
                    entryView.configure(style: .highlightViaTag(tag))
                }
            }
        }
    }

    func setButtons(enabled: Bool) {
        for entryView in view.subviews.compactMap({ ($0 as? EntryView) ?? $0.subviews.first as? EntryView }) {
            entryView.button.isEnabled = enabled
        }
    }

    mutating
    func setStyle(columnCount: Int) {
        let e = view.subviews.first() { $0 is EntryView } as? EntryView
        let isVisible = e?.bigTitleLabel.layer.opacity == 1
        if columnCount <= 2, isVisible {
            configure(forCompression: .normal)
        } else if columnCount > 2,
                  isVisible == false {
            configure(forCompression: .compressed)
        }
    }

    func configure(forCompression style: EntryMagnificationStyle) {
        let views = view.subviews
            .compactMap({ ($0 as? EntryView) ?? $0.subviews.first as? EntryView })
        UIView.animate(withDuration: 0.18) {
            views.forEach ({ aView in aView.configure(compression: style) })
        }
    }

    func firstEntryView(with id: String) -> EntryView? {
        view
            .subviews
            .compactMap {
                ($0 as? EntryView) ?? $0.subviews.first as? EntryView
            }
            .first(where: { $0.item?.id == id })
    }
}

typealias PinchState = UIPinchGestureRecognizer.State // convenience

protocol ZoomableViewProvider: class {
    func zoomableView(for frame: CGRect) -> SectionedView
}

