//
//  ViewController.swift
//  ProtoDisplayLinkMenu
//
//  Created by Christopher Brandow on 9/15/22.
//

import UIKit

struct CellCoordinate {
    let column: Int
    let row: Int
}

protocol Zoomable: UIView {
    var columnWidth: CGFloat { get }
    func frameForCell(at: CellCoordinate, for size: CGSize)  -> CGRect

}

class ZoomableView: UIView, Zoomable {
    var temporaryCellHeight = CGFloat(0)
    
    private var tempNumberOfColumns = 5
    var columnWidth: CGFloat { self.frame.width/CGFloat(self.tempNumberOfColumns) }
    private var rowHeight: CGFloat { max(1, self.temporaryCellHeight*self.transform.a) }


    /// This seems to work correctly 21Sep2022!!
    func frameForCell(at coordinate: CellCoordinate, for size: CGSize) -> CGRect {
        let y = CGFloat(coordinate.row)*(self.rowHeight)
        let x = CGFloat(coordinate.column)*size.width/5.0
        let cellSize = CGSize(width: self.columnWidth, height: self.rowHeight)
        return CGRect(origin: CGPoint(x: x, y: y), size: cellSize)
    }

    func originCellCoordinates(for rect: CGRect) -> CellCoordinate {
        let origin = rect.origin
        let column = max(0, Int(round(-origin.x/self.columnWidth)))
        let row    = max(0, Int(round(-origin.y/self.rowHeight)))

        return CellCoordinate(column: column, row: row)
    }

    func destinationFrame(startingAt point: CGPoint) -> CGRect {
        // the vertical always ends up at the edge of a cell, which is good, but it goes one cell
        // too high in many cases, which is not good.
        let scale = min(1.0, max(0.2, self.transform.a))
        let invertedScale = round(1/scale)

        let newRect = self.createRawDestinationFrame(withScale: 1/(invertedScale*self.transform.a), at: point) // i'm not really using the `at: point` portion, but that might be useful later
        let cell = self.originCellCoordinates(for: self.frame)
        let cellOrigin =  self.frameForCell(at: cell, for: newRect.size).origin
        let newPosition = CGPoint(x: -cellOrigin.x, y: -cellOrigin.y)

        var calcedRect = CGRect(origin: newPosition, size: newRect.size)
        guard let superView = self.superview
        else { return calcedRect }


        calcedRect.origin.y = -self.findClosestVerticalCellOffset(in: superView, ratio: 1/invertedScale)

        if calcedRect.maxY < superView.frame.height { // This works as a way to prevent ending with too far left or up offset.
            calcedRect.origin.y = superView.frame.height - calcedRect.height 
        }
        if calcedRect.maxX < superView.frame.width {
            calcedRect.origin.x = superView.frame.width - calcedRect.width
        }
        return calcedRect
    }

    // this is the likely best approach, since it doesn't depend on implementation of the vertical arrangement.
    // it just finds the closest view to the top
    private func findClosestVerticalCellOffset(in superView: UIView, ratio: CGFloat) -> CGFloat {
        let onscreenSubviews = self.subviews.filter({
            let fx = $0.frame.midX*ratio + self.frame.origin.x
            let fy = $0.frame.midY*ratio + self.frame.origin.y
            return fx  > 0
            && fx < superView.frame.width
            && fy > 0
            && fy < superView.frame.height
        })

        let derivedVerticalOffset: CGFloat = onscreenSubviews.reduce(superView.frame.height) { (previousOffset, view) -> CGFloat in
            let currentOffset = view.frame.origin.y*ratio
            let previousIsCloserToTopOfSuperview = abs(self.frame.origin.y + previousOffset) < abs(self.frame.origin.y + currentOffset)
            return previousIsCloserToTopOfSuperview ? previousOffset : currentOffset
        }
        return derivedVerticalOffset
    }

    func createRawDestinationFrame(withScale newScale: CGFloat, at location: CGPoint) -> CGRect {
        let existingScale = self.transform.a
        let scaled = newScale*existingScale

        let aFrame = self.frame
        let aBounds = self.bounds

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

func createDiagnosticView(for containerView: UIView?) -> ZoomableView? {
    guard let containerView_ = containerView
    else { return nil }
    let mView = ZoomableView()

    let columnCount = CGFloat(5)
    let width = containerView_.frame.width*columnCount
    let aspect = containerView_.frame.height/containerView_.frame.width
    let height = width*aspect
    mView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
    let smallAspect: CGFloat = 0.5
    let smallWidth = width/columnCount
    let smallHeight = smallAspect*smallWidth
    
    let numberOfRows = height/smallHeight
    var leadingIndex = 0
    mView.temporaryCellHeight = smallHeight
    for x in stride(from: 0, to: columnCount, by: 1) {
        var previousOffset: CGFloat = 0
        for y in stride(from: 0, to: numberOfRows, by: 1) {

            let margin: CGFloat = 4.0
            let actualHeight = smallHeight + CGFloat.random(in: -10.0...10.0)
            let vFrame = CGRect(x: x*smallWidth, y: previousOffset, width: smallWidth, height: actualHeight)
            previousOffset += actualHeight
            guard vFrame.maxY < height
            else { continue }
            let view = UIView(frame: vFrame)
            let lFrame = CGRect(x: margin, y: margin, width: vFrame.width - margin/2, height: vFrame.height - margin/2)

            let label = UILabel(frame: lFrame)
            let unitCoordinates = CGPoint(x: x*smallWidth/width, y: y)
            let nextIndex = leadingIndex + Int.random(in: 30...60)
            label.layer.cornerRadius = 8.0
            label.layer.masksToBounds = true
            let t = lorem[lorem.index(lorem.startIndex, offsetBy: leadingIndex)..<lorem.index(lorem.startIndex, offsetBy: nextIndex)]
            leadingIndex = nextIndex
            label.text = "\(Int(x)): \(Int(y))\n\(unitCoordinates.x), \(unitCoordinates.y)\n\(t)"
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.backgroundColor = .white// colors.randomElement()
            label.textColor = UIColor(white: 0.14, alpha: 1.0)
            label.layer.borderColor = UIColor.lightGray.cgColor
            label.layer.borderWidth = 2.0
            view.addSubview(label)
            mView.addSubview(view)
        }
    }
    return mView
}

let lorem = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Eget magna fermentum iaculis eu non diam phasellus. Ipsum suspendisse ultrices gravida dictum fusce. Tincidunt id aliquet risus feugiat. Tempor commodo ullamcorper a lacus vestibulum sed. Aliquam vestibulum morbi blandit cursus. Non consectetur a erat nam at lectus urna. Urna nunc id cursus metus aliquam. Risus sed vulputate odio ut enim blandit volutpat maecenas volutpat. Rutrum tellus pellentesque eu tincidunt tortor aliquam nulla facilisi cras. Consequat ac felis donec et odio pellentesque. Nibh ipsum consequat nisl vel.

Adipiscing commodo elit at imperdiet dui. Tristique senectus et netus et malesuada. Lorem dolor sed viverra ipsum nunc aliquet bibendum. In hendrerit gravida rutrum quisque non tellus orci ac auctor. Elit scelerisque mauris pellentesque pulvinar pellentesque habitant. Nunc eget lorem dolor sed viverra ipsum nunc aliquet. Vel elit scelerisque mauris pellentesque pulvinar pellentesque habitant. Cursus risus at ultrices mi tempus imperdiet nulla malesuada. Lectus nulla at volutpat diam ut venenatis tellus in metus. Accumsan sit amet nulla facilisi morbi. Vestibulum lectus mauris ultrices eros in cursus. Vestibulum mattis ullamcorper velit sed ullamcorper. Pretium fusce id velit ut tortor pretium viverra suspendisse potenti. Faucibus scelerisque eleifend donec pretium. Quis vel eros donec ac odio tempor. At urna condimentum mattis pellentesque id nibh. Phasellus faucibus scelerisque eleifend donec pretium vulputate. Pulvinar neque laoreet suspendisse interdum consectetur libero id faucibus nisl. Amet consectetur adipiscing elit pellentesque. Est sit amet facilisis magna etiam tempor orci.

Quis enim lobortis scelerisque fermentum dui faucibus in ornare. Blandit turpis cursus in hac habitasse platea dictumst quisque. Ornare quam viverra orci sagittis eu volutpat. Interdum velit laoreet id donec ultrices tincidunt. Cras ornare arcu dui vivamus arcu felis bibendum ut. Erat velit scelerisque in dictum non consectetur a erat. Ac auctor augue mauris augue neque gravida in fermentum. Est placerat in egestas erat. In tellus integer feugiat scelerisque varius morbi enim. Venenatis lectus magna fringilla urna porttitor rhoncus. Lorem ipsum dolor sit amet consectetur. Eu sem integer vitae justo. Nibh cras pulvinar mattis nunc sed blandit. Eu feugiat pretium nibh ipsum. Porta nibh venenatis cras sed felis eget. Commodo sed egestas egestas fringilla phasellus faucibus scelerisque eleifend. Hendrerit gravida rutrum quisque non tellus orci.

Nisl rhoncus mattis rhoncus urna neque viverra justo. Arcu non odio euismod lacinia. Integer eget aliquet nibh praesent tristique magna sit amet. Sit amet tellus cras adipiscing enim. In fermentum posuere urna nec tincidunt praesent semper. Ipsum a arcu cursus vitae congue. Purus in massa tempor nec. Mi eget mauris pharetra et ultrices. Imperdiet massa tincidunt nunc pulvinar sapien. A diam sollicitudin tempor id eu nisl nunc. Amet dictum sit amet justo donec enim diam vulputate ut. Vitae nunc sed velit dignissim sodales ut eu. Sed lectus vestibulum mattis ullamcorper. Odio eu feugiat pretium nibh ipsum consequat nisl vel pretium. Amet mauris commodo quis imperdiet massa tincidunt.

Dolor magna eget est lorem. Ultrices dui sapien eget mi proin sed libero enim sed. Orci sagittis eu volutpat odio facilisis mauris sit. Commodo ullamcorper a lacus vestibulum. Non enim praesent elementum facilisis. Sapien et ligula ullamcorper malesuada. Faucibus interdum posuere lorem ipsum dolor. Justo donec enim diam vulputate ut pharetra sit amet. Volutpat maecenas volutpat blandit aliquam etiam erat velit. Quam adipiscing vitae proin sagittis. Amet mauris commodo quis imperdiet massa tincidunt nunc pulvinar. Egestas erat imperdiet sed euismod nisi.

Aliquet risus feugiat in ante metus dictum at. Ipsum suspendisse ultrices gravida dictum fusce ut placerat orci. Id faucibus nisl tincidunt eget nullam. Sed enim ut sem viverra. Viverra ipsum nunc aliquet bibendum enim. In cursus turpis massa tincidunt dui ut ornare lectus. Sodales ut eu sem integer vitae justo eget magna. Duis at tellus at urna condimentum. Pellentesque sit amet porttitor eget dolor. Tellus in hac habitasse platea dictumst vestibulum. In dictum non consectetur a. Purus non enim praesent elementum facilisis leo. Orci nulla pellentesque dignissim enim sit amet. Auctor augue mauris augue neque gravida in fermentum et. Nunc faucibus a pellentesque sit amet porttitor eget dolor. Dictum varius duis at consectetur lorem donec massa. Ut tristique et egestas quis ipsum suspendisse. Aenean vel elit scelerisque mauris pellentesque pulvinar pellentesque. Viverra nam libero justo laoreet sit amet cursus sit amet. Vitae tortor condimentum lacinia quis vel eros donec ac odio.

Mattis molestie a iaculis at erat pellentesque adipiscing commodo elit. Arcu odio ut sem nulla pharetra diam sit amet nisl. Purus ut faucibus pulvinar elementum. Pellentesque adipiscing commodo elit at imperdiet dui. Pellentesque elit eget gravida cum sociis natoque penatibus et magnis. Tristique et egestas quis ipsum. Commodo quis imperdiet massa tincidunt nunc pulvinar. Lorem dolor sed viverra ipsum nunc aliquet. Et malesuada fames ac turpis egestas sed. Elementum curabitur vitae nunc sed velit. Vestibulum morbi blandit cursus risus at ultrices mi. Eu lobortis elementum nibh tellus molestie nunc non blandit massa. Scelerisque viverra mauris in aliquam. Elementum curabitur vitae nunc sed velit dignissim sodales. Est ullamcorper eget nulla facilisi etiam dignissim. Venenatis tellus in metus vulputate. Rhoncus est pellentesque elit ullamcorper dignissim cras tincidunt lobortis.

Ornare aenean euismod elementum nisi. Amet mauris commodo quis imperdiet massa tincidunt nunc. Orci porta non pulvinar neque laoreet suspendisse interdum consectetur libero. Pretium viverra suspendisse potenti nullam ac tortor. Aliquam purus sit amet luctus venenatis lectus magna. Tellus pellentesque eu tincidunt tortor aliquam nulla facilisi. Vitae nunc sed velit dignissim sodales. Lorem ipsum dolor sit amet. At urna condimentum mattis pellentesque id nibh tortor id. Nisl condimentum id venenatis a condimentum vitae.

Metus dictum at tempor commodo ullamcorper a lacus. Donec ultrices tincidunt arcu non sodales. Elit ullamcorper dignissim cras tincidunt lobortis feugiat vivamus at. Elementum curabitur vitae nunc sed velit dignissim. Enim diam vulputate ut pharetra sit amet aliquam id diam. Mattis rhoncus urna neque viverra justo nec ultrices. Hac habitasse platea dictumst vestibulum rhoncus est pellentesque. Lacinia quis vel eros donec ac odio tempor orci. A iaculis at erat pellentesque adipiscing commodo elit at. Sed adipiscing diam donec adipiscing.

Lectus urna duis convallis convallis tellus id interdum velit. Ipsum dolor sit amet consectetur adipiscing elit. Tristique magna sit amet purus gravida quis blandit. Vitae proin sagittis nisl rhoncus mattis rhoncus urna neque viverra. Sapien nec sagittis aliquam malesuada bibendum arcu. Dolor magna eget est lorem ipsum. Dignissim suspendisse in est ante in nibh mauris. Turpis egestas pretium aenean pharetra. Donec ultrices tincidunt arcu non sodales neque sodales. Tellus cras adipiscing enim eu. Faucibus vitae aliquet nec ullamcorper sit amet risus nullam eget. Tellus orci ac auctor augue mauris. Massa tincidunt nunc pulvinar sapien et. Tristique et egestas quis ipsum suspendisse ultrices gravida dictum. Consectetur adipiscing elit duis tristique sollicitudin. Arcu felis bibendum ut tristique et egestas quis ipsum. Aliquet porttitor lacus luctus accumsan tortor posuere ac.

Netus et malesuada fames ac. Urna cursus eget nunc scelerisque viverra mauris. Purus sit amet volutpat consequat mauris nunc congue nisi. Aenean et tortor at risus viverra adipiscing. Elementum integer enim neque volutpat ac tincidunt vitae. Purus in mollis nunc sed id semper. Lacus vestibulum sed arcu non odio. Dolor morbi non arcu risus quis varius. Viverra nibh cras pulvinar mattis nunc. Commodo sed egestas egestas fringilla phasellus faucibus scelerisque eleifend. Gravida arcu ac tortor dignissim convallis aenean et. Tellus rutrum tellus pellentesque eu tincidunt tortor aliquam. Arcu risus quis varius quam. In pellentesque massa placerat duis ultricies lacus sed turpis tincidunt.

Eget mauris pharetra et ultrices neque ornare. Egestas fringilla phasellus faucibus scelerisque. Molestie at elementum eu facilisis sed odio morbi quis commodo. Volutpat commodo sed egestas egestas fringilla phasellus. Metus aliquam eleifend mi in nulla posuere sollicitudin. Suspendisse interdum consectetur libero id faucibus nisl tincidunt eget. Justo laoreet sit amet cursus sit. Vitae suscipit tellus mauris a. Volutpat ac tincidunt vitae semper quis lectus. Fames ac turpis egestas sed tempus urna. Sem viverra aliquet eget sit amet tellus cras.

Facilisi nullam vehicula ipsum a arcu cursus vitae congue mauris. Risus sed vulputate odio ut enim blandit volutpat maecenas. Eros in cursus turpis massa tincidunt dui. Eget nunc lobortis mattis aliquam faucibus. Gravida in fermentum et sollicitudin. Rhoncus mattis rhoncus urna neque viverra justo nec ultrices. Nulla pellentesque dignissim enim sit amet venenatis urna cursus. Amet consectetur adipiscing elit pellentesque. Sed velit dignissim sodales ut eu sem. Semper risus in hendrerit gravida rutrum quisque non tellus. Gravida neque convallis a cras semper auctor neque. In hac habitasse platea dictumst quisque. Malesuada fames ac turpis egestas integer eget aliquet nibh praesent. Vulputate enim nulla aliquet porttitor lacus luctus accumsan tortor. Cursus turpis massa tincidunt dui. Lacus laoreet non curabitur gravida arcu ac tortor. A iaculis at erat pellentesque adipiscing commodo elit. Ac turpis egestas integer eget aliquet nibh praesent tristique magna. Morbi tristique senectus et netus et.

Morbi quis commodo odio aenean. Urna duis convallis convallis tellus id. Scelerisque in dictum non consectetur a erat nam at. Ac turpis egestas sed tempus urna et. Id diam maecenas ultricies mi eget. Nec ullamcorper sit amet risus nullam eget. Consectetur a erat nam at lectus urna. Et netus et malesuada fames ac turpis egestas sed tempus. Convallis tellus id interdum velit laoreet id donec ultrices tincidunt. Mattis pellentesque id nibh tortor id aliquet. Libero justo laoreet sit amet cursus sit. Libero justo laoreet sit amet. Et odio pellentesque diam volutpat. Nunc vel risus commodo viverra maecenas accumsan lacus vel. Praesent tristique magna sit amet purus gravida quis. Nulla posuere sollicitudin aliquam ultrices sagittis orci a. Aliquet sagittis id consectetur purus ut faucibus pulvinar elementum integer. Nisl rhoncus mattis rhoncus urna neque viverra justo nec ultrices. Gravida quis blandit turpis cursus in.

Volutpat commodo sed egestas egestas. Elit pellentesque habitant morbi tristique senectus. At elementum eu facilisis sed odio morbi quis commodo. Mauris pellentesque pulvinar pellentesque habitant. Tempor commodo ullamcorper a lacus vestibulum sed arcu non odio. Adipiscing vitae proin sagittis nisl rhoncus. Ut morbi tincidunt augue interdum velit euismod in. Ut consequat semper viverra nam libero justo laoreet. Proin libero nunc consequat interdum varius sit amet mattis vulputate. Quis enim lobortis scelerisque fermentum dui faucibus in ornare. Lacinia at quis risus sed vulputate odio. Vel pretium lectus quam id leo in vitae turpis. Vel elit scelerisque mauris pellentesque. Lacinia at quis risus sed vulputate odio ut. Vitae auctor eu augue ut lectus. Ullamcorper a lacus vestibulum sed arcu non. Leo vel fringilla est ullamcorper eget nulla facilisi. Libero id faucibus nisl tincidunt eget.
"""
