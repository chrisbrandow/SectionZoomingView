//
//  MenuViewController.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/4/21.
//

import UIKit

class ParentVC: UIViewController, ZoomableViewProvider {

    var items = [TakeoutMenuItem: Int]()

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
    var shadowLine = UIView()

    @IBOutlet weak var bottomBarBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var bottomBarHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.zoomableContainer?.clipsToBounds = false
        self.titleLabel?.text = self.selectedExample.displayName

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardToggled(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardToggled(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        if let container = self.titleLabel?.superview {
            self.shadowLine.translatesAutoresizingMaskIntoConstraints = false
            self.shadowLine.backgroundColor = UIColor.otk_ashLight.withAlphaComponent(0.4)
            container.addSubview(self.shadowLine)
            NSLayoutConstraint.activate([
                self.shadowLine.topAnchor.constraint(equalTo: container.bottomAnchor),
                self.shadowLine.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                self.shadowLine.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                self.shadowLine.heightAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale)
            ])
        }
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
        return PlaceholderMenuView.createViews(columnWidth: columnWidth, datasource: TakeoutDataSource(example: self.selectedExample), target: self, action: #selector(ParentVC.didTap(_:)))
    }

    @objc
    func didTap(_ sender: UIButton) {
        let entry = sender.superview as? EntryView
        self.selectedItems.append(entry?.item?.name ?? "")
        let count =  self.items.reduce(0) { $0 + $1.value }
        self.bottomBarVC?.cartLabel.text = "\(count) items in cart"
        if let item = entry?.item {
            self.userDidTap(button: sender, for: item)
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
        
        if notif.name == UIResponder.keyboardWillHideNotification {
            //dismiss animation
            self.bottomBarBottomConstraint?.constant = 0
            self.bottomBarVC?.cartToParentLeadingConstraint?.constant = -(self.view.frame.width - (2*Layout.exposedViewWidth - Layout.buttonSpacing) + 8)
            self.bottomBarVC?.searchImageView.image = UIImage(named: "ic_search_template")
            self.animateImageChange(duration: duration)

            self.bottomBarVC?.searchViewWidthConstraint?.constant = -68
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.zoomingView?.setButtons(enabled: true)
            }
            return
        } else if let keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) {
            let constant = keyboardRect.height - self.view.safeAreaInsets.bottom
            self.bottomBarBottomConstraint?.constant = constant
            self.bottomBarVC?.cartToParentLeadingConstraint?.constant = -self.view.frame.width + 60
            self.bottomBarVC?.searchViewWidthConstraint?.constant = 0
            self.bottomBarVC?.searchImageView.image = UIImage(named: "ic_close")
            self.bottomBarVC?.searchImageView.tintColor = .otk_white
            self.animateImageChange(duration: duration)

            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.zoomingView?.setButtons(enabled: false)
            }
        }
    }

    private func animateImageChange(duration: TimeInterval) {
        let transition = CATransition()
        transition.duration = 0.12
        transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        transition.type = .fade;
        self.bottomBarVC?.searchImageView?.layer.add(transition, forKey: "fade")
    }

}
class BottomBarVC: UIViewController {
    @IBOutlet weak var cartView: UIView?
    @IBOutlet weak var searchView: UIView?

    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var cartToParentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var cartWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var cartLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField?.textColor = .otk_white
        self.searchTextField?.tintColor = .otk_white
        
        self.cartView?.layer.cornerRadius = 4.0
        self.cartView?.layer.masksToBounds = true
        self.cartImageView.tintColor = .otk_white_white


        self.searchView?.layer.cornerRadius = 4.0
        self.searchView?.layer.masksToBounds = true

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(BottomBarVC.didTap(_:)))
        self.view.addGestureRecognizer(tapGR)
        self.searchImageTrailingConstraint.isActive = false
        NSLayoutConstraint.activate([
            self.searchImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8.0)
        ])
        self.searchTextField?.alpha = 0
        self.searchTextField?.delegate = self
        self.searchTextField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }


    // make the bottom container FLOATING!!
    @objc
    func didTap(_ tapGR: UITapGestureRecognizer) {
        guard let tappedView = tapGR.view
        else { return }
        let tapPoint = tapGR.location(in: tappedView)
        if self.currentState == .cart {
            if self.cartView?.frame.contains(tapPoint) == true {
                if self.cartView!.frame.height < 51 {
                    (self.parent as? ParentVC)?.bottomBarHeightConstraint?.constant = 300
                    self.cartToParentLeadingConstraint.constant = 16.0
                    self.cartWidthConstraint.constant = -.otk_bottomDrawerMargin*2
                    self.cartImageView.image = UIImage.caretImage
                    self.cartImageView.animateImageChange(duration: 0.2)

                    if let menuItems = (self.parent as? ParentVC)?.items,
                        menuItems.isEmpty == false {
                        let labels: [UILabel] = menuItems.map({
                            let label = UILabel()
                            label.text = "\($0.value) - \($0.key.name) * \($0.key.price.formattedDescription ?? "")"
                            label.translatesAutoresizingMaskIntoConstraints = false
                            label.numberOfLines = 0
                            label.textColor = .otk_white_white
                            label.textAlignment = .right
                            label.font = UIFont(name: "BrandonText-Bold", size: 14.0)
                            return label
                        })

                        let stackView = UIStackView(arrangedSubviews: labels)
                        stackView.translatesAutoresizingMaskIntoConstraints = false
                        stackView.axis = .vertical
                        stackView.spacing = .otk_bottomDrawerInterMargin
                        var frame = self.cartView?.bounds ?? .zero
                        frame.origin.y += 30
                        frame.size.height -= 30
                        stackView.frame = frame
                        self.cartView?.addSubview(stackView)
                        NSLayoutConstraint.activate([
                            stackView.topAnchor.constraint(equalTo: self.cartLabel!.bottomAnchor, constant: .otk_bottomDrawerInterMargin),
                            stackView.leadingAnchor.constraint(equalTo: self.cartView!.leadingAnchor, constant: .otk_bottomDrawerMargin),
                            stackView.trailingAnchor.constraint(equalTo: self.cartView!.trailingAnchor, constant: -.otk_bottomDrawerMargin),
                        ])
                    }


                } else {
                    self.cartView?.subviews.first(where: { $0 is UIStackView })?.removeFromSuperview()

                    self.cartToParentLeadingConstraint.constant = 8.0
                    self.cartWidthConstraint.constant = -76.0
                    (self.parent as? ParentVC)?.bottomBarHeightConstraint?.constant = 50

                    self.cartImageView.image = UIImage(named: "ic_pickup_red_24")
                    self.cartImageView.animateImageChange(duration: 0.2)
                }
                
                UIView.animate(withDuration: 0.2) {
                    (self.parent as? ParentVC)?.view.layoutIfNeeded()
                }

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


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endSearch()
        return true
    }

    private func endSearch() {
        self.searchTextField?.resignFirstResponder()
        // obvs, this should eventually only happen if values are found
        (self.parent as? ParentVC)?.zoomableController?.setZoomableToMaximumCompression()
        // also shoud add a "clear highlighting" button
    }

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        if (self.parent as? ParentVC)?.zoomingView?.highlight(text: textField.text ?? "") == true {
            (self.parent as? ParentVC)?.zoomableController?.setZoomableToMaximumCompression()
        }
    }


}

