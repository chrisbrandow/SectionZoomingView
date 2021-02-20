//
//  CoreMenuView.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/5/21.
//

import UIKit

struct Layout {
    /// 4.0
    static let menuItemMargin: CGFloat = 4.0
    /// 16.0
    static let buttonSpacing: CGFloat = 16.0
    /// 16.0
    static let bottomDrawerMargin: CGFloat = 16.0
    /// 8.0
    static let bottomDrawerInterMargin: CGFloat = 8.0
    /// 8.0
    static let floatingLeadingMargin: CGFloat = 8.0
    /// 80.0
    static let exposedViewWidth: CGFloat = 80.0
    /// 4.0
    static let cornerRadius: CGFloat = 4.0
}

extension CGFloat {
    /// 4.0
    static let otk_menuItemMargin: CGFloat = 4.0
    /// 16.0
    static let otk_buttonSpacing: CGFloat = 16.0
    /// 16.0
    static let otk_bottomDrawerMargin: CGFloat = 16.0
    /// 32.0
    static let otk_bottomButtonSpacing: CGFloat = 32.0
    /// 32.0
    static let otk_incrementButtonHeight: CGFloat = 40
    /// 8.0
    static let otk_bottomDrawerInterMargin: CGFloat = 8.0
    /// 8.0
    static let otk_floatingLeadingMargin: CGFloat = 8.0
    /// 80.0
    static let otk_exposedViewWidth: CGFloat = 80.0
    /// 4.0
    static let otk_cornerRadius: CGFloat = 4.0
}

extension UIColor {
    static var otk_red: UIColor { return UIColor(named: "otKit_red") ?? .black }
    static var otk_ash: UIColor { return UIColor(named: "otKit_ash") ?? .black }
    static var otk_ashDark: UIColor { return UIColor(named: "otKit_ash_dark") ?? .black }
    static var otk_ashDarker: UIColor { return UIColor(named: "otKit_ash_darker") ?? .black }
    static var otk_ashLight: UIColor { return UIColor(named: "otKit_ash_light") ?? .black }
    static var otk_ashLighter: UIColor { return UIColor(named: "otKit_ash_lighter") ?? .black }
    static var otk_ashLightest: UIColor { return UIColor(named: "otKit_ash_lightest") ?? .black }
    static var otk_greenLighter: UIColor { return UIColor(named: "otKit_green_lighter") ?? .black }
    static var otk_white: UIColor { return UIColor(named: "otKit_white") ?? .black }
    static var otk_white_white: UIColor { return UIColor(named: "otKit_white_white") ?? .black }
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
        var bigFrame = view.bounds
        bigFrame.origin.x += 8.0
        bigFrame.size.width -= 8.0
        let bigTitleView = UILabel(frame: bigFrame)
        bigTitleView.font = UIFont(name: "BrandonText-Bold", size: 40)
        bigTitleView.textColor = .otk_ashDark
        bigTitleView.textAlignment = .center
        view.addSubview(bigTitleView)
        bigTitleView.text = entry.name
        view.bigTitleLabel = bigTitleView
        view.titleLabel = label
        return view
    }

    private static func createSingleView(for entry: TakeoutMenuItem, index: Int, columnWidth: CGFloat, action: Selector) -> UIView {
        let defaultTextHeight = CGFloat(20)

        let view = EntryView()
        view.item = entry
        view.frame = CGRect(x: 0, y: 0, width: columnWidth, height: 2*defaultTextHeight)
        view.backgroundColor = .otk_whiteAshDark
        let topSpacing: CGFloat = 4.0
        let titleLabel = UILabel()
        titleLabel.text = entry.name
        titleLabel.textColor = .otk_ashDarker

        
        titleLabel.numberOfLines = view.isNarrowCell ? 0 : 1
        titleLabel.font = UIFont(name: "BrandonText-Bold", size: 16.0)// UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .left
        let titleFrame = entry.itemDescription?.isEmpty != false && entry.name.count > 45 // hack. fix this
            ? CGRect(x: 8, y: topSpacing, width: columnWidth - 92, height: 2*defaultTextHeight)
            : CGRect(x: 8, y: topSpacing, width: columnWidth - 92, height: defaultTextHeight)
        titleLabel.frame = titleFrame

        view.addSubview(titleLabel)

        let price = UILabel()
        price.text = "\(entry.price.formattedDescription ?? "")"
        price.textColor = .otk_ashDarker

        price.sizeToFit()
        price.frame = CGRect(x: columnWidth - (price.frame.width + 16), y: topSpacing, width:  price.frame.width + 10, height: defaultTextHeight)
        price.numberOfLines = 1
        price.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        price.textAlignment = .right
        view.addSubview(price)

        var bFrame = price.frame
        bFrame.size.width = 1.5*bFrame.size.height
        if view.isNarrowCell {
            bFrame.origin.x -= (price.frame.height + 4)
        } else {
            bFrame.origin.y += bFrame.height + 4
            bFrame.origin.x += (price.frame.width - bFrame.width)
        }
        let badge = UIView(frame: price.frame)
        badge.backgroundColor = .otk_red
        badge.layer.cornerRadius = bFrame.height/2.0
        badge.layer.masksToBounds = true
        badge.tag = 123
        badge.isHidden = true
        view.insertSubview(badge, belowSubview: price)

        let description = UILabel()
        description.text = entry.itemDescription
        description.textColor = .otk_ashLight

        //            description.frame = CGRect(x: 8, y: defaultTextHeight, width: columnWidth - 92, height: 2.0*defaultTextHeight)
        description.numberOfLines = 0

        description.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        description.textAlignment = .left

        //
        let size = view.isNarrowCell
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
        
        vFrame.size.height = titleLabel.frame.height + addedHeight
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
        var bigFrame = view.bounds
        bigFrame.origin.x += 8.0
        bigFrame.size.width -= 8.0
        let bigTitleView = UILabel(frame: bigFrame)
        bigTitleView.font = UIFont(name: "BrandonText-Bold", size: view.isNarrowCell ? 24.0 : 32)
        bigTitleView.textColor = .otk_ashDark
        view.addSubview(bigTitleView)
        
        bigTitleView.text = entry.name
        view.descriptionLabel = description
        view.priceLabel = price
        view.titleLabel = titleLabel
        view.button = button
        view.bigTitleLabel = bigTitleView
        view.badge = badge
        return shadowView
    }
}
