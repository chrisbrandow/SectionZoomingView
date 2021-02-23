//
//  ParentVCDrawerExtension.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/11/21.
//

import UIKit

extension ParentVC {
    @objc
    func tapBackgroundAction(_ sender: UITapGestureRecognizer) {
        guard let container = sender.view?.subviews.first,
              sender.location(in: container).y < 0
        else { return }
        self.dismiss(animated: true) {
            NSLog("by bye")
        }
    }

    func userDidTap(button: UIButton, for item: TakeoutMenuItem) {//}, in view: ZoomableView) {
        let presentedController = UIViewController()
        presentedController.view.frame = self.view.frame
        let tapBackgroundGR = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundAction(_:)))
        presentedController.view.addGestureRecognizer(tapBackgroundGR)
        guard let entryView = button.superview as? EntryView
        else { return }
        let containerView = UIView(autoAddedTo: presentedController.view)

        containerView.backgroundColor = .otk_whiteAsh

        let tLabel = UILabel(autoAddedTo: containerView)
        let pLabel = UILabel(autoAddedTo: containerView)
        let dLabel = UILabel(autoAddedTo: containerView)
        let sView = UIStackView(autoAddedTo: containerView)
        let mButton = UIButton(autoAddedTo: containerView)
        let pButton = UIButton(autoAddedTo: containerView)
        let qLabel = UILabel(autoAddedTo: containerView)
        let aButton = UIButton(autoAddedTo: containerView)
        let cButton = UIButton(autoAddedTo: containerView)

        pLabel.numberOfLines = 1
        pLabel.font = UIFont(name: "BrandonText-Bold", size: 18)
        pLabel.textColor = .otk_ashDark
        pLabel.text = item.price.formattedDescription
        pLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        pLabel.textAlignment = .right

        tLabel.numberOfLines = 0
        tLabel.font = UIFont(name: "BrandonText-Bold", size: 24)
        tLabel.textColor = .otk_ashDarker
        tLabel.text = item.name

        dLabel.numberOfLines = 0
        dLabel.font = UIFont.systemFont(ofSize: 14)
        dLabel.textColor = .otk_ash
        dLabel.text = item.itemDescription

        sView.axis = .horizontal
        sView.addArrangedSubview(mButton)
        sView.addArrangedSubview(qLabel)
        sView.addArrangedSubview(pButton)
        sView.spacing = .otk_bottomButtonSpacing

        mButton.setTitle("–", for: .normal)

        mButton.isEnabled = false  //depends on item count
        pButton.setTitle("+", for: .normal)

        [mButton, pButton].forEach({
            $0.backgroundColor = .otk_white
            $0.layer.cornerRadius = CGFloat.otk_incrementButtonHeight/2.0
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1.0/UIScreen.main.scale
            $0.layer.borderColor = UIColor.otk_ashLight.cgColor
            $0.setTitleColor(.otk_ashDark, for: .normal)
            $0.setTitleColor(.otk_ashLight, for: .disabled)
            $0.titleLabel?.font = UIFont(name: "BrandonText-Bold", size: 18)
        })


        qLabel.font = UIFont(name: "BrandonText-Bold", size: 18)


        aButton.titleLabel?.font = UIFont(name: "BrandonText-Bold", size: 18)

        cButton.setTitle("Cancel", for: .normal)
        cButton.layer.cornerRadius = .otk_cornerRadius
        cButton.layer.masksToBounds = true
        cButton.layer.borderWidth = 1.0/UIScreen.main.scale
        cButton.layer.borderColor = UIColor.otk_ashDark.cgColor
        cButton.titleLabel?.font = UIFont(name: "BrandonText-Bold", size: 18)
        cButton.setTitleColor(.otk_ashDark, for: .normal)
        let count: Int
        if let priceText = entryView.priceLabel.text,
           let _ = priceText.firstIndex(of: "•"),
           let index = priceText.firstIndex(of: " ") {
            let current = priceText[..<index]
            count = Int(current) ?? 1
            qLabel.text = String(describing: count)
        } else {
            count = 0
            qLabel.text = "1"
        }

        aButton.setTitle(count == 0 ? "Add to cart" : "Update quantity in cart", for: .normal)

        aButton.backgroundColor = .otk_red
        aButton.layer.cornerRadius = .otk_cornerRadius

        pButton.addAction(UIAction(handler: { _IOFBF in
            let count = Int(qLabel.text ?? "") ?? 1
            qLabel.text = String(describing: count + 1)
        }), for: .touchUpInside)
        
        mButton.isEnabled = count > 0
        mButton.addAction(UIAction(handler: { _IOFBF in
            let count = Int(qLabel.text ?? "") ?? 1
            let updated = max(0, count - 1)
            mButton.isEnabled = updated > 0
            qLabel.text = String(describing: updated)
        }), for: .touchUpInside)

        aButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true, completion: nil)
            let count = Int(qLabel.text ?? "") ?? 1
            self.update(value: count, for: entryView)
            self.items[item] = count

            self.bottomBarVC?.cartMiniView.totalLabel?.text = self.miniCartText()
            mButton.isEnabled = count > 0
        }), for: .touchUpInside)

        cButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: presentedController.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: presentedController.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: presentedController.view.bottomAnchor),
            tLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .otk_bottomDrawerMargin),
            tLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .otk_bottomDrawerMargin),
            pLabel.firstBaselineAnchor.constraint(equalTo: tLabel.firstBaselineAnchor),
            pLabel.leadingAnchor.constraint(equalTo: tLabel.trailingAnchor, constant: .otk_bottomDrawerMargin),
            pLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.otk_bottomDrawerMargin),
            dLabel.topAnchor.constraint(equalTo: tLabel.bottomAnchor, constant: 2*CGFloat.otk_bottomDrawerInterMargin),
            dLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .otk_bottomDrawerMargin),
            dLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.otk_bottomDrawerMargin),
            mButton.heightAnchor.constraint(equalToConstant: .otk_incrementButtonHeight),
            mButton.heightAnchor.constraint(equalTo: mButton.widthAnchor),
            pButton.heightAnchor.constraint(equalToConstant: .otk_incrementButtonHeight),
            pButton.heightAnchor.constraint(equalTo: pButton.widthAnchor),
            sView.topAnchor.constraint(equalTo: dLabel.bottomAnchor, constant: item.itemDescription?.isEmpty != false ? 0 : 2*CGFloat.otk_bottomDrawerInterMargin),
            sView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            aButton.heightAnchor.constraint(equalToConstant: 50.0),
            aButton.topAnchor.constraint(equalTo: sView.bottomAnchor, constant: 2*CGFloat.otk_bottomDrawerInterMargin),
            aButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .otk_bottomDrawerMargin),
            aButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.otk_bottomDrawerMargin),
            cButton.heightAnchor.constraint(equalToConstant: 50.0),
            cButton.topAnchor.constraint(equalTo: aButton.bottomAnchor, constant: .otk_bottomDrawerInterMargin),
            cButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .otk_bottomDrawerMargin),
            cButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.otk_bottomDrawerMargin),
            cButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
        ])

        self.present(presentedController, animated: true) {

        }
    }

    

    private func update(value: Int, for view: EntryView) {
        guard var priceText = view.priceLabel.text,
              value > 0 else {
            view.badge.isHidden = true
            return
        }

        view.badge.isHidden = false
        view.priceLabel.font = value == 0
            ? UIFont.systemFont(ofSize: 14)
            : UIFont(name: "BrandonText-Bold", size: 14.0)
        view.priceLabel.textColor = .otk_white_white
        let originalFrame = view.priceLabel.frame
        if let _ = priceText.firstIndex(of: "•"),
           let index = priceText.firstIndex(of: " ") {
            priceText.replaceSubrange(priceText.startIndex..<index, with: "\(value)")
            view.priceLabel.text = priceText
        } else {
            view.priceLabel.text = "\(value) • " + priceText
        }
        view.priceLabel.sizeToFit()
        var newFrame = view.priceLabel.frame
        newFrame.origin.x = newFrame.origin.x - (newFrame.width - originalFrame.width)
        newFrame.size.height = originalFrame.height
        view.priceLabel.frame = newFrame
        newFrame.origin.x -= 4
        newFrame.size.width += 8
        view.badge.layer.cornerRadius = view.badge.frame.size.height/2.0 - 1
        view.badge.frame = newFrame
        view.badge.backgroundColor = .otk_red
        
    }
}

extension UIView {
    public convenience init(autoAddedTo parent: UIView) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
    }
}
