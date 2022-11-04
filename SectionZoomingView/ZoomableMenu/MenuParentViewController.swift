//
//  MenuViewController.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/4/21.
//

import Combine
import SwiftUI
import UIKit

class MenuParentViewController: UIViewController, ZoomableViewProvider {
   
    var items = [MenuItem: Int]()

    var zoomingView: SectionedView?

//    lazy var pinchToZoomLayer: CALayer? = self.createPinchLayer()

    var searchBarViewModel: SearchBarViewModel?

    var tagBarViewModel: TagBarViewModel?

    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet var zoomableContainer: UIView?
    var zoomableController: ZoomableViewController?
    var shadowLine = UIView()

    @IBOutlet weak var backingView: UIView!
    @IBOutlet weak var zoomableTopConstraint: NSLayoutConstraint!

    lazy var bottomBarHostingController = UIHostingController(
        rootView: AnyView(BottomBarView() { [unowned self] in
            self.showCart()
        }.environmentObject(GlobalState.shared))
    )

    @IBSegueAction func embedTopContainer(_ coder: NSCoder) -> UIViewController? {
        let searchBarViewModel = SearchBarViewModel()
        let tagBarViewModel = TagBarViewModel()

        self.searchBarViewModel = searchBarViewModel
        self.tagBarViewModel = tagBarViewModel

        let topBarContainer = TopBarContainer(searchBarViewModel: searchBarViewModel,
                                              tagBarViewModel: tagBarViewModel)
        return UIHostingController(coder: coder, rootView: topBarContainer)
    }

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
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "hasSeenZoomGesture")
        self.zoomableContainer?.clipsToBounds = false

        self.title = GlobalState.shared.restaurantName
        self.titleLabel?.text = GlobalState.shared.restaurantName

        if let _ = self.navigationController {
            self.zoomableTopConstraint.constant = 0
            self.titleLabel?.isHidden = true
            self.backingView.backgroundColor = .otk_white
            self.view.backgroundColor = .otk_white
        }

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

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Self.didShake(_:)),
                                               name: Application.shakeNotification,
                                               object: nil)


        self.setupBottomBar()
        self.bottomBarHostingController.view.layer.opacity = 0.0
        observeTopContainerBar()
        observeCart()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // not needed for demo
//        let delay = DispatchTime.now() + 2
//        DispatchQueue.main.asyncAfter(deadline: delay) {
//            self.addPinchToZoomIndicator()
//            UserDefaults.standard.set(true, forKey: "hasSeenZoomGesture")
//        }

    }
//disable hack panel
//    add modal for starting/joining cart
//        add modal for inviting with a code
    private func showCart() {
        let cartView = CartView {
            print("Order submitted")
            GlobalState.shared.isSumbitted = true
        } onInviteDiners: {
            print("hello")
            // present an alert or
        } onClose: { [unowned self] in
            self.dismiss(animated: true)
        }.environmentObject(GlobalState.shared)

        let vc = UIHostingController(rootView: cartView)

        self.present(vc, animated: true)
    }

    private func setupBottomBar() {
        if let v = bottomBarHostingController.view,
           let container = self.view {
            v.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(v)
            NSLayoutConstraint.activate([
                v.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                v.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                v.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor),
            ])
        }
    }

    @objc
    func didShake(_ notification: Notification) {
        let rootVC = self.navigationController ?? self
        let adminView = AdminView {
            rootVC.dismiss(animated: true)
        }
        let vc = UIHostingController(rootView: adminView)
        rootVC.present(vc, animated: true)
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

    private func observeTopContainerBar() {
        guard let searchBarViewModel = searchBarViewModel,
              let tagBarViewModel = tagBarViewModel else {
            return
        }

        Publishers
            .CombineLatest(searchBarViewModel.$searchQuery, tagBarViewModel.$tappedTag)
            .sink { [weak self] query, tag in
                guard let zoomingView = self?.zoomingView else {
                    return
                }

                zoomingView.highlight(with: query, tag: tag)
            }
            .store(in: &cancellables)
    }

    func observeCart() {
        GlobalState
            .shared
            .$cart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cart in
                guard let self = self else {
                    return
                }
                cart.items.forEach({ self.updateEntryView(with: $0) })
                UIView.animate(withDuration: 0.2, delay: 0.3) {
                    self.bottomBarHostingController.view.layer.opacity = cart.items.isEmpty ? 0 : 1
                }
            }
            .store(in: &cancellables)
    }

    private func updateEntryView(with cartItem: Cart.Item) {
        guard let entryView = zoomingView?.firstEntryView(with: cartItem.menuItem.id) else {
            return
        }

        update(value: cartItem.quantity, for: entryView)
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

extension MenuParentViewController {

    /// This generates the array of individual views
    private func generateViews(for columnWidth: CGFloat) -> [UIView] {
        let datasource = try! MenuDataSource(example: GlobalState.shared.selectedExample)
        // Ryosuke - here are the tags
        let allTags = datasource.entireMenu.allTags
        print(allTags)
        return PlaceholderMenuView.createViews(columnWidth: columnWidth, datasource: datasource, target: self, action: #selector(MenuParentViewController.didTap(_:)))
    }

    private func createView(with strips: [UIView]) -> SectionedView {
        let viewHeight = (self.bottomBarHostingController.view.frame.origin.y)
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
}


class BottomBarVC: UIViewController {
    @IBOutlet weak var cartView: UIView?

    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var cartMiniView: CartInfoView!

    @IBOutlet weak var cartWidthConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Self.cartUpdated(notification:)),
                                               name: GlobalState.cartChangedNotification,
                                               object: nil)
    }

    @objc
    func cartUpdated(notification: Notification) {
        print("hooray! state propagation works! we can be less ashamed!")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class CartInfoView: UIView {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var totalLabel: UILabel?

    func update(withNumber: Int, price: Double) {
        
    }
}
