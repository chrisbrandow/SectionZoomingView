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

    public func setup(withContained view: UIView) {
        self.layer.masksToBounds = true
        self.containedView.removeFromSuperview()
        self.initialSize = view.frame.size

        self.containedView = view
        let scale = self.frame.width/view.frame.width

        self.addSubview(view)

        self.containedView.transform = CGAffineTransform.init(scaleX: scale, y: scale)



        self.initialTransform = self.containedView.transform
//        self.containedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.containedView.layer.position = CGPoint(x: self.containedView.frame.width/2.0, y: self.containedView.frame.width/2.0)


        let zoomRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        self.addGestureRecognizer(zoomRecognizer)

        let dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.addGestureRecognizer(dragRecognizer)

    }


    @objc
    private func didPinch(_ sender: UIPinchGestureRecognizer) {
        guard sender.scale > 0.01
        else { return }

        if sender.state == .ended || sender.state == .cancelled {
            print(self.columnRectForResizing())
            print(self.containedView.layer.position)
            /// then create method to expand to ColRect.
            let colRect = self.columnRectForResizing()
            self.adjustScaleAndPosition(for: colRect)
            self.initialTransform = self.containedView.transform
        } else if [PinchState.began, .changed].contains(sender.state) {
            var center = sender.location(in: self.containedView)
            center.x -= self.containedView.bounds.midX
            center.y -= self.containedView.bounds.midY
            var transform = self.initialTransform

            transform = self.initialTransform.translatedBy(x: center.x, y: center.y)
            let scale = sender.scale
            transform = transform.scaledBy(x: scale, y: scale)
            transform = transform.translatedBy(x: -center.x, y: -center.y)
            self.containedView.transform = transform
        } else {
            self.containedView.transform = self.initialTransform.scaledBy(x: sender.scale, y: sender.scale)
        }

    }

    @objc
    private func didPan(_ sender: UIPanGestureRecognizer) {
        // need to make sure view is still visible
        let translation = sender.translation(in: self)
        self.containedView.transform = self.initialTransform.translatedBy(x: translation.x/self.initialTransform.a, y: translation.y/self.initialTransform.a)
        print("trans \(translation.x) origin \(self.containedView.frame.origin.x)")
        if sender.state == .ended {
            print(self.columnRectForResizing())

            let colRect = self.columnRectForResizing()
            self.adjustScaleAndPosition(for: colRect)
            self.initialTransform = self.containedView.transform
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

        let currentColumnSize = self.self.containedView.frame.width/5.0

        // the question is: how many columns fit in the current window.
        let scale = self.frame.width/currentColumnSize
        let roundedScale = round(scale)
        let adjustedScale = scale/roundedScale
        let adjustedFrameWidth = self.containedView.frame.width*adjustedScale
        let finalScale = adjustedFrameWidth/self.initialSize.width
        let trans = CGAffineTransform(scaleX: finalScale, y: finalScale)

        print("\(self.initialTransform.a) - \(trans.a)")
        // need a check to see if scale changed, and if not, then don't animate the trans, just move it.
        UIView.animate(withDuration: 0.1) {
            self.containedView.transform = trans
            // the positioning no longer works, due to the transform-based translation that I do in the pinch movement
            self.containedView.layer.position = CGPoint(x: currentColumnSize*colRect.origin.x*adjustedScale, y: currentColumnSize*colRect.origin.y*adjustedScale)
        } completion: { (complete) in
            UIView.animate(withDuration: 0.1) {
            } completion: { (complete) in
                self.initialTransform = trans
            }
        }

    }

}

class ViewController: UIViewController {

    @IBOutlet weak var zoomable: SectionZoomingView!

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
        self.zoomable.setup(withContained: sectionedView)

    }
    @IBAction func buttonAction(_ sender: UIButton) {

    }

}

