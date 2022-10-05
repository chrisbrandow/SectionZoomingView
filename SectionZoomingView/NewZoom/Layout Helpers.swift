//
//  DisplayLinkAnimator.swift
//  ProtoDisplayLinkMenu
//
//  Created by Christopher Brandow on 9/18/22.
//

import QuartzCore
import UIKit
public final class TimerAnimation {

    public typealias Animations = (_ progress: Double, _ time: TimeInterval) -> Void
    public typealias Completion = (_ finished: Bool) -> Void

    public init(duration: TimeInterval, animations: @escaping Animations, completion: Completion? = nil) {
        self.duration = duration
        self.animations = animations
        self.completion = completion

        firstFrameTimestamp = CACurrentMediaTime()

        let displayLink = CADisplayLink(target: self, selector: #selector(handleFrame(_:)))
        displayLink.add(to: .main, forMode: RunLoop.Mode.common)
        self.displayLink = displayLink
    }

    deinit {
        invalidate()
    }

    public func invalidate() {
        guard running else { return }
        running = false
        completion?(false)
        displayLink?.invalidate()
    }

    private let duration: TimeInterval
    private let animations: Animations
    private let completion: Completion?
    private weak var displayLink: CADisplayLink?

    private var running: Bool = true

    private let firstFrameTimestamp: CFTimeInterval

    @objc private func handleFrame(_ displayLink: CADisplayLink) {
        guard running else { return }
        let elapsed = CACurrentMediaTime() - firstFrameTimestamp
        if elapsed >= duration {
            animations(1, duration)
            running = false
            completion?(true)
            displayLink.invalidate()
        } else {
            animations(elapsed / duration, elapsed)
        }
    }
}


public func rubberBandClamp(_ x: CGFloat, coeff: CGFloat, dim: CGFloat) -> CGFloat {
    return (1.0 - (1.0 / (x * coeff / dim + 1.0))) * dim
}
public extension Comparable {

    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }

}
public func rubberBandClamp(_ x: CGFloat, coeff: CGFloat, dim: CGFloat, limits: ClosedRange<CGFloat>) -> CGFloat {
    let clampedX = x.clamped(to: limits)
    let diff = abs(x - clampedX)
    let sign: CGFloat = clampedX > x ? -1 : 1
    return clampedX + sign * rubberBandClamp(diff, coeff: coeff, dim: dim)
}

public struct RubberBand {
    public var coeff: CGFloat
    public var dims: CGSize
    public var limits: CGRect

    public init(coeff: CGFloat = 0.55, dims: CGSize, limits: CGRect) {
        self.coeff = coeff
        self.dims = dims
        self.limits = limits
    }

    public func clamp(_ point: CGPoint) -> CGPoint {
        let x = rubberBandClamp(point.x, coeff: coeff, dim: dims.width, limits: limits.minX...limits.maxX)
        let y = rubberBandClamp(point.y, coeff: coeff, dim: dims.height, limits: limits.minY...limits.maxY)
        print("x \(x) \(y)")
        return CGPoint(x: x, y: y)
    }

    public init(clampingView: UIView, within toView: UIView) {

        self.coeff = 0.35
        self.dims = CGSize.zero
        self.limits = .zero
    }
}
