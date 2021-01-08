//
//  ViewController.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 12/23/20.
//

import UIKit

typealias ColRect = CGRect
typealias PinchState = UIPinchGestureRecognizer.State // convenience
protocol SectionZoomEmbeddable: UIView {
    var columnWidth: CGFloat { get } // if we wanted to be cute, this could be `func widthOfColumn(at index: UInt)`
    var numberOfColumns: UInt { get}
}

class SectionZoomingView: UIView {

    var numberOfColumns = CGFloat(0)

    lazy var initialTransform: CGAffineTransform = { self.transform }()

    var containedView: UIView = UIView() //this could be set elsewhere

    var initialSize = CGSize.zero

    var fittingScale: CGFloat {
        return self.bounds.width/self.containedView.bounds.width
    }
    public func setup(withContained view: UIView) {
        self.layer.masksToBounds = true
        self.numberOfColumns = 5.0
        self.containedView.removeFromSuperview()
        self.initialSize = view.frame.size

        self.containedView = view
        let widthScale = self.frame.width/view.frame.width
        let heightScale = self.frame.height/view.frame.height
        let scale = min(widthScale, heightScale)
        self.addSubview(view)

        self.containedView.transform = CGAffineTransform.init(scaleX: scale, y: scale)

        self.initialTransform = self.containedView.transform
        self.containedView.layer.position = CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)

        let zoomRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        self.addGestureRecognizer(zoomRecognizer)
        zoomRecognizer.delaysTouchesBegan = false
        let dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.addGestureRecognizer(dragRecognizer)

    }

    @objc
    private func didPinch(_ sender: UIPinchGestureRecognizer) {
        guard sender.scale > 0.01
        else { return }

        if sender.state == .began {
            self.firstPinchPos = sender.location(in: self)
        }
        if [PinchState.began, .changed].contains(sender.state) {
            let center = sender.location(in: self)
            //TODO: Chris Brandow  2021-01-05 NEED inertia when it gets towards a minimum or maximum
            if self.canScale(to: sender.scale) {
                let revisedPt = CGPoint(x: -self.containedView.frame.origin.x + center.x, y: -self.containedView.frame.origin.y + center.y)

                let change = CGPoint(x: center.x - self.firstPinchPos.x, y: center.y + self.firstPinchPos.y) // this makes it drag correctly but pinch zoom is off
                self.containedView.scale(sender.scale, aboutPoint: revisedPt, from: self.initialTransform, change: change)
                self.firstPinchPos = center
        }
        } else if sender.state == .ended || sender.state == .cancelled {
            /// then create method to expand to ColRect.
            let colRect = self.columnRectForResizing()
            self.adjustScaleAndPosition(for: colRect)
        } else  {
            self.containedView.transform = self.initialTransform.scaledBy(x: sender.scale, y: sender.scale)
        }

    }

    var firstPinchPos: CGPoint = .zero
    private func canScale(to scale: CGFloat) -> Bool {
        let currentScale = self.containedView.transform.a
        let lowerLimit = 0.2*self.fittingScale
        let upperLimit = 5.0*self.fittingScale
        let isWithinBounds = currentScale > lowerLimit && currentScale < upperLimit
        let tooBigButShrinking = currentScale >= upperLimit && scale < 1.0
        let tooSmallButGrowing = currentScale <= lowerLimit && scale > 1.0
        return isWithinBounds
            || tooBigButShrinking
            || tooSmallButGrowing
    }

    @objc
    private func didPan(_ sender: UIPanGestureRecognizer) {
        // need to make sure view is still visible
        let translation = sender.translation(in: self)
        if sender.state == .ended {
            let colRect = self.columnRectForResizing()
            self.adjustScaleAndPosition(for: colRect)
            self.initialTransform = self.containedView.transform
        } else if sender.state == .changed {
            self.containedView.transform = self.initialTransform.translatedBy(x: translation.x/self.initialTransform.a, y: translation.y/self.initialTransform.a)
        }
    }

    private func columnRectForResizing() -> ColRect {

        // what should happen here, is that when the view is first added, it should calculate
        let numberOfRows = CGFloat(5)
        let columnWidth = self.containedView.frame.width/self.numberOfColumns
        let rawOriginX = self.containedView.frame.origin.x/columnWidth

        let columnOriginX = Int(round(rawOriginX))

        let columnHeight = self.containedView.frame.height/numberOfRows
        let rawOriginY = self.containedView.frame.origin.y/columnHeight

        let columnOriginY = Int(round(rawOriginY))

        let resizedColumnCount = Int(round(self.numberOfColumns*self.frame.width/self.containedView.frame.width))
        let resizedRowCount = Int(round(numberOfRows*self.frame.height/self.containedView.frame.height))
        return ColRect(x: columnOriginX, y: columnOriginY, width: resizedColumnCount, height: resizedRowCount)
    }

    // this works as far as i've tested, but if the enclosing view is not square then it breaks again
    func adjustScaleAndPosition(for colRect: ColRect) {
        // just thinking through the width aspect
        // if width < frame.width
            // center it
        // else
            // resize the widths
            // if left edge > 0
            // else if right edge < frame.width
            // else snap to left

        //NOTE: need to handle when right edge leaves a gap
            // * either center if width is less than view's width
            // * or shift to right edge
        //NOTE: need to test height and width requrement, tehn scale, depending on aspect ratio of view

        if self.containedView.bounds.height*self.containedView.transform.d <= self.bounds.height
            && self.containedView.bounds.width*self.containedView.transform.a <= self.bounds.width {
            let scale = self.frame.height/self.containedView.bounds.height
            self.animate(transform: CGAffineTransform(scaleX: scale, y: scale))

        } else if self.containedView.frame.width <= self.bounds.width {
            let scaledTx = self.containedView.transform.tx/self.containedView.transform.a
            let pinToUpperEdge = min(-self.containedView.frame.origin.y/self.containedView.transform.a, 0)
            let bottomDiff = self.frame.height - self.containedView.frame.maxY
            let pinToBottomEdge = bottomDiff > 0
                ? bottomDiff/self.containedView.transform.a
                : 0
            let resolvedEdgePin = pinToUpperEdge + pinToBottomEdge // adding works because they can't both be non-zero
            let transform = self.containedView.transform.translatedBy(x: -scaledTx, y: resolvedEdgePin )
            self.animate(transform: transform)
        } else if self.containedView.frame.height <= self.bounds.height {
            let scaledTy = self.containedView.transform.ty/self.containedView.transform.d
            let transform = self.containedView.transform.translatedBy(x: 0, y: -scaledTy)
            self.animate(transform: transform)
        } else {
            let columnWidth = self.containedView.frame.width/self.numberOfColumns
            let targetMaxX = (self.numberOfColumns + colRect.origin.x)*columnWidth
            let areThereRemainingColumnsToTheRight = targetMaxX > self.frame.width
            let shouldAlignRightEdge = (self.containedView.frame.maxX < self.frame.width)
                || (areThereRemainingColumnsToTheRight == false) // if total columns == (left columns

            if columnWidth > self.bounds.width { // just a safeguard for now to prevent it from getting too big
                let scale = (self.bounds.width - 1.0)/columnWidth // the 1.0 is to make it just smaller than needed
                self.containedView.transform = self.containedView.transform.scaledBy(x: scale, y: scale)

            } else {
                let scale = (self.frame.width - 16)/columnWidth
                let roundedScale = round(scale)
                let adjustedScale = scale/roundedScale
                let adjustedFrameWidth = self.containedView.frame.width*adjustedScale
                let finalScale = adjustedFrameWidth/self.initialSize.width
                let scaleAdjustment = finalScale/self.containedView.transform.a

                self.containedView.transform = self.containedView.transform.scaledBy(x: scaleAdjustment, y: scaleAdjustment)
            }
            // if left edge > 0
            // else if right edge < frame.width
            // else snap to left
            let origin: CGPoint
            let correctedOriginX: CGFloat
            let correctedOriginY: CGFloat

            if shouldAlignRightEdge {
                origin = CGPoint(x: -(self.containedView.frame.origin.x - 16.0)/self.containedView.transform.a, y: -(self.containedView.frame.origin.y - 8)/self.containedView.transform.d)
                let columnsPerScreen = CGFloat(Int(self.frame.width/columnWidth))
                correctedOriginX = -(self.numberOfColumns - columnsPerScreen)
                correctedOriginY = 0
            } else if self.containedView.frame.origin.x > 0 {
                origin = CGPoint(x: -(self.containedView.frame.origin.x)/self.containedView.transform.a, y: -(self.containedView.frame.origin.y - 8)/self.containedView.transform.d)
                correctedOriginX = 0
                correctedOriginY = 0
            } else {
                origin = CGPoint(x: -(self.containedView.frame.origin.x - 8)/self.containedView.transform.a, y: -(self.containedView.frame.origin.y - 8)/self.containedView.transform.d)
                correctedOriginX = min(0, colRect.origin.x)
                correctedOriginY = min(0, colRect.origin.y)
            }
            let offset = CGPoint(x: self.containedView.bounds.width/self.numberOfColumns, y: self.containedView.bounds.height/5.0)

            let x = origin.x + correctedOriginX*offset.x
            let y = self.yPosition()

            self.animate(transform: self.containedView.transform.translatedBy(x: x, y: y))
        }

    }

    //no snapping to guides in the y direction, just at the edges
    private func yPosition() -> CGFloat {
        let pinToUpperEdge = min(-self.containedView.frame.origin.y/self.containedView.transform.a, 0)
        let bottomDiff = self.frame.height - self.containedView.frame.maxY
        let pinToBottomEdge = bottomDiff > 0
            ? bottomDiff/self.containedView.transform.a
            : 0
        return pinToUpperEdge + pinToBottomEdge // adding works because they can't both be non-zero
    }

    private func animate(transform: CGAffineTransform) {
        let x = transform.tx/transform.a
        let y = transform.ty/transform.d
        let distance = sqrt(x*x + y*y)
        let animationDuration = TimeInterval(max(0.1, distance*0.1/100))

        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.containedView.transform = transform
        }, completion: { _ in
            self.initialTransform = self.containedView.transform
        })

    }
}

class ViewController: UIViewController {

    @IBOutlet weak var zoomable: SectionZoomingView?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let size = CGSize(width: 800, height: 1600)
        let sectionedView = UIView(frame: CGRect(origin: .zero, size: size))


        let columnCount = 5
        let rowCount = 20
        let smallSize = CGSize(width: size.width/CGFloat(columnCount), height: size.height/CGFloat(rowCount))
        for i in 0..<columnCount {
            for j in 0..<rowCount {
                let x = CGFloat(i)*smallSize.width
                let addView = UIView(frame: CGRect(x: x, y: CGFloat(j)*smallSize.height + CGFloat(i)*CGFloat(j), width: smallSize.width, height: smallSize.height + CGFloat(i)))
                addView.backgroundColor = UIColor(white: (0.95 - (1+CGFloat(i))*(CGFloat(j)+1)/CGFloat(120)), alpha: 1.0)
                let label = UILabel(frame: addView.bounds)
                label.text = String(describing: i*rowCount + j)
                addView.addSubview(label)
                sectionedView.addSubview(addView)
            }
        }
        let lastFrame = sectionedView.subviews.reduce(CGPoint.zero) { CGPoint(x: max($0.x, $1.frame.maxX), y: max($0.y, $1.frame.maxY)) }
        sectionedView.frame = CGRect(origin: .zero, size: CGSize(width: lastFrame.x, height: lastFrame.y))
        self.zoomable?.setup(withContained: sectionedView)

    }
    @IBAction func buttonAction(_ sender: UIButton) {

    }

}

public extension UIView {


    // this still isn't correct.
    func scale(_ scale:CGFloat, aboutPoint point:CGPoint, from startingTransfrom: CGAffineTransform? = nil, change: CGPoint) {
        var center = point
        center.x -= self.frame.midX
        center.y -= self.frame.midY
//        let adjust = CGPoint(x: point.x*scale, y: point.y*scale)
//        let transAdjust = CGPoint(x: point.x - adjust.x, y: point.y - adjust.y + (startingTransfrom ?? self.transform).ty)
        var transform = (startingTransfrom ?? self.transform).translatedBy(x: center.x, y: center.y )
        transform = transform.scaledBy(x: scale, y: scale)
        var adjustedCenter = CGPoint(x: center.x/scale, y: center.y/scale) // dividing by scale handles case where user has pinched and then drags both fingers
        
//        adjustedCenter.x += self.frame.midX
//        adjustedCenter.y += self.frame.midY

        transform = transform.translatedBy(x: -adjustedCenter.x + change.x, y: -adjustedCenter.y + change.y)
//        NSLog("%.1f, %.1f -- %.2f", point.y, transAdjust.y, self.transform.ty)

        self.transform = transform
    }
}

class LaunchVC: UIViewController {
    var didLaunchOnce = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.didLaunchOnce == false else {
            return
        }
        self.didLaunchOnce = true
        self.performSegue(withIdentifier: "showZoomable", sender: self)
    }
}

