//
//  ParentVCDrawerExtension.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/11/21.
//

import UIKit

extension ParentVC {
    func userDidTap(button: UIButton, for item: String) {//}, in view: ZoomableView) {
        let presentedController = UIViewController()
        presentedController.view.frame = self.view.frame
        //        presentedController.view.backgroundColor = .white
        var vcFrame = presentedController.view.frame

        let containerView = UIView(frame: CGRect(x: 0, y: 500, width: self.view.frame.width, height: 400))
        containerView.backgroundColor = .otk_whiteAsh
        presentedController.view.addSubview(containerView)
        let selectedLabel = UILabel()
        selectedLabel.text = "Selected item:"
        selectedLabel.frame = CGRect(x: 16, y: 32, width: vcFrame.width - 32, height: 40)
        selectedLabel.numberOfLines = 1

        selectedLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        selectedLabel.textAlignment = .center
        selectedLabel.textColor = .otk_ashDarker
        containerView.addSubview(selectedLabel)

        let label = UILabel()
        label.text = item
        label.textColor = .otk_ashDarker
        label.frame = CGRect(x: 16, y: 72, width: vcFrame.width - 32, height: 40)
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        containerView.addSubview(label)


        let addButton = UIButton(type: .custom)
        addButton.frame = CGRect(x: vcFrame.midX - 100, y: 144, width: 200, height: 80)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        addButton.backgroundColor = .otk_red
        addButton.setTitle("Add to cart", for: .normal)
        addButton.addTarget(self, action: #selector(userDidTapDismiss(_:)), for: .touchUpInside)
        addButton.layer.cornerRadius = 4.0
        addButton.layer.masksToBounds = true
        containerView.addSubview(addButton)
        self.present(presentedController, animated: true) {
            if let view = button.superview {
                if let existingBadge = view.subviews.first(where: { $0 is UILabel && $0.frame.width - 20 < 2  && $0.frame.height - 20 < 2}) as? UILabel {
//                    self.temporaryBadge = existingBadge
                    //                    let value = Int(existingBadge.text ?? "0") ?? 0
                    //                    existingBadge.text = String(describing: value + 1)
                    return
                }

                let badge = UILabel()
                badge.text = "0"
                let edgeAlignmentAdjustmentForTextInset = CGFloat(6.0)
                badge.frame = CGRect(x: view.frame.width - 28 - edgeAlignmentAdjustmentForTextInset, y: view.frame.height - 28, width: 20, height: 20)
                badge.numberOfLines = 1
                badge.textColor = .white
                badge.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
                badge.textAlignment = .center
                badge.layer.cornerRadius = 10
                badge.layer.masksToBounds = true
                badge.backgroundColor = .otk_red
                badge.isHidden = true
                view.addSubview(badge)
//                self.temporaryBadge = badge
            }
        }
    }
}
