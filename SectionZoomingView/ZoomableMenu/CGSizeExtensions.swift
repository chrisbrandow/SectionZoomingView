//
//  CGSizeExtensions.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/4/21.
//

import UIKit
import CoreGraphics


enum Strip: CaseIterable {
    case thin
    case medium
    case tall

    var rect: CGSize {
        switch self {
        case .thin: return CGSize(width: 300 , height: 60)
        case .medium: return CGSize(width: 300 , height: 80)
        case .tall: return CGSize(width: 300 , height: 100)
        }
    }
}

enum Optimization {
    case size
    case count
}

//extension CGSi


extension Array where Element == UIView {
    var description: String {
        return "\(self.count) - \(self.height)"
    }

    var height: CGFloat {
        self.reduce(CGFloat(0)) { $0 + $1.frame.height }
    }
}
extension UIView {

    static func bestArrangement(for strips: [UIView], matchingRatio targetRatio: Double) -> (rect: CGSize, columns: [[UIView]]) {
        let ratio = CGFloat(targetRatio)
        guard let width = strips.first?.frame.width,
                let lastStrip = strips.last
        else { return (rect: .zero, columns: [[]]) }

        let columnCount = round(sqrt(lastStrip.frame.maxY*ratio/width)) // putting ceil here makes sure it doesn't extend below
        let targetHeight = lastStrip.frame.maxY/columnCount

        let columns = UIView._getBestArrangement(for: [], with: strips, in: Int(columnCount), target: targetHeight, accumulated: 0)
//        print("aasass \(columns.0)")
        let c = UIView.getBestArrangement(for: [], with: strips, in: Int(columnCount), target: targetHeight, accumulated: 0)
        let cc = UIView.checks(c.1)
        let maxHeight = columns.first!.1.reduce(0) { max($0, $1.height) }
//        let newSorted = columns.sorted(by: { $0.0 > $1.0 })
        let newSorted = columns.sorted(by: { self._stdev(for: $0.1) > self._stdev(for: $1.1) })
        let best = newSorted.last
        newSorted.forEach({
            print("\(UIView.checks($0.1)) - \($0.0) \(self._stdev(for: $0.1))")
        })
        print("----\n\(UIView.checks(best!.1)) \(best!.1.last?.first?.subviews.first(where: { $0 is UILabel }))")
        return (rect: CGSize(width: columnCount*width, height: maxHeight), columns: best!.1)
    }

    static func checks(_ views: [[UIView]]) -> Int {
        var additive = 1

        let checksum = views.reduce(0) { partialResult, views in
            var aa = 0
            let r = partialResult + additive + views.reduce(0) { (r, _) in let rr = r + aa; aa += 1; return rr }
            additive *= 10
            return r
        }
        return checksum
    }
    private static func _getBestArrangement(for previousColumns: [[UIView]], with remainingViews: [UIView], in remainingColumns: Int, target targetHeight: CGFloat, accumulated: CGFloat) -> [(CGFloat, [[UIView]])] {
        let nextCount = remainingColumns - 1

        guard nextCount > 0 else {
            print("accum \(accumulated)")
            return [(accumulated, previousColumns + [remainingViews])]

        } // there is only one column left

        guard let firstFrame = remainingViews.first?.frame,
              let targetIndex = remainingViews.firstIndex(where: {$0.frame.origin.y - firstFrame.origin.y >= targetHeight })
        else { return [(accumulated, [])] }

        let lower = UIView._singleArrangement(of: remainingViews, with: previousColumns, toIndex: targetIndex - 1, nextCount: nextCount, targetHeight: targetHeight, accumulated: accumulated)
        let upper = UIView._singleArrangement(of: remainingViews, with: previousColumns, toIndex: targetIndex, nextCount: nextCount, targetHeight: targetHeight, accumulated: accumulated)
        let upper2 = UIView._singleArrangement(of: remainingViews, with: previousColumns, toIndex: targetIndex + 1, nextCount: nextCount, targetHeight: targetHeight, accumulated: accumulated)

        //        let lowerStd = UIView.stdev(for: lowerBest, targetHeight: targetHeight)
        //        let upperStd = UIView.stdev(for: biggerBest, targetHeight: targetHeight)
//        print("get best \(accumulated + lowerStd) \(upperStd)")

        return [lower, upper, upper2].flatMap({ $0 })
    }


    private static func _singleArrangement(of remainingViews: [UIView], with previousColumns: [[UIView]], toIndex targetIndex: Int, nextCount: Int, targetHeight: CGFloat, accumulated: CGFloat) -> [(CGFloat, [[UIView]])] {
        let start = remainingViews.startIndex

        let column = Array(remainingViews[start..<targetIndex]) // does NOT include target cell

        let targetColumns = previousColumns + [column]
        let leftovers = Array(remainingViews[targetIndex..<remainingViews.endIndex])

        let best = UIView._getBestArrangement(for: targetColumns, with: leftovers, in: nextCount, target: targetHeight, accumulated: accumulated)
        return best.map {
            let stdev = UIView.stdev(for: $0.1, targetHeight: targetHeight)
            print(stdev)
            return (stdev + $0.0, $0.1)
        }


    }


    private static func getBestArrangement(for previousColumns: [[UIView]], with remainingViews: [UIView], in remainingColumns: Int, target targetHeight: CGFloat, accumulated: CGFloat) -> (CGFloat, [[UIView]]) {
        let nextCount = remainingColumns - 1

        guard nextCount > 0 else {
            print("accum \(accumulated)")
            return (accumulated, previousColumns + [remainingViews])

        } // there is only one column left

        guard let firstFrame = remainingViews.first?.frame,
              let targetIndex = remainingViews.firstIndex(where: {$0.frame.origin.y - firstFrame.origin.y >= targetHeight })
        else { return (accumulated, []) }

        let (lowerStd, lowerBest) = UIView.singleArrangement(of: remainingViews, with: previousColumns, toIndex: targetIndex - 1, nextCount: nextCount, targetHeight: targetHeight, accumulated: accumulated)
        let (upperStd, biggerBest) = UIView.singleArrangement(of: remainingViews, with: previousColumns, toIndex: targetIndex, nextCount: nextCount, targetHeight: targetHeight, accumulated: accumulated)

//        let lowerStd = UIView.stdev(for: lowerBest, targetHeight: targetHeight)
//        let upperStd = UIView.stdev(for: biggerBest, targetHeight: targetHeight)
        print("get best \(accumulated + lowerStd) \(upperStd)")

        return lowerStd < upperStd
            ? (lowerStd, lowerBest)
            : (upperStd, biggerBest)
    }

    private static func singleArrangement(of remainingViews: [UIView], with previousColumns: [[UIView]], toIndex targetIndex: Int, nextCount: Int, targetHeight: CGFloat, accumulated: CGFloat) -> (CGFloat, [[UIView]]) {
        let start = remainingViews.startIndex

        let column = Array(remainingViews[start..<targetIndex]) // does NOT include target cell

        let targetColumns = previousColumns + [column]
        let leftovers = Array(remainingViews[targetIndex..<remainingViews.endIndex])

        let best = UIView.getBestArrangement(for: targetColumns, with: leftovers, in: nextCount, target: targetHeight, accumulated: accumulated)
        let stdev = UIView.stdev(for: best.1, targetHeight: targetHeight)
        print(stdev)
        return (stdev + best.0, best.1)
    }

    private static func stdev(for arrangedViews: [[UIView]], targetHeight: CGFloat) -> CGFloat {
        let sumOfDifferences = arrangedViews.reduce(0) { $0 + abs((($1.last?.frame.maxY ?? 0) - ($1.first?.frame.origin.y ?? 0)) - targetHeight) }

        let upperAvg = sumOfDifferences/CGFloat(arrangedViews.count)
        let upperDiffMap = arrangedViews.map { (($0.last?.frame.maxY ?? 0) - ($0.first?.frame.origin.y ?? 0)) - targetHeight }
        let sumOfXDiff = upperDiffMap.reduce(0) { $0 + (upperAvg - $1)*(upperAvg - $1) }
        return sqrt(sumOfXDiff/CGFloat(arrangedViews.count))
    }

    private static func _stdev(for arrangedViews: [[UIView]]) -> CGFloat {
        let avg = arrangedViews.last!.last!.frame.maxY/CGFloat(arrangedViews.count)
        let sumOfDifferences = arrangedViews.reduce(0) {
            let diff = ($0 + abs((($1.last?.frame.maxY ?? 0) - ($1.first?.frame.origin.y ?? 0)) - avg))
            return diff*diff/1000
        }

        let upperAvg = sumOfDifferences/CGFloat(arrangedViews.count)
        let upperDiffMap = arrangedViews.map { abs((($0.last?.frame.maxY ?? 0) - ($0.first?.frame.origin.y ?? 0)) - avg) }
        let sumOfXDiff = upperDiffMap.reduce(0) { $0 + (upperAvg - $1)*(upperAvg - $1) }
        return sqrt(sumOfXDiff/CGFloat(arrangedViews.count))
    }

}
                func addressOf<T: AnyObject>(_ o: T) -> Int {
                return unsafeBitCast(o, to: Int.self)
//                return Int(String(format: "%p", addr)) ?? 0
            }
