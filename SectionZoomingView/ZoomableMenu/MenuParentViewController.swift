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

    var selectedExample = MenuDataSource.Example.paradiso_23_304
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
        rootView: AnyView(BottomBarView().environmentObject(GlobalState.shared))
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
        if let _ = self.navigationController {
            self.zoomableTopConstraint.constant = 0
            self.title = self.selectedExample.displayName
            self.titleLabel?.isHidden = true
            self.backingView.backgroundColor = .otk_white
            self.view.backgroundColor = .otk_white
        } else {
            self.titleLabel?.text = self.selectedExample.displayName
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

        self.setupBottomBar()

        observeTopContainerBar()
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
}

extension MenuParentViewController {

    /// This generates the array of individual views
    private func generateViews(for columnWidth: CGFloat) -> [UIView] {
        let datasource = try! MenuDataSource(example: self.selectedExample)
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


/// Not needed for demo
extension MenuParentViewController {

    /// this is not really needed for the demo
    //    private func addPinchToZoomIndicator() {
    //        if let layer = self.pinchToZoomLayer {
    //            self.view.layer.addSublayer(layer)
    //        }
    //    }

//    private func createPinchLayer() -> CALayer? {
//        if UserDefaults.standard.bool(forKey: "hasSeenZoomGesture") == true {
//            return nil
//        }
//
//        let layer = CALayer()
//        layer.frame = self.view.bounds
//        layer.backgroundColor = UIColor.clear.cgColor
//        let origin1 = CGPoint(x: 3*layer.frame.width/4.0, y: layer.frame.height/4.0)
//        let origin2 = CGPoint(x: layer.frame.width/4.0, y: 3*layer.frame.height/4.0)
//
//        let circle1 = CAShapeLayer()
//        circle1.bounds = CGRect(origin: .zero, size: CGSize(width: 60, height: 60))
//        circle1.position = CGPoint(x: 305.3333282470703, y: 107.66665649414062)
//        circle1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
//        let circle2 = CAShapeLayer()
//        circle2.bounds = CGRect(origin: .zero, size: CGSize(width: 60, height: 60))
//        circle2.position = origin2
//        circle2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
//        circle1.cornerRadius = 30
//        circle2.cornerRadius = 30
//        circle1.masksToBounds = true
//        circle2.masksToBounds = true
//        layer.addSublayer(circle1)
//        layer.addSublayer(circle2)
//
//        let end1 = CGPoint(x: 4*layer.frame.width/7.0, y: 3*layer.frame.height/7.0)
//        let end2 = CGPoint(x: 3*layer.frame.width/7.0, y: 4*layer.frame.height/7.0)
//
//        let duration: CFTimeInterval = 1.2
//        let leftMovement = CAKeyframeAnimation(keyPath: "position")
//        leftMovement.path = self.createPath()
//        leftMovement.duration = duration
//        leftMovement.repeatCount = 1000
//
//        let rightMovement = CAKeyframeAnimation(keyPath: "position")
//        rightMovement.path = self.createPath2()
//        rightMovement.duration = duration
//        rightMovement.repeatCount = 1000
//
//        circle1.add(leftMovement, forKey: nil)
//        circle2.add(rightMovement, forKey: nil)
//
//        return layer
//    }()
//
//    func createPath() -> CGMutablePath {
//        let thePath = CGMutablePath()
//        thePath.move(to: CGPoint(x: 305.3333282470703, y: 107.66665649414062  + 60))
//
//        let points = [
//            CGPoint(x: 305.3333282470703, y: 107.66665649414062),
//            CGPoint(x: 301.0, y: 113.0),
//            CGPoint(x: 295.0, y: 121.66665649414062),
//            CGPoint(x: 290.3333282470703, y: 129.0),
//            CGPoint(x: 287.6666564941406, y: 133.66665649414062),
//            CGPoint(x: 283.6666564941406, y: 141.3333282470703),
//            CGPoint(x: 281.3333282470703, y: 147.3333282470703),
//            CGPoint(x: 275.6666564941406, y: 157.3333282470703),
//            CGPoint(x: 270.6666564941406, y: 164.3333282470703),
//            CGPoint(x: 261.0, y: 177.3333282470703),
//            CGPoint(x: 255.0, y: 186.3333282470703),
//            CGPoint(x: 246.3333282470703, y: 200.0),
//            CGPoint(x: 240.0, y: 210.0),
//            CGPoint(x: 234.0, y: 219.3333282470703),
//            CGPoint(x: 228.0, y: 227.66665649414062),
//            CGPoint(x: 224.66665649414062, y: 231.3333282470703),
//            CGPoint(x: 219.0, y: 237.66665649414062),
//            CGPoint(x: 214.0, y: 243.3333282470703),
//            CGPoint(x: 212.0, y: 245.66665649414062),
//            CGPoint(x: 210.3333282470703, y: 247.3333282470703),
//            CGPoint(x: 209.66665649414062, y: 248.3333282470703),
//            CGPoint(x: 209.3333282470703, y: 249.0),
//            CGPoint(x: 209.3333282470703, y: 249.3333282470703),
//            CGPoint(x: 209.0, y: 250.3333282470703),
//            CGPoint(x: 209.0, y: 251.0),
//            CGPoint(x: 209.0, y: 251.3333282470703),
//            CGPoint(x: 209.0, y: 251.3333282470703)
//        ]
//        for point in points {
//            let adjusted = CGPoint(x: point.x, y: point.y + 60)
//            thePath.addLine(to: adjusted)
//        }
//
//        return thePath
//    }
//
//    private func createPath2() -> CGMutablePath {
//        let thePath = CGMutablePath()
//        thePath.move(to: CGPoint(x: 69.66665649414062, y: 516.3333282470703))
//
//        let points = [
//            CGPoint(x: 69.66665649414062, y: 516.3333282470703),
//            CGPoint(x: 74.0, y: 511.0),
//            CGPoint(x: 80.0, y: 502.3333282470703),
//            CGPoint(x: 84.66665649414062, y: 495.0),
//            CGPoint(x: 87.33332824707031, y: 490.3333282470703),
//            CGPoint(x: 91.33332824707031, y: 482.6666564941406),
//            CGPoint(x: 93.66665649414062, y: 476.6666564941406),
//            CGPoint(x: 99.33332824707031, y: 466.6666564941406),
//            CGPoint(x: 104.33332824707031, y: 459.6666564941406),
//            CGPoint(x: 113.66665649414062, y: 446.6666564941406),
//            CGPoint(x: 120.0, y: 437.6666564941406),
//            CGPoint(x: 128.66665649414062, y: 424.0),
//            CGPoint(x: 135.0, y: 414.0),
//            CGPoint(x: 141.0, y: 404.6666564941406),
//            CGPoint(x: 147.0, y: 396.3333282470703),
//            CGPoint(x: 150.3333282470703, y: 392.6666564941406),
//            CGPoint(x: 156.0, y: 386.3333282470703),
//            CGPoint(x: 161.0, y: 380.6666564941406),
//            CGPoint(x: 163.0, y: 378.3333282470703),
//            CGPoint(x: 164.66665649414062, y: 376.6666564941406),
//            CGPoint(x: 165.3333282470703, y: 375.6666564941406),
//            CGPoint(x: 165.66665649414062, y: 375.0),
//            CGPoint(x: 165.66665649414062, y: 374.6666564941406),
//            CGPoint(x: 166.0, y: 373.6666564941406),
//            CGPoint(x: 166.0, y: 373.0),
//            CGPoint(x: 166.0, y: 372.6666564941406),
//            CGPoint(x: 166.0, y: 372.6666564941406)
//        ]
//
//
//        for point in points {
//            let adjusted = CGPoint(x: point.x, y: point.y + 60)
//            thePath.addLine(to: adjusted)
//        }
//
//        return thePath
//    }

}
