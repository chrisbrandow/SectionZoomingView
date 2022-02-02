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

    @IBOutlet weak var backingView: UIView!
    @IBOutlet weak var zoomableTopConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "hasSeenZoomGesture")
        self.zoomableContainer?.clipsToBounds = false
        if let _ = self.navigationController {
            self.zoomableTopConstraint.constant = 0
            self.title = self.selectedExample.displayName
            self.titleLabel?.isHidden = true
            self.backingView.backgroundColor = .otk_white
            self.view.backgroundColor = .otk_white
        } else {
            self.titleLabel?.text = self.selectedExample.displayName
        }


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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let delay = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.addPinchToZoomIndicator()
            UserDefaults.standard.set(true, forKey: "hasSeenZoomGesture")
        }

    }

    // make the bottom container FLOATING!!
    lazy var pinchToZoomLayer: CALayer? = {
        if UserDefaults.standard.bool(forKey: "hasSeenZoomGesture") == true {
            return nil
        }

        let layer = CALayer()
        layer.frame = self.view.bounds
        layer.backgroundColor = UIColor.clear.cgColor
        let origin1 = CGPoint(x: 3*layer.frame.width/4.0, y: layer.frame.height/4.0)
        let origin2 = CGPoint(x: layer.frame.width/4.0, y: 3*layer.frame.height/4.0)

        let circle1 = CAShapeLayer()
        circle1.bounds = CGRect(origin: .zero, size: CGSize(width: 60, height: 60))
        circle1.position = CGPoint(x: 305.3333282470703, y: 107.66665649414062)
        circle1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        let circle2 = CAShapeLayer()
        circle2.bounds = CGRect(origin: .zero, size: CGSize(width: 60, height: 60))
        circle2.position = origin2
        circle2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        circle1.cornerRadius = 30
        circle2.cornerRadius = 30
        circle1.masksToBounds = true
        circle2.masksToBounds = true
        layer.addSublayer(circle1)
        layer.addSublayer(circle2)

        let end1 = CGPoint(x: 4*layer.frame.width/7.0, y: 3*layer.frame.height/7.0)
        let end2 = CGPoint(x: 3*layer.frame.width/7.0, y: 4*layer.frame.height/7.0)

        let duration: CFTimeInterval = 1.2
        let leftMovement = CAKeyframeAnimation(keyPath: "position")
        leftMovement.path = self.createPath()
        leftMovement.duration = duration
        leftMovement.repeatCount = 1000

        let rightMovement = CAKeyframeAnimation(keyPath: "position")
        rightMovement.path = self.createPath2()
        rightMovement.duration = duration
        rightMovement.repeatCount = 1000

        circle1.add(leftMovement, forKey: nil)
        circle2.add(rightMovement, forKey: nil)

        return layer
    }()

    func createPath() -> CGMutablePath {
        let thePath = CGMutablePath()
        thePath.move(to: CGPoint(x: 305.3333282470703, y: 107.66665649414062  + 60))

        let points = [
            CGPoint(x: 305.3333282470703, y: 107.66665649414062),
            CGPoint(x: 301.0, y: 113.0),
            CGPoint(x: 295.0, y: 121.66665649414062),
            CGPoint(x: 290.3333282470703, y: 129.0),
            CGPoint(x: 287.6666564941406, y: 133.66665649414062),
            CGPoint(x: 283.6666564941406, y: 141.3333282470703),
            CGPoint(x: 281.3333282470703, y: 147.3333282470703),
            CGPoint(x: 275.6666564941406, y: 157.3333282470703),
            CGPoint(x: 270.6666564941406, y: 164.3333282470703),
            CGPoint(x: 261.0, y: 177.3333282470703),
            CGPoint(x: 255.0, y: 186.3333282470703),
            CGPoint(x: 246.3333282470703, y: 200.0),
            CGPoint(x: 240.0, y: 210.0),
            CGPoint(x: 234.0, y: 219.3333282470703),
            CGPoint(x: 228.0, y: 227.66665649414062),
            CGPoint(x: 224.66665649414062, y: 231.3333282470703),
            CGPoint(x: 219.0, y: 237.66665649414062),
            CGPoint(x: 214.0, y: 243.3333282470703),
            CGPoint(x: 212.0, y: 245.66665649414062),
            CGPoint(x: 210.3333282470703, y: 247.3333282470703),
            CGPoint(x: 209.66665649414062, y: 248.3333282470703),
            CGPoint(x: 209.3333282470703, y: 249.0),
            CGPoint(x: 209.3333282470703, y: 249.3333282470703),
            CGPoint(x: 209.0, y: 250.3333282470703),
            CGPoint(x: 209.0, y: 251.0),
            CGPoint(x: 209.0, y: 251.3333282470703),
            CGPoint(x: 209.0, y: 251.3333282470703)
        ]
        for point in points {
            let adjusted = CGPoint(x: point.x, y: point.y + 60)
            thePath.addLine(to: adjusted)
        }

        return thePath
    }

    private func createPath2() -> CGMutablePath {
        let thePath = CGMutablePath()
        thePath.move(to: CGPoint(x: 69.66665649414062, y: 516.3333282470703))

        let points = [
            CGPoint(x: 69.66665649414062, y: 516.3333282470703),
            CGPoint(x: 74.0, y: 511.0),
            CGPoint(x: 80.0, y: 502.3333282470703),
            CGPoint(x: 84.66665649414062, y: 495.0),
            CGPoint(x: 87.33332824707031, y: 490.3333282470703),
            CGPoint(x: 91.33332824707031, y: 482.6666564941406),
            CGPoint(x: 93.66665649414062, y: 476.6666564941406),
            CGPoint(x: 99.33332824707031, y: 466.6666564941406),
            CGPoint(x: 104.33332824707031, y: 459.6666564941406),
            CGPoint(x: 113.66665649414062, y: 446.6666564941406),
            CGPoint(x: 120.0, y: 437.6666564941406),
            CGPoint(x: 128.66665649414062, y: 424.0),
            CGPoint(x: 135.0, y: 414.0),
            CGPoint(x: 141.0, y: 404.6666564941406),
            CGPoint(x: 147.0, y: 396.3333282470703),
            CGPoint(x: 150.3333282470703, y: 392.6666564941406),
            CGPoint(x: 156.0, y: 386.3333282470703),
            CGPoint(x: 161.0, y: 380.6666564941406),
            CGPoint(x: 163.0, y: 378.3333282470703),
            CGPoint(x: 164.66665649414062, y: 376.6666564941406),
            CGPoint(x: 165.3333282470703, y: 375.6666564941406),
            CGPoint(x: 165.66665649414062, y: 375.0),
            CGPoint(x: 165.66665649414062, y: 374.6666564941406),
            CGPoint(x: 166.0, y: 373.6666564941406),
            CGPoint(x: 166.0, y: 373.0),
            CGPoint(x: 166.0, y: 372.6666564941406),
            CGPoint(x: 166.0, y: 372.6666564941406)
        ]


        for point in points {
            let adjusted = CGPoint(x: point.x, y: point.y + 60)
            thePath.addLine(to: adjusted)
        }

        return thePath
    }

    private func addPinchToZoomIndicator() {
        // add two circle layers, then animate them. once a pinch/zoom gesture is recognized, dismiss them
        if let layer = self.pinchToZoomLayer {
            self.view.layer.addSublayer(layer)
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
        let datasource = TakeoutDataSource(example: self.selectedExample)
        return PlaceholderMenuView.createViews(columnWidth: columnWidth, datasource: datasource, target: self, action: #selector(ParentVC.didTap(_:)))
    }

    @objc
    func didTap(_ sender: UIButton) {
        let entry = sender.superview as? EntryView
        self.selectedItems.append(entry?.item?.name ?? "")
        if let item = entry?.item {
            self.userDidTap(button: sender, for: item)
        }

        self.selectedBadge = (entry?.subviews.first() { $0.tag == 123 })
    }

    func miniCartText() -> String {
        let count =  self.items.reduce(0) { $0 + $1.value }
        let totPrice = self.items.reduce(0) { $0 + ($1.key.price.amount as NSDecimalNumber).doubleValue*Double($1.value)  }

        return count == 0 ? "empty" : String(format: "%zd • $%0.2f", count, totPrice)
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
            if self.bottomBarVC?.currentState == .search {
                
                self.bottomBarVC?.cartToParentLeadingConstraint?.constant = -(self.view.frame.width - (2*Layout.exposedViewWidth - Layout.buttonSpacing) + 8)
                self.bottomBarVC?.searchImageView.image = UIImage(named: "ic_search_template")
                self.animateImageChange(duration: duration)
                
                self.bottomBarVC?.searchViewWidthConstraint?.constant = -68
                
            }
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.zoomingView?.setButtons(enabled: true)
            }
            return
        } else if let keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) {
            let constant = keyboardRect.height - self.view.safeAreaInsets.bottom
            self.bottomBarBottomConstraint?.constant = constant

            if self.bottomBarVC?.currentState == .search {
                self.bottomBarVC?.cartToParentLeadingConstraint?.constant = -self.view.frame.width + 60
                self.bottomBarVC?.searchViewWidthConstraint?.constant = 0
                self.bottomBarVC?.searchImageView.image = UIImage.caretImage
                self.bottomBarVC?.searchImageView.tintColor = .otk_white
                self.animateImageChange(duration: duration)

            }
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

    @IBOutlet weak var dtpView: UIView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var cartMiniView: CartInfoView!

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
        self.cartMiniView.totalLabel?.text = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        [self.dtpView].forEach({
            $0?.layer.masksToBounds = true
            $0?.layer.borderWidth = 1/UIScreen.main.scale
            $0?.layer.borderColor = UIColor.otk_white_white.cgColor
            $0?.layer.cornerRadius = $0!.frame.height/2.0
        })
        [self.cartMiniView].forEach({
            $0?.layer.masksToBounds = true
//            $0?.layer.borderWidth = 1/UIScreen.main.scale
//            $0?.layer.borderColor = UIColor.otk_white_white.cgColor
            $0?.layer.cornerRadius = .otk_cornerRadius
        })
    }

    var targetPickupDate: Date?
    @objc
    func didTap(_ tapGR: UITapGestureRecognizer) {
        guard let tappedView = tapGR.view
        else { return }
        let tapPoint = tapGR.location(in: tappedView)
        self.cartMiniView.totalLabel?.text = (self.parent as? ParentVC)?.miniCartText()

        guard self.datePickerWasFirstResponder == false else {
            self.view.otf_findFirstResponder()?.resignFirstResponder()

            self.datePickerWasFirstResponder = false
            return
        }

        if self.currentState == .cart {
            if self.cartView?.frame.contains(tapPoint) == true {
                if self.cartView!.frame.height < 51 {
                    self.cartToParentLeadingConstraint.constant = 16.0
                    self.cartWidthConstraint.constant = -.otk_bottomDrawerMargin*2
                    self.cartImageView.image = UIImage.caretImage
                    self.cartMiniView.totalLabel?.text = ""
                    self.cartImageView.animateImageChange(duration: 0.2)
                    let stackView: UIStackView
                    let constraints: [NSLayoutConstraint]
                    if let menuItems = (self.parent as? ParentVC)?.items,
                       menuItems.filter({ $0.value != 0 }).isEmpty == false {
                        let entries: [UIStackView] = menuItems.compactMap { return $0.value == 0 ? nil : self.cartEntry(for: "\($0.value) - \($0.key.name)", right: $0.key.price.formattedDescription ?? "") }

                        stackView = UIStackView(arrangedSubviews: entries)

                        stackView.translatesAutoresizingMaskIntoConstraints = false
                        stackView.axis = .vertical
                        stackView.spacing = .otk_bottomDrawerInterMargin

                        var frame = self.cartView?.bounds ?? .zero
                        frame.origin.y += 30
                        frame.size.height -= 30
                        stackView.frame = frame

                        stackView.addArrangedSubview(self.createSeparator())
                        stackView.addArrangedSubview(self.finalEntry(items: menuItems))
                        stackView.addArrangedSubview(self.timePickerEntry())
                        constraints = [
                            stackView.topAnchor.constraint(equalTo: self.cartMiniView!.bottomAnchor, constant: .otk_bottomDrawerInterMargin),
                            stackView.leadingAnchor.constraint(equalTo: self.cartView!.leadingAnchor, constant: .otk_bottomDrawerMargin),
                            stackView.trailingAnchor.constraint(equalTo: self.cartView!.trailingAnchor, constant: -.otk_bottomDrawerMargin),
                        ]

                    } else {

                        stackView = UIStackView(arrangedSubviews: [self.timePickerEntry()])
                        stackView.translatesAutoresizingMaskIntoConstraints = false

                        constraints = [
                            stackView.topAnchor.constraint(equalTo: self.cartMiniView!.bottomAnchor, constant: .otk_bottomDrawerInterMargin),
                            stackView.leadingAnchor.constraint(equalTo: self.cartView!.leadingAnchor, constant: .otk_bottomDrawerMargin),
                        ]

                    }
                    let height = stackView.arrangedSubviews.reduce(CGFloat(100)) {
                        if $1 is UIStackView {
                            let biHight = ($1 as? UIStackView)?.arrangedSubviews.reduce(0) { max($0, $1.intrinsicContentSize.height)}

                            return $0 + 8 + (biHight ?? 15)
                        } else {
                            return $0 + 50.0
                        }
                    }
                    (self.parent as? ParentVC)?.bottomBarHeightConstraint?.constant = height


                    self.cartView?.addSubview(stackView)
                    NSLayoutConstraint.activate(constraints)


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
                /// this should actually go somewhere else
                let datasource = TakeoutDataSource(example: (self.parent as? ParentVC)!.selectedExample)
                let tags = Set(datasource.entireMenu.allItems.flatMap({ $0.attributes }))
                print(tags.joined(separator: ", "))

                self.searchTextField?.placeholder = "Search dishes"//tags.joined(separator: ", ")

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

    private func timePickerEntry() -> UIView {

        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 16.0
        
        let label = UILabel()
        label.text = "Pickup time"
        label.textColor = .otk_white_white
        label.font = UIFont(name: "BrandonText-Bold", size: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addArrangedSubview(label)
        container.translatesAutoresizingMaskIntoConstraints = false
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        picker.addTarget(self, action: #selector(Self.dateChanged(_:)), for: .valueChanged)
        picker.datePickerMode = .time
        picker.translatesAutoresizingMaskIntoConstraints = false

        if let time = self.targetPickupDate {
            picker.date = time
        } else {
            picker.date = Date(timeIntervalSinceNow: 60*37)
        }
        container.addArrangedSubview(picker)
//        NSLayoutConstraint.activate([
//            container.leadingAnchor.constraint(equalTo: picker.leadingAnchor),
//            container.trailingAnchor.constraint(greaterThanOrEqualTo: picker.trailingAnchor),
//            container.topAnchor.constraint(equalTo: picker.topAnchor),
//            container.bottomAnchor.constraint(equalTo: picker.bottomAnchor),
//        ])
        return container
    }

    private func createSeparator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale).isActive = true
        view.backgroundColor = .otk_ashLightest
        return view
    }
    private func finalEntry(items: [TakeoutMenuItem: Int]) -> UIStackView {
        let count =  items.reduce(0) { $0 + $1.value }
        let totPrice = items.reduce(0) { $0 + ($1.key.price.amount as NSDecimalNumber).doubleValue*Double($1.value)  }

        let entry = self.cartEntry(for: "\(count) items", right: String(format: "$%.2f", totPrice))

        entry.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return entry
    }

    private func cartEntry(for left: String, right: String) -> UIStackView {

        let label2 = UILabel()
        label2.text = left
        label2.textAlignment = .left
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.numberOfLines = 0
        label2.textColor = .otk_white_white
        label2.font = UIFont(name: "BrandonText-Bold", size: 14.0)


        let label = UILabel()
        label.textAlignment = .right
        label.text = right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .otk_white_white
        label.font = UIFont(name: "BrandonText-Bold", size: 14.0)
        return UIStackView(arrangedSubviews: [label2, label])
    }

    fileprivate static var shortTimeFormatter: DateFormatter = {
        let shortTimeFormatter = DateFormatter()
        shortTimeFormatter.timeStyle = .short
        shortTimeFormatter.dateStyle = .none
        return shortTimeFormatter
    }()

    @objc
    func dateChanged(_ sender: UIDatePicker) {
        self.targetPickupDate = sender.date
        self.timeLabel.text = String(format: "%@ • %.0f mins", Self.shortTimeFormatter.string(from: sender.date), sender.date.timeIntervalSinceNow/60)
        print(self.parent?.view.otf_findFirstResponder())
        self.datePickerWasFirstResponder = true
    }

    var datePickerWasFirstResponder = false


    private var isShowingCart: Bool {
        return true
    }

    enum Presented {
        case cart
        case search
    }

    var currentState: Presented {
        return self.textFieldLeadingConstraint?.constant == 70 ? .cart : .search
    }


    var nextState: Presented {
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

//        self.textFieldLeadingConstraint.constant = textLeading

        //TODO: Chris Brandow  2021-02-02 here's how i want the animation to go
        // 1. when cart is apparent, the bag should not be visible
        // 2. when the cart appears or disappears, the bag should move with it, but fade in/out
        // 2.5. the cart view should have normal stuff, # items, total price, and a "view cart" button
        // 3. i want to try to have the magnifying glass stay in its position with regards to the phone screen
        // 4. have the text field move with the search view underneath the search glass
        UIView.animate(withDuration: 0.26, delay: 0.0, options: .curveEaseInOut, animations: {
            self.searchTextField?.alpha = textLeading == 70 ? 0.0 : 1.0
            (self.parent as? ParentVC)?.view.layoutIfNeeded()
        }, completion: { _ in
            self.view.gestureRecognizers?.forEach({$0.isEnabled = true })
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

class CartInfoView: UIView {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var totalLabel: UILabel?

    func update(withNumber: Int, price: Double) {
        
    }
}

extension UIView {
    public func otf_findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }

        for subview in self.subviews {
            guard let responder = subview.otf_findFirstResponder() else {
                continue
            }
            return responder
        }

        return nil
    }

}
