//
//  ViewController2.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 1/23/21.
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



class ZoomableViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView?
    var zoomableView: SectionedView?
    weak var zoomableProvider: ZoomableViewProvider?

    var didLayoutOnce = false

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard self.didLayoutOnce == false
        else { return }
        self.didLayoutOnce = true
        self.setupZommableView()
    }

    private func setupZommableView() {
        guard let scrollview = self.scrollView,
              self.zoomableView == nil
        else { return }
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
        doubleTapGR.numberOfTapsRequired = 2
        scrollview.addGestureRecognizer(doubleTapGR)
        scrollview.delegate = self
        scrollview.layer.cornerRadius = 8.0
        if let provider = self.zoomableProvider {
            let sectionedView = provider.zoomableView(for: scrollview.frame)

            self.addAndScale(view: sectionedView, to: scrollview)
            let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(0.6*1000))
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                if let scrollview = self.scrollView,
                   let sectionedView = self.zoomableView {
                    var colRect = ColRect.columnRectForResizing(sectionedView: sectionedView, in: scrollview)
                    colRect.size.width = min(2.0, CGFloat(sectionedView.numberOfColumns))
                    CATransaction.setCompletionBlock {
                        self.zoomableView?.setStyle(columnCount: Int(colRect.width))
                    }
                    UIView.animate(withDuration: 0.4) {
                        self.scrollView?.setZoomScale(1/colRect.width, animated: false)
                        self.scrollView?.setContentOffset(.zero, animated: false)
                    }
                }
            }
        }
        self.scrollView?.clipsToBounds = false
    }

    @objc
    func doubleTapAction(_ sender: UITapGestureRecognizer) {
        if let scrollview = self.scrollView,
           let sectionedView = self.zoomableView {
            var colRect = ColRect.columnRectForResizing(sectionedView: sectionedView, in: scrollview)
            colRect.size.width = 1
            let pt = sender.location(in: scrollview)
            // this fails wrt to x offset, b/c the content size is wrong. probs need to pass the predicted width in
            let origin = self.adjustedPoint(for: scrollview, fromTarget: pt, numberOfColumns: 1)
            CATransaction.setCompletionBlock {
                self.zoomableView?.setStyle(columnCount: Int(colRect.width))
            }
            UIView.animate(withDuration: 0.4) {
                self.scrollView?.setZoomScale(1/colRect.width, animated: false)
                self.scrollView?.setContentOffset(origin, animated: false)
            }
        }

    }

    func addAndScale(view: SectionedView, to scrollview: UIScrollView) {
        scrollview.subviews.forEach({ $0.removeFromSuperview() })

        scrollview.addSubview(view.view)
        let ratio = scrollview.frame.width/view.view.bounds.width
        let accountForMargin = (scrollview.frame.width - 3*Layout.menuItemMargin)/scrollview.frame.width
        scrollview.maximumZoomScale = CGFloat(view.numberOfColumns)*ratio*accountForMargin
        scrollview.minimumZoomScale = ratio*0.95
        scrollview.contentSize = view.view.frame.size

        self.zoomableView = view
        self.zoomableView?.setStyle(columnCount: Int(1))

        scrollview.setZoomScale(1/CGFloat(view.numberOfColumns), animated: false)
    }


    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.zoomableView?.view
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = self.adjustedPoint(for: scrollView, fromTarget: targetContentOffset.pointee, numberOfColumns: self.zoomableView?.numberOfColumns ?? 0)

    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        // pinch gesture recognizer is not added until this delegate method is called, because it seems that the system adds this gesture recognizer as needed
        scrollView.gestureRecognizers?.first(where: { $0 is UIPinchGestureRecognizer})?.addTarget(self, action: #selector(didPinch(_:)))
    }

    @objc
    func didPinch(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended || sender.state == .cancelled,
           let scrollview = sender.view as? UIScrollView,
           let sectionedView = self.zoomableView {
            let colRect = ColRect.columnRectForResizing(sectionedView: sectionedView, in: scrollview)
            self.setZoomable(to: Int(colRect.width))
        }
    }

    public func setZoomableToMaximumCompression() {
        self.setZoomable(to: self.zoomableView?.numberOfColumns ?? 0)
    }

    private func setZoomable(to columnCount: Int) {
        let point = self.adjustedPoint(for: self.scrollView!, numberOfColumns: self.zoomableView?.numberOfColumns ?? 0)
        self.scrollView?.setZoomScale(1/(CGFloat(columnCount)*1.05), animated: true)
        CATransaction.setCompletionBlock {
            self.scrollView?.setContentOffset(point, animated: true)
            self.zoomableView?.setStyle(columnCount: columnCount)
        }
    }

    /// This still needs some work on y, when scrolling to bottom of view
    private func adjustedPoint(for scrollView: UIScrollView, fromTarget point: CGPoint? = nil, numberOfColumns: Int) -> CGPoint {
        var point = point ?? scrollView.contentOffset
        let newWidth = scrollView.contentSize.width
        let floatColumns = CGFloat(numberOfColumns)
        let intX = round(floatColumns*(point.x)/newWidth)
        point.x = newWidth*intX/floatColumns - 4.0
        point.y = min((scrollView.contentSize.height + scrollView.frame.height*0.5)*scrollView.zoomScale, max(0, point.y))
        return point
    }
}

