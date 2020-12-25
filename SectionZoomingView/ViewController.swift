//
//  ViewController.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 12/23/20.
//

import UIKit

typealias ColRect = CGRect

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
        self.containedView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        self.containedView.layer.position = CGPoint(x: 0, y: 0)


        let zoomRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        self.addGestureRecognizer(zoomRecognizer)

        let dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.addGestureRecognizer(dragRecognizer)

    }


    @objc
    private func didPinch(_ sender: UIPinchGestureRecognizer) {
        guard sender.scale > 0.01
        else { return }
        self.containedView.transform = self.initialTransform.scaledBy(x: sender.scale, y: sender.scale)

        if sender.state == .ended {
            print(self.columnRectForResizing())

            /// then create method to expand to ColRect.
            let colRect = self.columnRectForResizing()
            self.centerInParentIfNeeded(for: colRect)
            self.initialTransform = self.containedView.transform
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
            self.centerInParentIfNeeded(for: colRect)
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

    func centerInParentIfNeeded(for colRect: ColRect) {

//        if self.containedView.frame.width <= self.frame.width {
        let currentColumnSize = self.self.containedView.frame.width/5.0

        // the question is: how many columns fit in the current window.
        let scale = self.frame.width/currentColumnSize
        print("scale: \(scale)")
        let roundedScale = round(scale)
        print("rscale: \(roundedScale)")
        let adjustedFrameWidth = self.containedView.frame.width*scale/roundedScale
        let adjustedScale = adjustedFrameWidth/self.initialSize.width
        let trans = CGAffineTransform(scaleX: adjustedScale, y: adjustedScale)


        // need a check to see if scale changed, and if not, then don't animate the trans, just move it.
            UIView.animate(withDuration: 0.17) {
                self.containedView.transform = trans
            } completion: { (complete) in
                self.initialTransform = trans
                self.containedView.layer.position = CGPoint(x: currentColumnSize*colRect.origin.x, y: currentColumnSize*colRect.origin.y)

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

