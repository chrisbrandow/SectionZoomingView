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
    lazy var initialTransform: CGAffineTransform = { self.transform }()

    var containedView: UIView = UIView() //this could be set elsewhere

    var initialSize = CGSize.zero

    var fittingScale: CGFloat {
        return self.bounds.width/self.containedView.bounds.width
    }
    public func setup(withContained view: UIView) {
        self.layer.masksToBounds = true
        self.containedView.removeFromSuperview()
        self.initialSize = view.frame.size

        self.containedView = view
        let scale = self.frame.width/view.frame.width

        self.addSubview(view)

        self.containedView.transform = CGAffineTransform.init(scaleX: scale, y: scale)



        self.initialTransform = self.containedView.transform
        self.containedView.layer.position = CGPoint(x: self.containedView.frame.width/2.0, y: self.containedView.frame.width/2.0)

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

        if [PinchState.began, .changed].contains(sender.state) {
            let center = sender.location(in: self.containedView)
            //TODO: Chris Brandow  2021-01-05 NEED inertia when it gets towards a minimum or maximum
            print(self.containedView.transform.a)
            if self.containedView.transform.a > 0.5*self.fittingScale,
               self.containedView.transform.a < 5*self.fittingScale
               {
                self.containedView.scale(sender.scale, aboutPoint: center, from: self.initialTransform)
            }

        } else if sender.state == .ended || sender.state == .cancelled {
            print(self.columnRectForResizing())
            print(self.containedView.layer.position)
            /// then create method to expand to ColRect.
            let colRect = self.columnRectForResizing()
            self.adjustScaleAndPosition(for: colRect)

            self.initialTransform = self.containedView.transform

        } else  {
            self.containedView.transform = self.initialTransform.scaledBy(x: sender.scale, y: sender.scale)
        }

    }

    var last5Pts: [CGFloat] = []

    @objc
    private func didPan(_ sender: UIPanGestureRecognizer) {
        // need to make sure view is still visible
        let translation = sender.translation(in: self)
        self.containedView.transform = self.initialTransform.translatedBy(x: translation.x/self.initialTransform.a, y: translation.y/self.initialTransform.a)
//        print("trans \(translation.x) origin \(self.containedView.frame.origin.x)")
        if sender.state == .ended {
            print(self.columnRectForResizing())
            let isAGo = self.last5Pts.enumerated().reduce(true) {
                guard $1.0 > 0 else { return $0 }
                return $0 && (($1.1 - self.last5Pts[$1.0 - 1]) > 10)
            }
            print("last: \(self.last5Pts) - \(isAGo))")
            self.last5Pts = []
            let colRect = self.columnRectForResizing()
            self.adjustScaleAndPosition(for: isAGo ? ColRect(origin: CGPoint(x: colRect.origin.x, y: -4), size: colRect.size) : colRect)
            self.initialTransform = self.containedView.transform
        } else if sender.state == .changed {
            let translation = sender.translation(in: self)
            let vector = sqrt(translation.x*translation.x + translation.y*translation.y)
            if self.last5Pts.first != vector {
            self.last5Pts.insert(vector, at: 0)
            }
            if self.last5Pts.count > 5 {
                let _ = self.last5Pts.popLast()
            }
            print(self.last5Pts)
        }
    }

    private func columnRectForResizing() -> ColRect {
        let numberOfColumns = CGFloat(5)
        let columnWidth = self.containedView.frame.width/numberOfColumns
        let rawOrigin = self.containedView.frame.origin.x/columnWidth
        print(rawOrigin)
        let columnOriginX = Int(round(rawOrigin))

        let columnHeight = self.containedView.frame.height/numberOfColumns
        let rawOriginY = self.containedView.frame.origin.y/columnHeight
        print(rawOriginY)
        let columnOriginY = Int(round(rawOriginY))

        let resizedColumnCount = Int(round(numberOfColumns*self.frame.width/self.containedView.frame.width))
        return ColRect(x: columnOriginX, y: columnOriginY, width: resizedColumnCount, height: resizedColumnCount)
    }


    // this should probably be broken up into two methods that return scale & translation respecvitively.
    func adjustScaleAndPosition(for colRect: ColRect) {

        if self.containedView.bounds.width*self.containedView.transform.a <= self.bounds.width {
            let scale = self.frame.width/self.containedView.bounds.width

            UIView.animate(withDuration: 0.1) {
                self.containedView.transform = CGAffineTransform(scaleX: scale, y: scale)//.scale(scale, aboutPoint: self.containedView.center)
            } completion: { _ in
                self.initialTransform = self.containedView.transform
            }
        } else {
            if abs(self.containedView.transform.a - self.fittingScale*5) < 1 { // just a safeguard for now
                self.containedView.transform = self.containedView.transform.scaledBy(x: 0.9, y: 0.9)
            }
            UIView.animate(withDuration: 0.1) {
                print(colRect.origin)
                let origin = CGPoint(x: -self.containedView.frame.origin.x/self.containedView.transform.a, y: -self.containedView.frame.origin.y/self.containedView.transform.d)
                let offset = self.containedView.bounds.width/5.0
                let correctedOriginX = min(0, colRect.origin.x)
                let correctedOriginY = min(0, colRect.origin.y)
                self.containedView.transform = self.containedView.transform.translatedBy(x: origin.x + correctedOriginX*offset + 8, y: origin.y + correctedOriginY*offset + 8)
            } completion: { _ in
                self.initialTransform = self.containedView.transform
            }
        }

    }

}

class ViewController: UIViewController {

    @IBOutlet weak var zoomable: SectionZoomingView?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let edge = CGFloat(800)
        let size = CGSize(width: edge, height: edge)
        let sectionedView = UIView(frame: CGRect(origin: .zero, size: size))


        let count = 5
        let smallEdge = edge/CGFloat(count)
        for i in 0..<count {
            for j in 0..<count {
                let x = CGFloat(i)*smallEdge
                let addView = UIView(frame: CGRect(x: x, y: CGFloat(j)*smallEdge, width: smallEdge, height: smallEdge))
                addView.backgroundColor = UIColor(white: (0.95 - (1+CGFloat(i))*(CGFloat(j)+1)/CGFloat(40)), alpha: 1.0)
                sectionedView.addSubview(addView)
            }
        }
        self.zoomable?.setup(withContained: sectionedView)

    }
    @IBAction func buttonAction(_ sender: UIButton) {

    }

}

public extension UIView {
    /// this works ok, except it causes scrollview to move in opposite direction if pinch is moved
    
    func scale(_ scale:CGFloat, aboutPoint point:CGPoint, from startingTransfrom: CGAffineTransform? = nil) {
        var center = point
        center.x -= self.bounds.midX
        center.y -= self.bounds.midY

        var transform = (startingTransfrom ?? self.transform).translatedBy(x: center.x, y: center.y)
//        let scale = sender.scale
        transform = transform.scaledBy(x: scale, y: scale)
        let adjustedCenter = CGPoint(x: center.x/scale, y: center.y/scale) // dividing by scale handles case where user has pinched and then drags both fingers
        transform = transform.translatedBy(x: -adjustedCenter.x, y: -adjustedCenter.y)

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
