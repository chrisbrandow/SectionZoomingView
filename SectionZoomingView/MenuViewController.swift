//
//  MenuViewController.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/4/21.
//

import UIKit

class ParentVC: UIViewController, ZoomableViewProvider {
    @IBOutlet weak var titleLabel: UILabel?

    var zoomingView: SectionedView?

    var selectedExample = TakeoutDataSource.Example.paradiso_23_304

    func zoomableView(for frame: CGRect) -> SectionedView {
        let view: SectionedView
        if let existing = self.zoomingView {
            view = existing
        } else {
            let entryViwes = self.generateViews(for: frame.width)
            view = self.createView(with: entryViwes)
        }
        self.zoomingView = view
        return view
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let zoomableVC = segue.destination as? ZoomableViewController {
            zoomableVC.zoomableProvider = self
            self.zoomableController = zoomableVC
        } else if let vc = segue.destination as? BottomBarVC, segue.identifier == "bottomBarVC" {
            self.bottomBarVC = vc
        }
    }


    @IBOutlet var zoomableContainer: UIView?
    @IBOutlet var bottomBarContainer: UIView?
    var zoomableController: ZoomableViewController?
    var bottomBarVC: BottomBarVC?

    @IBOutlet weak var bottomBarBottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.zoomableContainer?.clipsToBounds = false
        self.titleLabel?.text = self.selectedExample.displayName

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardToggled(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardToggled(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    var bottomVCConstraint: NSLayoutConstraint? {
        return self.view.constraints.first() {
            return $0.secondAnchor == self.bottomBarVC?.view.superview?.bottomAnchor
            || $0.firstAnchor == self.bottomBarVC?.view.superview?.bottomAnchor
        }
    }
    private func createView(with strips: [UIView]) -> SectionedView {
        let viewHeight = (self.bottomBarVC?.view.superview?.frame.origin.y ?? 0)
            - (self.titleLabel?.superview?.frame.maxY ?? 0)
        let aspectRatioSubHeader = Double(view.bounds.width/viewHeight)
//        let arrangement = CGSize.bestArrangement(for: strips, matchingRatio: aspectRatioSubHeader)
        let arrangement = UIView.bestArrangement(for: strips, matchingRatio: aspectRatioSubHeader)
        let margin: CGFloat = 4.0
        var size = arrangement.rect
        let addedWidth: CGFloat = margin*CGFloat(arrangement.columns.count + 1)
        size.width += addedWidth
        let maxCount = arrangement.columns.reduce(0) { max($0, $1.count) }
        let addedHeight = margin*CGFloat(maxCount + 1)
        size.height += addedHeight
        let sectionedView = UIView(frame: CGRect(origin: .zero, size: size))
        sectionedView.backgroundColor = .otk_white

        for (index, column) in arrangement.columns.enumerated() {
            let x = CGFloat(index)*view.bounds.width + CGFloat(2 + index)*margin
            var y = CGFloat(margin)
            column.forEach({ addedView in
                addedView.frame = CGRect(x: x, y: y, width: addedView.frame.width, height: addedView.frame.height)
                y += (addedView.frame.height + margin)
                sectionedView.addSubview(addedView)
            })
        }
        return SectionedView(view: sectionedView, numberOfColumns: arrangement.columns.count, margin: 0)
    }



    /// This generates the array of individual views
    private func generateViews(for columnWidth: CGFloat) -> [UIView] {
        return PlaceholderMenuView.createViews(columnWidth: columnWidth, datasource: TakeoutDataSource(example: self.selectedExample), target: self, action: #selector(didTap(_:)))
    }

    @objc
    func didTap(_ sender: UIButton) {
        let entry = sender.superview as? EntryView
        self.selectedItems.append(entry?.item?.name ?? "")
        self.bottomBarVC?.cartLabel.text = "\(entry?.item?.name ?? "")   \(self.selectedItems.count)"
        if let name = entry?.item?.name {
            self.userDidTap(button: sender, for: name)
        }

        self.selectedBadge = (entry?.subviews.first() { $0.tag == 123 })
    }
    weak var selectedBadge: UIView?
    var selectedItems = [String]()
    @objc
    func userDidTapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if self.selectedBadge?.isHidden == false {
                let label = self.selectedBadge as? UILabel
                let stringValue = label?.text ?? "1"
                let value = Int(stringValue) ?? 1
                label?.text = String(describing: value + 1)
            }

            self.selectedBadge?.isHidden = false
            self.selectedBadge = nil
        }
    }

    @objc func keyboardToggled(_ notif: Notification) {
        guard let info = notif.userInfo as? [String: Any]
        else { return NSLog("\(notif.userInfo ?? [:])")}
        let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25

        guard notif.name != UIResponder.keyboardWillHideNotification else {
            //dismiss animation
            self.bottomBarBottomConstraint?.constant = 0
            self.bottomBarVC?.cartToParentLeadingConstraint?.constant = -(self.view.frame.width - (2*Layout.exposedViewWidth - Layout.buttonSpacing) + 8)

            self.bottomBarVC?.searchViewWidthConstraint?.constant = -68
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
            return
        }
        // will show
        if let keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) {
           let constant = keyboardRect.height - self.view.safeAreaInsets.bottom //+ self.bottomBarContainer!.frame.height
            self.bottomBarBottomConstraint?.constant = constant
            self.bottomBarVC?.cartToParentLeadingConstraint?.constant = -self.view.frame.width + 60
            self.bottomBarVC?.searchViewWidthConstraint?.constant = 0
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }

}
class BottomBarVC: UIViewController {
    @IBOutlet weak var cartView: UIView?
    @IBOutlet weak var searchView: UIView?

    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var cartToParentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField?

    @IBOutlet weak var cartLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.cartView?.layer.cornerRadius = 4.0
        self.cartView?.layer.masksToBounds = true

        self.searchView?.layer.cornerRadius = 4.0
        self.searchView?.layer.masksToBounds = true

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.view.addGestureRecognizer(tapGR)
        self.searchImageTrailingConstraint.isActive = false
        NSLayoutConstraint.activate([
            self.searchImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8.0)
        ])
        self.searchTextField?.alpha = 0
        self.searchTextField?.delegate = self
    }


    @objc
    func didTap(_ tapGR: UITapGestureRecognizer) {
        guard let tappedView = tapGR.view
        else { return }
        let tapPoint = tapGR.location(in: tappedView)
        if self.currentState == .cart {
            if self.cartView?.frame.contains(tapPoint) == true {
                // do something with the cart
            } else {
                self.toggleViews()
            }
        } else {
            if self.searchView?.frame.contains(tapPoint) == true {
                // do something with the search
                if self.searchTextField?.isFirstResponder == true {
                    self.endSearch()
                }
            } else {
                self.toggleViews()
            }
        }
    }

    private var isShowingCart: Bool {
        return true
    }

    enum Presented {
        case cart
        case search
    }

    private var currentState: Presented {
        return self.textFieldLeadingConstraint?.constant == 70 ? .cart : .search
    }


    private var nextState: Presented {
        return self.textFieldLeadingConstraint?.constant == 70 ? .search : .cart
    }

    private func toggleViews() {
        let newState = self.nextState

        let upatedConstant = newState == .search// self.cartToParentLeadingConstraint.constant == Layout.floatingLeadingMargin
            ? -(self.view.frame.width - (2*Layout.exposedViewWidth - Layout.buttonSpacing) + 8)
            : Layout.floatingLeadingMargin
        self.cartToParentLeadingConstraint?.constant = upatedConstant
        self.view.gestureRecognizers?.forEach({$0.isEnabled = false })

        let textLeading: CGFloat = newState == .search ? 8.0 : 70.0

        self.textFieldLeadingConstraint.constant = textLeading

        //TODO: Chris Brandow  2021-02-02 here's how i want the animation to go
        // 1. when cart is apparent, the bag should not be visible
        // 2. when the cart appears or disappears, the bag should move with it, but fade in/out
        // 2.5. the cart view should have normal stuff, # items, total price, and a "view cart" button
        // 3. i want to try to have the magnifying glass stay in its position with regards to the phone screen
        // 4. have the text field move with the search view underneath the search glass
        UIView.animate(withDuration: 0.26, delay: 0.0, options: .curveEaseInOut, animations: {
            self.searchTextField?.alpha = textLeading == 70 ? 0.0 : 1.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.view.gestureRecognizers?.forEach({$0.isEnabled = true })
            print("done")
        })
    }
}

extension BottomBarVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (self.parent as? ParentVC)?.zoomingView?.highlight(text: textField.text ?? "")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endSearch()
        return true
    }

    private func endSearch() {
        self.searchTextField?.resignFirstResponder()
        // obvs, this should eventually only happen if values are found
        (self.parent as? ParentVC)?.zoomableController?.setZoomableToMaximumMagnification()
        // also shoud add a "clear highlighting" button
    }


}
