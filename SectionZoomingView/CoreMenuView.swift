//
//  CoreMenuView.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/5/21.
//

import UIKit

struct Layout {
    static let menuItemMargin: CGFloat = 4.0
    static let buttonSpacing: CGFloat = 16.0
    static let floatingLeadingMargin: CGFloat = 8.0
    static let exposedViewWidth: CGFloat = 80.0
    static let cornerRadius: CGFloat = 4.0
}

extension UIColor {
    static var otk_red: UIColor { return UIColor(named: "otKit_red") ?? .black }
    static var otk_ash: UIColor { return UIColor(named: "otKit_ash") ?? .black }
    static var otk_ashDarker: UIColor { return UIColor(named: "otKit_ash_darker") ?? .black }
    static var otk_ashLight: UIColor { return UIColor(named: "otKit_ash_light") ?? .black }
    static var otk_ashLighter: UIColor { return UIColor(named: "otKit_ash_lighter") ?? .black }
    static var otk_ashLightest: UIColor { return UIColor(named: "otKit_ash_lightest") ?? .black }
    static var otk_white: UIColor { return UIColor(named: "otKit_white") ?? .black }
    static var otk_whiteAsh: UIColor { return UIColor(named: "otKit_white_ash") ?? .black }
    static var otk_whiteAshDark: UIColor { return UIColor(named: "otKit_white_ash_dark") ?? .black }
}


//TODO: Chris Brandow  2021-02-05 this is temporary. it's more of a builder, but any actual views hsould come from this.
class PlaceholderMenuView: UIView {
    static func createViews(columnWidth: CGFloat, datasource: TakeoutDataSource, target: Any?, action: Selector) -> [UIView] {

        var alllviews = [UIView]()
        var origin = CGFloat(0)
        for section in datasource.entireMenu.allSections {
            let header = createSingleSectionHeaderView(for: section, index: alllviews.count, columnWidth: columnWidth, action: action)
            header.frame.origin.y = origin
            alllviews.append(header)
            origin += header.frame.size.height
            for item in section.items {
                let itemView = Self.createSingleView(for: item, index: alllviews.count, columnWidth: columnWidth, action: action)
                itemView.frame.origin.y = origin
                alllviews.append(itemView)
                origin += itemView.frame.size.height
            }
        }
        return alllviews

    }

    private static func createSingleSectionHeaderView(for entry: TakeoutMenuSection, index: Int, columnWidth: CGFloat, action: Selector) -> UIView {

        let fontSize = CGFloat(32)
        let labelMargin = CGFloat(6)
        let view = EntryView()
        //        view.item = entry
        view.frame = CGRect(x: 0, y: 0, width: columnWidth, height: fontSize + 2*labelMargin)
        view.backgroundColor = .otk_whiteAshDark
        //                let topSpacing: CGFloat = 4.0
        let label = UILabel()
        label.text = entry.name
        label.textColor = .otk_ashDarker
        view.addSubview(label)

        label.textColor = .otk_ashDarker

        label.font = UIFont(name: "BrandonText-Bold", size: fontSize)// UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.frame = view.frame
        label.textAlignment = .center
        view.backgroundColor = .otk_ashLightest
        return view
    }

    private static func createSingleView(for entry: TakeoutMenuItem, index: Int, columnWidth: CGFloat, action: Selector) -> UIView {
        let defaultTextHeight = CGFloat(20)

        let view = EntryView()
        view.item = entry
        view.frame = CGRect(x: 0, y: 0, width: columnWidth, height: 2*defaultTextHeight)
        view.backgroundColor = .otk_whiteAshDark
        let topSpacing: CGFloat = 4.0
        let label = UILabel()
        label.text = entry.name
        label.textColor = .otk_ashDarker

        let isNarrowCell = entry.itemDescription?.isEmpty != false
        label.numberOfLines = isNarrowCell ? 0 : 1
        label.font = UIFont(name: "BrandonText-Bold", size: 16.0)// UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        let titleFrame = entry.itemDescription?.isEmpty != false && entry.name.count > 45 // hack. fix this
            ? CGRect(x: 8, y: topSpacing, width: columnWidth - 92, height: 2*defaultTextHeight)
            : CGRect(x: 8, y: topSpacing, width: columnWidth - 92, height: defaultTextHeight)
        label.frame = titleFrame

        view.addSubview(label)

        //        if index.isMultiple(of: 25),
        //           sections.isEmpty == false {
        //            let header = sections.removeFirst()
        //            label.text = header
//            label.textColor = .otk_ashDarker
//
//            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//            label.frame = view.frame
//            label.textAlignment = .center
//            view.backgroundColor = .otk_ashLightest
//            return view
//        }


        let price = UILabel()
        price.text = entry.price.formattedDescription
        price.textColor = .otk_ashDarker
        price.frame = CGRect(x: columnWidth - 60, y: topSpacing, width:  55, height: defaultTextHeight)
        price.numberOfLines = 1
        price.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        price.textAlignment = .right
        view.addSubview(price)

        var bFrame = price.frame
        bFrame.size.width = 1.5*bFrame.size.height
        if isNarrowCell {
            bFrame.origin.x -= (price.frame.height + 4)
        } else {
            bFrame.origin.y += bFrame.height + 4
            bFrame.origin.x += (price.frame.width - bFrame.width)
        }
        let badge = UILabel(frame: bFrame)
        badge.backgroundColor = .otk_red
        badge.layer.cornerRadius = bFrame.height/2.0
        badge.layer.masksToBounds = true
        badge.textColor = .otk_white
        badge.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        badge.textAlignment = .center
        badge.text = "1"
        badge.tag = 123
        badge.isHidden = true
        view.addSubview(badge)

        let description = UILabel()
        description.text = entry.itemDescription
        description.textColor = .otk_ashLight

        //            description.frame = CGRect(x: 8, y: defaultTextHeight, width: columnWidth - 92, height: 2.0*defaultTextHeight)
        description.numberOfLines = 0

        description.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        description.textAlignment = .left

        //
        let size = isNarrowCell
            ? CGRect.zero
            : ((entry.itemDescription ?? "" )as NSString).boundingRect(with: CGSize(width: columnWidth - 92, height: 100000), options: .usesLineFragmentOrigin, attributes: [.font: description.font!], context: nil)
        description.frame = CGRect(origin: CGPoint(x: 8, y: defaultTextHeight + 4 + topSpacing), size: size.size)
        NSLog("size \(description.frame.size) - \(size)")
        view.addSubview(description)

        let button = UIButton(type: .custom)

        button.addTarget(target, action: action, for: .touchUpInside)
        view.addSubview(button)
        var vFrame = view.frame
        let addedHeight = description.frame.height > 0 ? description.frame.height + 4 + 8 : 8

        vFrame.size.height = label.frame.height + addedHeight
        button.frame = vFrame
        let cornerRadius: CGFloat = Layout.menuItemMargin
        let shadowView = UIView(frame: vFrame)
        shadowView.layer.cornerRadius = cornerRadius
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowColor = UIColor.darkGray.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = Layout.menuItemMargin/2.0
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 3).cgPath
        shadowView.layer.masksToBounds = false
        view.frame = shadowView.bounds
        view.layer.cornerRadius = Layout.menuItemMargin
        shadowView.addSubview(view)
        return shadowView
    }
}
