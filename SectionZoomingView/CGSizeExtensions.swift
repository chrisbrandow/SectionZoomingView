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
        guard let width = strips.first?.frame.width
        else { return (rect: .zero, columns: [[]]) }

        let columnCount = round(sqrt(strips.last!.frame.maxY*ratio/width)) // putting ceil here makes sure it doesn't extend below
        let targetHeight = strips.last!.frame.maxY/columnCount

        let columns = UIView.getBestArrangement(for: [], with: strips, in: Int(columnCount), target: targetHeight)
        let maxHeight = columns.reduce(0) { max($0, $1.height) }
        return (rect: CGSize(width: columnCount*width, height: maxHeight), columns: columns)
    }

    private static func getBestArrangement(for previousColumns: [[UIView]], with remainingViews: [UIView], in remainingColumns: Int, target targetHeight: CGFloat) -> [[UIView]] {
        let nextCount = remainingColumns - 1

        guard nextCount > 0 else {
            return previousColumns + [remainingViews]

        } // there is only one column left

        guard let firstFrame = remainingViews.first?.frame,
              let targetIndex = remainingViews.firstIndex(where: {$0.frame.origin.y - firstFrame.origin.y >= targetHeight })
        else { return [] }

        let lowerBest = UIView.singleArrangement(of: remainingViews, with: previousColumns, toIndex: targetIndex - 1, nextCount: nextCount, targetHeight: targetHeight)
        let biggerBest = UIView.singleArrangement(of: remainingViews, with: previousColumns, toIndex: targetIndex, nextCount: nextCount, targetHeight: targetHeight)

        let lowerStd = UIView.stdev(for: lowerBest, targetHeight: targetHeight)
        let upperStd = UIView.stdev(for: biggerBest, targetHeight: targetHeight)

        return lowerStd < upperStd
            ? lowerBest
            : biggerBest
    }

    private static func singleArrangement(of remainingViews: [UIView], with previousColumns: [[UIView]], toIndex targetIndex: Int, nextCount: Int, targetHeight: CGFloat) -> [[UIView]] {
        let start = remainingViews.startIndex

        let column = Array(remainingViews[start..<targetIndex]) // does NOT include target cell

        let targetColumns = previousColumns + [column]
        let leftovers = Array(remainingViews[targetIndex..<remainingViews.endIndex])

        return UIView.getBestArrangement(for: targetColumns, with: leftovers, in: nextCount, target: targetHeight)
    }

    private static func stdev(for arrangedViews: [[UIView]], targetHeight: CGFloat) -> CGFloat {
        let sumOfDifferences = arrangedViews.reduce(0) { $0 + abs((($1.last?.frame.origin.y ?? 0) - ($1.first?.frame.origin.y ?? 0)) - targetHeight) }

        let upperAvg = sumOfDifferences/CGFloat(arrangedViews.count)
        let upperDiffMap = arrangedViews.map { (($0.last?.frame.origin.y ?? 0) - ($0.first?.frame.origin.y ?? 0)) - targetHeight }
        let sumOfXDiff = upperDiffMap.reduce(0) { $0 + (upperAvg - $1)*(upperAvg - $1) }
        return sqrt(sumOfXDiff/CGFloat(arrangedViews.count))
    }

    public static func getBest(for views: [UIView], in number: Int) -> [[UIView]] {
        let totalHeight: CGFloat = views.reduce(CGFloat(0)) { $0 + $1.frame.height }
        let desiredHeight  = totalHeight/CGFloat(number)

        let best = UIView.getBestArrangement(for: [], with: views, in: number, target: desiredHeight)
        print("t: \(desiredHeight) - ")
        print("this is best \((best.reduce(0) { $0 + abs(($1.last!.frame.origin.y - $1.first!.frame.origin.y) - desiredHeight) })) -- \((best.reduce(0) { $0 + abs(($1.last!.frame.origin.y - $1.first!.frame.origin.y) - desiredHeight) })/CGFloat(number))")

        return best
    }
}
