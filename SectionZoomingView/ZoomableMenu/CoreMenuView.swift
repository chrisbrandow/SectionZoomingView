//
//  CoreMenuView.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/5/21.
//

import UIKit

enum MenuTag: String, Equatable, CaseIterable {
    case none = "None"
    case vegetarian = "Vegetarian"
    case glutenFree = "Gluten Free"
    case vegan = "Vegan"
    case raw = "Raw"
    case dairy = "Dairy"
}

class EntryView: UIView {
    var item: MenuItem?

    var titleLabel = UILabel()
    var bigTitleLabel = UILabel()
    var descriptionLabel = UILabel()
    var priceLabel = UILabel()
    var button = UIButton()
    var badge = UIView()
    var tagStackView: UIStackView?
    
    override var description: String {
        return self.frame.debugDescription// self.item?.name ?? " no item"
    }

    var isNarrowCell: Bool {
        guard let item = self.item
        else { return false }
        return item.itemDescription?.isEmpty != false
    }

    var isSectionHeader: Bool {
        return self.item == nil
    }
}

// https://medium.com/fabcoding/add-padding-to-uilabel-in-swift-87ba4647cf05

@IBDesignable class TagLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 4.0
    @IBInspectable var bottomInset: CGFloat = 4.0
    @IBInspectable var leftInset: CGFloat = 8.0
    @IBInspectable var rightInset: CGFloat = 8.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    // without draw(rect:), corner radius on the layer never gets applied
    override func draw(_ rect: CGRect) {
        layer.masksToBounds = true
        super.draw(rect)
    }
}

//TODO: Chris Brandow  2021-02-05 this is temporary. it's more of a builder, but any actual views hsould come from this.
class PlaceholderMenuView: UIView {
    static func createViews(columnWidth: CGFloat, datasource: MenuDataSource, target: Any?, action: Selector) -> [UIView] {

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

    private static func createSingleSectionHeaderView(for entry: Menu.Section, index: Int, columnWidth: CGFloat, action: Selector) -> UIView {

        let fontSize = CGFloat(32)
        let labelMargin = CGFloat(6)
        let view = EntryView()
        //        view.item = entry
        view.frame = CGRect(x: 0, y: 0, width: columnWidth, height: fontSize + 2*labelMargin)
        view.backgroundColor = .otk_whiteAshDark
        //                let topSpacing: CGFloat = 4.0
        let label = UILabel()
        label.text = entry.name
        label.textColor = .otk_ashDark
        view.addSubview(label)

        label.textColor = .otk_ashDark

        label.font = UIFont(name: "BrandonText-Bold", size: fontSize)// UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.frame = view.frame
        label.textAlignment = .center
        view.backgroundColor = .otk_whiteAshDark
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

    private static func createSingleView(for entry: MenuItem, index: Int, columnWidth: CGFloat, action: Selector) -> UIView {
        let defaultTextHeight = CGFloat(20)

        let view = EntryView()
        view.item = entry
        view.frame = CGRect(x: 0, y: 0, width: columnWidth, height: 2*defaultTextHeight)
        view.backgroundColor = .otk_whiteAshDark
        let topSpacing: CGFloat = 4.0
        let titleLabel = UILabel()
        titleLabel.text = entry.name
        titleLabel.textColor = .otk_ashDark

        
        titleLabel.numberOfLines = view.isNarrowCell ? 0 : 1
        titleLabel.font = UIFont(name: "BrandonText-Bold", size: 16.0)// UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .left
        let titleFrame = entry.itemDescription?.isEmpty != false && entry.name.count > 45 // hack. fix this
            ? CGRect(x: 8, y: topSpacing, width: columnWidth - 92, height: 2*defaultTextHeight + 6)
            : CGRect(x: 8, y: topSpacing, width: columnWidth - 92, height: defaultTextHeight)
        titleLabel.frame = titleFrame

        view.addSubview(titleLabel)
        let price = UILabel()
        price.text = "\(entry.price.formattedDescription ?? "")"
        price.textColor = .otk_ashDark

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
//        NSLog("size \(description.frame.size) - \(size)")
        view.addSubview(description)
        let button = UIButton(type: .custom)

        button.addTarget(target, action: action, for: .touchUpInside)
        view.addSubview(button)
        var vFrame = view.frame
        let addedHeight = description.frame.height > 0 ? description.frame.height + 4 + 8 : 8

        if let tagStackView = makeTagStackViewIfNecessary(attributes: entry.attributes) {
            tagStackView.frame = view.isNarrowCell ? CGRect.zero : CGRect(x: 8, y: defaultTextHeight + 4 + topSpacing + description.frame.height + 4, width: columnWidth - 16, height: 24)
            view.addSubview(tagStackView)

            vFrame.size.height = titleLabel.frame.height + addedHeight + 28
            view.tagStackView = tagStackView
        }
        else {
            vFrame.size.height = titleLabel.frame.height + addedHeight
            view.tagStackView = nil
        }

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

    private static func makeTagStackViewIfNecessary(attributes: [String]) -> UIStackView? {
        guard !attributes.isEmpty else {
            return nil
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8

        let tags = attributes.compactMap { MenuTag(rawValue: $0) }
        makeSubviews(with: tags).forEach { stackView.addArrangedSubview($0) }

        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(spacerView)

        return stackView
    }

    private static func makeSubviews(with tags: [MenuTag]) -> [UIView] {
        var views = [UIView]()

        tags.forEach { tag in
            let label = TagLabel()
            label.backgroundColor = .otk_greenLightest
            label.text = tag.rawValue
            if tag == .raw {
                label.text = "Contains raw meat"
            }
            label.textColor = .otk_greenDark
            label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            label.layer.cornerRadius = 4

            views.append(label)
        }

        return views
    }
}



enum EntryViewStyle {
    case normal
    case highlight
}

enum EntryMagnificationStyle {
    case normal
    case compressed
}

extension EntryView {

    func configure(compression style: EntryMagnificationStyle) {
        switch style {
        case .normal:
            self.bigTitleLabel.layer.opacity = 0.0
            self.titleLabel.layer.opacity = 1.0
            self.descriptionLabel.layer.opacity = 1.0
            self.priceLabel.layer.opacity = 1.0
            tagStackView?.layer.opacity = 1.0
        case .compressed:
            self.bigTitleLabel.layer.opacity = 1.0
            self.titleLabel.layer.opacity = 0.0
            self.descriptionLabel.layer.opacity = 0.0
            self.priceLabel.layer.opacity = 0.0
            tagStackView?.layer.opacity = 0.0
        }
    }
    func configure(style: EntryViewStyle) {
        switch style {
        case .normal:
            backgroundColor = .otk_white
            titleLabel.textColor = .otk_ashDark
            descriptionLabel.textColor = .otk_ash
            layer.borderWidth = 0
            layer.borderColor = UIColor.otk_white.cgColor
        case .highlight:
            backgroundColor = .otk_greenLightest
            layer.borderWidth = 1
            layer.borderColor = UIColor.otk_green.cgColor
        }
    }
}

extension UILabel {

    public func setHightlightedString(tintColor: UIColor, tintingString: String) {
        guard let string = self.text,
              string.isEmpty == false
        else { return }
        let tintRange = NSString(string: (self.text ?? "").lowercased()).range(of: tintingString.lowercased())
        let mutable = NSMutableAttributedString(string: string, attributes: [
            .font: self.font as Any,
            .foregroundColor: self.textColor as Any
        ])
        mutable.addAttributes([
            .font: UIFont.boldSystemFont(ofSize: self.font.pointSize),
            .foregroundColor: tintColor
        ], range: tintRange)
        print(mutable)
        self.attributedText = (mutable.copy() as? NSAttributedString) ?? NSAttributedString()
    }
}
