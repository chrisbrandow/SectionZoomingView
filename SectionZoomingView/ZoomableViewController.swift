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
    let view: UIView
    let numberOfColumns: Int
    let margin: CGFloat
}

typealias PinchState = UIPinchGestureRecognizer.State // convenience

protocol ZoomableViewProvider: class {
    func zoomableView(for frame: CGRect) -> SectionedView
}

class ZoomableViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView?
    var zoomableView: SectionedView?
    weak var zoomableProvider: ZoomableViewProvider?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let scrollview = self.scrollView,
              self.zoomableView == nil
        else { return }
        scrollview.delegate = self
        scrollview.layer.cornerRadius = 8.0
        if let provider = self.zoomableProvider {
            let sectionedView = provider.zoomableView(for: scrollview.frame)
            self.addAndScale(view: sectionedView, to: scrollview)
        }
    }

    func addAndScale(view: SectionedView, to scrollview: UIScrollView) {
        scrollview.subviews.forEach({ $0.removeFromSuperview() })

        scrollview.addSubview(view.view)
        let ratio = scrollview.frame.width/view.view.bounds.width
        scrollview.maximumZoomScale = CGFloat(view.numberOfColumns)*ratio*0.94
        scrollview.minimumZoomScale = ratio*0.95
        scrollview.contentSize = view.view.frame.size
        self.zoomableView = view
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
            self.scrollView?.setZoomScale(1/colRect.width, animated: true)
            CATransaction.setCompletionBlock {
                self.scrollView?.setContentOffset(self.adjustedPoint(for: self.scrollView!, numberOfColumns: self.zoomableView?.numberOfColumns ?? 0), animated: true)
            }
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

