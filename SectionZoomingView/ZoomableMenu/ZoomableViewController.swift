//
//  ViewController2.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 1/23/21.
//

import UIKit

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
//        (self.parent as? MenuParentViewController)?.pinchToZoomLayer?.removeFromSuperlayer()

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

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        (self.parent as? MenuParentViewController)?.pinchToZoomLayer?.removeFromSuperlayer()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = self.adjustedPoint(for: scrollView, fromTarget: targetContentOffset.pointee, numberOfColumns: self.zoomableView?.numberOfColumns ?? 0)
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        // pinch gesture recognizer is not added until this delegate method is called, because it seems that the system adds this gesture recognizer as needed
        scrollView.gestureRecognizers?.first(where: { $0 is UIPinchGestureRecognizer})?.addTarget(self, action: #selector(didPinch(_:)))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        NSLog("touches began \(touches.first!.location(in: self.view))")
    }
    @objc
    func didPinch(_ sender: UIPanGestureRecognizer) {
//        (self.parent as? MenuParentViewController)?.pinchToZoomLayer?.removeFromSuperlayer()
        if sender.state == .ended || sender.state == .cancelled,
           let scrollview = sender.view as? UIScrollView,
           let sectionedView = self.zoomableView {
            let colRect = ColRect.columnRectForResizing(sectionedView: sectionedView, in: scrollview)
            self.setZoomable(to: Int(colRect.width))
        }
    }

    public func setZoomableToMaximumCompression() {
        self.setZoomable(to: self.zoomableView?.numberOfColumns ?? 0, toOrigin: true)
    }

    private func setZoomable(to columnCount: Int, toOrigin: Bool = false) {
        let point = self.adjustedPoint(for: self.scrollView!, numberOfColumns: self.zoomableView?.numberOfColumns ?? 0, toOrigin: toOrigin)
        self.scrollView?.setZoomScale(1/(CGFloat(columnCount)*1.05), animated: true)
        CATransaction.setCompletionBlock {
            self.scrollView?.setContentOffset(point, animated: true)
            self.zoomableView?.setStyle(columnCount: columnCount)
        }
    }

    /// This still needs some work on y, when scrolling to bottom of view
    private func adjustedPoint(for scrollView: UIScrollView, fromTarget point: CGPoint? = nil, numberOfColumns: Int, toOrigin: Bool = false) -> CGPoint {
        var point = toOrigin ? CGPoint.zero : (point ?? scrollView.contentOffset)
        let newWidth = scrollView.contentSize.width
        let floatColumns = CGFloat(numberOfColumns)
        let intX = round(floatColumns*(point.x)/newWidth)
        point.x = newWidth*intX/floatColumns - 4.0
        point.y = min((scrollView.contentSize.height + scrollView.frame.height*0.5)*scrollView.zoomScale, max(0, point.y))
        return point
    }
}


class PinchCaptureVC: UIViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let descript = touches.map({ "\($0.location(in: self.view).x),\($0.location(in: self.view).y)"})
            .joined(separator: "; ")
        NSLog("touches began 2 \(descript)")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let descript = touches.map({ "\($0.location(in: self.view).x),\($0.location(in: self.view).y)"})
            .joined(separator: "; ")
        NSLog("touches moved \(descript)")
    }
}
