//
//  MenuParentViewControllerDrawerExtension.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/11/21.
//

import UIKit
import SwiftUI

extension MenuParentViewController {
    @objc
    func tapBackgroundAction(_ sender: UITapGestureRecognizer) {
        guard let container = sender.view?.subviews.first,
              sender.location(in: container).y < 0
        else { return }
        self.dismiss(animated: true) {
            NSLog("by bye")
        }
    }

    func userDidTap(button: UIButton, for item: MenuItem) {//}, in view: ZoomableView) {
        let v = AddToCartView(menuItem: item, quantity: 1) { cartItem in
            print("yay you added a thing to your cart. Congratulations. \(cartItem)")
        } onCancel: { [unowned self] in
            self.dismiss(animated: true)
        }

        let vc = UIHostingController(rootView: v)
//        vc.view.frame = self.view.frame
        let tapBackgroundGR = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundAction(_:)))
        vc.view.addGestureRecognizer(tapBackgroundGR)

        vc.view.sizeToFit()
        vc.view.backgroundColor = .clear

        self.present(vc, animated: true) {

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
