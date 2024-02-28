//
//  ZoomableContainerView.swift
//  ProtoDisplayLinkMenu
//
//  Created by Chris Brandow on 9/19/22.
//

import UIKit

class ZoomableContainerView: UIView {
    var initialOffset: CGFloat = 0
    var scaleUp = true // diagnostic
    private var contentOffsetAnimation: TimerAnimation?

    var endPinchTime: Date?
    var endPinchTimer: Timer?
    var lastPinchLoc: CGPoint?

    var addedView: ZoomableView?
    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.addedView == nil,
              let aView = createDiagnosticView(for: self)
        else { return }
        self.addZoomingView(aView)
        aView.backgroundColor = .white
        
        // for diagnostic only
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0/UIScreen.main.scale
    }

    public func addZoomingView(_ aView: ZoomableView) {
        self.addedView = aView
        self.setupAddedView(aView)
    }

    private func setupAddedView(_ aView: ZoomableView) {
        self.addedView = aView
        self.clipsToBounds = true
        
        self.addSubview(aView)
        aView.transform = CGAffineTransform(for: aView, toColumn: 0, visibleColumns: 5, verticalOffset: 0)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        pinch.cancelsTouchesInView = false
        let drag = UIPanGestureRecognizer(target: self, action: #selector(dragAction(_:)))
        drag.cancelsTouchesInView = false
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
        doubleTap.cancelsTouchesInView = false
        doubleTap.numberOfTapsRequired = 2
        self.addedView?.addGestureRecognizer(pinch)
        self.addedView?.addGestureRecognizer(drag)
        self.addedView?.addGestureRecognizer(doubleTap)
    }

    /// the touches thing was to handle if the gesture recognizer was not behaving correctly when holding
    /// in place for a long time, but i think that was only a simulator issue. i'm leaving this here for now.
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        NSLog("t began")
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        NSLog("t ended2")
//
//        if let loc = self.lastPinchLoc,
//            let aView = addedView
//        {
//            NSLog("t ended2")
//            self.adjustFrame(for: aView, location: loc)
//        }
//    }
    private func transformAddedView(with transform: CGAffineTransform, animated: Bool, ignoreIncremental: Bool = false, completion: (()->Void)? = nil) {
        guard let aView = addedView
        else { return }
        if ignoreIncremental {
            guard abs(transform.a - aView.transform.a) > 0.01*aView.transform.a,
                  abs(transform.tx - aView.transform.tx) > 0.01*aView.transform.tx,
                  abs(transform.ty - aView.transform.ty) > 0.01*aView.transform.ty
            else { return }
        }

        if animated {
            // this isn't quite right, but it points in right direction. probs need to make
            // animations ease out when scale < 0.6 or something like that.
            aView.gestureRecognizers?.forEach { $0.isEnabled = false }
            // 1 column 0.4, 0.8 seem nice
            // 2 column 0.4, 0.8 seem nice
            // 3 column 0.5, 0.8 seem nice
            // 4 column 0.5, 0.7 seem nice
            // 5 column 0.5, 0.7 seem nice
            let damping: CGFloat = transform.a > 0.4 ? 0.8 : 0.7
            let frameAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: damping)
            frameAnimator.addAnimations { aView.transform = transform }
            frameAnimator.addCompletion { _ in
                aView.gestureRecognizers?.forEach { $0.isEnabled = true }
            }
            frameAnimator.startAnimation()
        } else {
            aView.transform = transform
            completion?()
        }
    }
}

extension ZoomableContainerView {


    @objc
    func dragAction(_ dragGR: UIPanGestureRecognizer) {
        /// currently this does not have any sense of inertia. so when a user flicks it, there's
        /// no ongoing animation
        /// it probably requires the display link animation
        ///
        /// So probably the steps should be
        /// 1. transition to display link animation
        /// 2. do the destination thing
        NSLog("drag")
        guard let aView = self.addedView
        else { return }

        switch dragGR.state {
        case .began:
            self.initialOffset = 0
            dragGR.setTranslation(aView.frame.origin, in: aView.superview)
        case .changed:
            let aFrame = aView.frame
            let aBounds = aView.bounds

            let translation = dragGR.translation(in: aView.superview)
            let newPosition = self.clampedPosition(for: aFrame, translation: translation)
            let transform = CGAffineTransform(from: aBounds, to: CGRect(origin: newPosition, size: aFrame.size))
            self.transformAddedView(with: transform, animated: false)
        case .ended,
                .cancelled:
            let location = dragGR.location(in: aView)
            self.adjustFrame(for: aView, location: location)
        default: return
        }
    }

    private func clampedPosition(for aFrame: CGRect, translation: CGPoint) -> CGPoint {
        let allowedOffsetX = aFrame.width - self.frame.width
        let allowedOffsetY = aFrame.height - self.frame.height
        
        let limitBounds = CGRect(x: -allowedOffsetX, y: -allowedOffsetY, width: allowedOffsetX, height: allowedOffsetY)
        let dims = CGSize(width: 200, height: 50)
        return RubberBand(coeff: 0.3, dims: dims, limits: limitBounds).clamp(translation)
    }

// this is everything i need: https://medium.com/@esskeetit/how-uiscrollview-works-e418adc47060
    // https://github.com/super-ultra/ScrollMechanics/blob/master/ScrollExample/Sources/SimpleScrollView.swift

    /// this is a nice litte demo of lerping: https://rachsmith.com/lerp/
    @objc
    func pinchAction(_ pinchGR: UIPinchGestureRecognizer) {
        NSLog("pinch")
        guard let aView = addedView
        else { return }

        switch pinchGR.state {
        case .changed:
            let location = pinchGR.location(in: aView)
            // create method is currently aligning edge, which we don't want right now. need to fix that
            let transform = self.createTransformForAddedView(withScale: pinchGR.scale, at: location, aligning: false)
            self.transformAddedView(with: transform, animated: false)
            pinchGR.scale = 1.0
            // on the simulator sometimes, when i end a pinch, it does not trigger an end state,
            // the last state is just .change. i have not observed this on an actual devcice
            self.lastPinchLoc = location
            self.endPinchTime = Date()
            NSLog("changed")
        case .ended,
                .cancelled,
                .failed:
            NSLog("finished pinch: \(pinchGR.state.rawValue)")
            self.endPinchTime = nil
            self.lastPinchLoc = nil
            let location = pinchGR.location(in: aView)
            self.adjustFrame(for: aView, location: location)
        default:
            NSLog("default pinch: \(pinchGR.state.rawValue)")
            self.endPinchTime = nil
            self.lastPinchLoc = nil

            return
        }
    }

    private func adjustFrame(for aView: ZoomableView, location: CGPoint) {
        let destinationFrame = aView.destinationFrame(startingAt: location)
        let transform = CGAffineTransform(from: aView.bounds, to: destinationFrame)
        
        self.setNeedsLayout()
        self.transformAddedView(with: transform, animated: true)
    }

    @objc
    func doubleTapAction(_ tapGR: UITapGestureRecognizer) {
        NSLog("d tap")
        switch tapGR.state {
        case .ended:
            let location = tapGR.location(in: self.addedView)
            let currentScale = self.addedView?.transform.a ?? 1.0

            // note: i want aligning, but if a user double taps the leftmost cell in teh right portion,
            // then it will "correctly" align the next cell to the right in the leftmost spot. That doesnt totally make sense
            // so double tapping should actually translate the location to teh center before for scaling/aligning it
            let newScale = (currentScale == 0.5 ? 1.0 : 0.5)/currentScale
            let transform = self.createTransformForAddedView(withScale: newScale, at: location, aligning: true)
            self.transformAddedView(with: transform, animated: true, ignoreIncremental: true)
        default: return
        }
    }

    private func createTransformForAddedView(withScale newScale: CGFloat, at location: CGPoint, aligning: Bool) -> CGAffineTransform {
        guard let aView = self.addedView
        else { return .identity }

        let newFrame = self.createRawDestinationFrame(withScale: newScale, at: location)
        let discardableView = ZoomableView(frame: newFrame)
        let destinationFrame = aligning ? discardableView.destinationFrame(startingAt: .zero) : newFrame

        return CGAffineTransform(from: aView.bounds, to: destinationFrame)
    }

    private func createRawDestinationFrame(withScale newScale: CGFloat, at location: CGPoint) -> CGRect {
        guard let aView = self.addedView
        else { return .zero }
        let existingScale = aView.transform.a
        let scaled = newScale*existingScale

        let aFrame = aView.frame
        let aBounds = aView.bounds

        let newHeight = aBounds.height*scaled
        let newWidth = aBounds.width*scaled

        let ratioOfPointY = location.y/aBounds.height
        let ratioOfPointX = location.x/aBounds.width

        let diffY = newHeight - aFrame.height
        let diffX = newWidth - aFrame.width

        let newY = aFrame.origin.y - diffY*ratioOfPointY
        let newX = aFrame.origin.x - diffX*ratioOfPointX

        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }
}

extension CGAffineTransform {

    init(for view: UIView, toColumn: Int, visibleColumns: Int, verticalOffset: CGFloat) {
        let numberOfColumns = 5 // later this will come from the view itself
        assert(visibleColumns <= numberOfColumns, "can't show more columns than you have")
        let resolvedVisibleCount = min(visibleColumns, numberOfColumns)
        let scale = 1/CGFloat(resolvedVisibleCount)

        let initRect = view.bounds
        let newWidth = scale*view.bounds.width
        let newHeight = scale*view.bounds.height
        let xOffSet = -CGFloat(toColumn)*newWidth/CGFloat(numberOfColumns)
        let newRect = CGRect(x: xOffSet, y: -verticalOffset*newHeight, width: newWidth, height: newHeight)

        self.init(from: initRect, to: newRect)
    }

    init(from source: CGRect, to destination: CGRect) {
        let t = CGAffineTransform.identity
            .translatedBy(x: destination.midX - source.midX, y: destination.midY - source.midY)
            .scaledBy(x: destination.width/source.width, y: destination.height/source.height)
        self.init(a: t.a, b: t.b, c: t.c, d: t.d, tx: t.tx, ty: t.ty)
    }
}



// knuth stuff

// https://www.yumpu.com/en/document/read/40120511/knuth-plass-breaking
// https://github.com/jaroslov/knuth-plass-thoughts/blob/master/plass.md
// http://litherum.blogspot.com/2015/07/knuth-plass-line-breaking-algorithm.html
// https://tex.stackexchange.com/questions/230668/any-progress-on-knuth-plass-algorithm
// https://github.com/bramstein/typeset/
// https://defoe.sourceforge.net/folio/knuth-plass.html

