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
        let v = AddToCartView(menuItem: item, diner: GlobalState.shared.diner, quantity: 1) { cartItem in
            GlobalState.shared.addToCart(cartItem)
            self.dismiss(animated: true)
        } onCancel: { [unowned self] in
            self.dismiss(animated: true)
        }

        let vc = UIHostingController(rootView: v)
        let tapBackgroundGR = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundAction(_:)))
        vc.view.addGestureRecognizer(tapBackgroundGR)

        vc.view.sizeToFit()
        vc.view.backgroundColor = .clear

        self.present(vc, animated: true) {}
    }
}

extension UIView {
    public convenience init(autoAddedTo parent: UIView) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
    }
}
