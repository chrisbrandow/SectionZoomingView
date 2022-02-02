//
//  Utilities.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/19/21.
//

import UIKit

extension UIImageView {
    public func animateImageChange(duration: TimeInterval) {
        let transition = CATransition()
        transition.duration = 0.12
        transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        transition.type = .fade;
        self.layer.add(transition, forKey: "fade")
    }
}

extension UIImage {
    static var caretImage: UIImage = {


        let image = UIGraphicsImageRenderer.init(size: CGSize(width: 24.0, height: 24.0)).image { context in

            let lineWidth: CGFloat = 3.0
            let path = UIBezierPath()
            let rightCorner = CGPoint(x: 24 - lineWidth/2.0 - 3.0, y: lineWidth/2.0 + 9.0)
            let leftCorner = CGPoint(x: lineWidth/2.0 + 3.0, y: lineWidth/2.0 + 9.0)
            let bottomCornerHeight: CGFloat = 6
            let bottomCorner = CGPoint(x: 12, y: 12 + 6.0)
            path.move(to: rightCorner)
            path.addLine(to: bottomCorner)
            path.addLine(to: leftCorner)
            
            let borderColor = UIColor.otk_white
            path.lineWidth = lineWidth
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            borderColor.setStroke()
            path.stroke()
        }
        return image.withRenderingMode(.alwaysTemplate)
    }()
}
