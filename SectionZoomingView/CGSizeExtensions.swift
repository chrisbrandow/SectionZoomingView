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

//extension CGSize {
//
////    var aspect: Double { Double(self.width)/Double(self.height != 0 ? self.height : 1) }
//    var aspect: CGFloat { self.width/(self.height != 0 ? self.height : 1) }
//
//    static func bestArrangement(for strips: [UIView], matchingRatio targetRatio: Double) -> (rect: CGSize, columns: [[UIView]]) {
//        let sized = Self.bestArrangement(for: strips, matchingRatio: targetRatio, by: .size)
//        let count = Self.bestArrangement(for: strips, matchingRatio: targetRatio, by: .count)
//
//        let sizedRects = sized.columns.map({ Self.condenseOneColumn($0).height})
//        let sizedAverage = sizedRects.reduce(CGFloat(0.0), +)/CGFloat(sizedRects.count)
////        print("\(sizedAverage) - \(sized.rect)")
//        sizedRects.forEach({ print("sized diff \(sizedAverage - CGFloat($0)) \($0)")})
//
//
////        let countRects = count.columns.map({ Self.condenseOneColumn($0).height})
////        let countAverage = countRects.reduce(CGFloat(0.0), +)/CGFloat(countRects.count)
////        print("\(countAverage) - \(count.rect)")
////        countRects.forEach({ print("count diff \(countAverage - CGFloat($0)) \($0)")})
//
//        var adjustSizedColumns = sized.columns
//        if adjustSizedColumns.count > 1 {
//            let poppedSecond = adjustSizedColumns[1].removeFirst()
//            adjustSizedColumns[0].append(poppedSecond)
//        }
////        let poppedThird = adjustSizedColumns[2].removeFirst()
////        let poppedFourth = adjustSizedColumns[3].removeFirst()
//
////        adjustSizedColumns[1].append(poppedThird)
////        adjustSizedColumns[2].append(poppedFourth)
//
//        let rect = adjustSizedColumns.reduce(CGSize.zero) {
//            let column = Self.condenseOneColumn($1)
//            return CGSize(width: $0.width + column.width, height:  max($0.height, column.height))
//        }
//        let replacement = (rect: rect, columns: adjustSizedColumns)
//
////        let repRects = replacement.columns.map({ Self.condenseOneColumn($0).height})
////        let repAverage = repRects.reduce(CGFloat(0.0), +)/CGFloat(repRects.count)
////        print("\(repAverage) - \(replacement.rect)")
////        repRects.forEach({ print("replace diff \(repAverage - CGFloat($0)) \($0)")})
//
//        return replacement
//    }
//    /// Not particularly efficient, but it works
//    static func bestArrangement(for strips: [UIView], matchingRatio targetRatio: Double, by method: Optimization) -> (rect: CGSize, columns: [[UIView]]) {
//        // increment # of columns until ratio is close to target
//        // for now assuming equal height
//        var previous = (rect: CGSize.zero, columns: [[UIView]]())
//        var last = (rect: CGSize.zero, columns: [[UIView]]())
//        var prevRect = CGSize.zero
//        var lastRect = CGSize.zero
//        var i: UInt = 1
//        let cgFloatTargetRatio = CGFloat(targetRatio)
//        repeat {
//            previous = last
//            prevRect = lastRect
//            last = (method == .size
//                        ? Self.arrangementBySize(for: strips, inNumberOfColumns: i)
//                        : Self.arrangementByCount(for: strips, inNumberOfColumns: i)
//            )
//            i += 1
//
//            lastRect = CGSize(width: last.rect.width + CGFloat(i + 1)*4.0, height: last.rect.height + CGFloat(last.columns.first!.count + 1)*4.0)
//        } while (lastRect.aspect < cgFloatTargetRatio) && i <= strips.count
////        } while (last.rect.aspect < cgFloatTargetRatio) && i <= strips.count
//        let previousRectIsBest = abs(last.rect.aspect - cgFloatTargetRatio) > abs(previous.rect.aspect - cgFloatTargetRatio)
//        return previousRectIsBest ? previous : last
//    }
//
//    /// Best for smaller menus
//    private static func arrangementByCount(for strips: [UIView], inNumberOfColumns columnsCount: UInt) -> (rect: CGSize, columns: [[UIView]]) {
//
//        let arranged = Self.arrange(strips, inNumberOfColumns: columnsCount)
//        let rect = arranged.reduce(CGSize.zero) {
//            let column = Self.condenseOneColumn($1)
//            let cRect = CGSize(width: $0.width + column.width, height:  max($0.height, column.height))
//            return cRect
//        }
//        return (rect, arranged)
//    }
//
//    /// Best for larger menus
//    private static func arrangementBySize(for strips: [UIView], inNumberOfColumns columnsCount: UInt) -> (rect: CGSize, columns: [[UIView]]) {
//        let rectOrigins = Self.origins(for: strips, inNumberOfColumns: columnsCount)
//        var columns: [[UIView]] = (1..<rectOrigins.count).map {
//            let start = rectOrigins[$0 - 1]
//            let end = rectOrigins[$0]
//
//            return Array(strips[start.index..<end.index])
//
//        }
//        if let start = rectOrigins.last {
//            columns.append(Array(strips[start.index..<strips.endIndex]))
//        }
//
//        let rect = columns.reduce(CGSize.zero) {
//            let column = Self.condenseOneColumn($1)
//            return CGSize(width: $0.width + column.width, height:  max($0.height, column.height))
//        }
//        return (rect, columns)
//    }
//
//    private static func origins(for strips: [UIView], inNumberOfColumns columnsCount: UInt) -> [(index: Int, y: Int)] {
//        let overallSize = Self.condenseOneColumn(strips)
//
//        // this gets all of the interior targets
//        let targetSectionHeights: [Int] = (1..<columnsCount).map { Int(Double($0)*Double(overallSize.height)/Double(columnsCount)) }
//
//        var stripOrigins = [Int]() // could use `reduce(into:)`
//        for i in 0..<strips.count {
//            let origin = i == 0 ? 0 : stripOrigins[i-1] + Int(strips[i-1].bounds.height)
//            stripOrigins.append(origin)
//        }
//
//        return targetSectionHeights.reduce(into: [(index: 0, y: 0)]) { origins, targetHeight in
//            let closest: (index: Int, y: Int) = stripOrigins.enumerated().reduce((0, 0)) { (previousResult: (index: Int, y: Int), indexedOrigin: (index: Int, y: Int)) -> (index: Int, y: Int) in
//                guard indexedOrigin.y < targetHeight
//                else { return previousResult }
//                return (abs(targetHeight - indexedOrigin.y) < abs(targetHeight - previousResult.y)) ? indexedOrigin : previousResult
//            }
//            origins.append(closest)
//        }
//    }
//
//    private static func arrange(_ strips: [UIView], inNumberOfColumns columnsCount: UInt) -> [[UIView]] {
//        var startIndex = 0
//        var columns = [[UIView]]()
//        for i in 1...columnsCount {
//
//            let columnLength = Self.count(for: i - 1, with: strips.count.quotientAndRemainder(dividingBy: Int(columnsCount)))
//            let end = startIndex + Int(columnLength)
//            columns.append(Array(strips[startIndex..<end]))
//            startIndex = end
//        }
//        return columns
//    }
//
//    static func condenseOneColumn(_ strips: [UIView]) -> CGSize {
//        return strips.reduce(CGSize.zero) { CGSize(width: $1.bounds.width, height:  $0.height + $1.bounds.height) }
//    }
//
//    private static func count(for index: UInt, with num: (quotient: Int, remainder: Int)) -> UInt {
//        return UInt(num.quotient + (index < num.remainder ? 1 : 0))
//    }
//
//}


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
