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

    var selectedExample = TakeoutDataSource.Example.mint_11_123

    func zoomableView(for frame: CGRect) -> SectionedView {
        let view = self.zoomingView ?? self.createZoomingView(for: frame)
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
    var zoomableController: ZoomableViewController?
    var bottomBarVC: BottomBarVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.zoomableContainer?.clipsToBounds = false
        self.titleLabel?.text = self.selectedExample.displayName
    }

    private func createZoomingView(for frame: CGRect) -> SectionedView {//(with: TakeoutDataSource) -> UIView {
        let columnCount = 5
        let floatingColumnCount = CGFloat(columnCount)
        let margin = CGFloat(2.0)
        let size = CGSize(width: floatingColumnCount*frame.width + (floatingColumnCount - 1)*margin, height: 5*frame.height)
        let sectionedView = UIView(frame: CGRect(origin: .zero, size: size))
        sectionedView.backgroundColor = .systemGray5// UIColor(hue: 0.11, saturation: 0.7, brightness: 1.00, alpha: 1.00)
//        let datasource = DataSource()
//        let mDataSource = TakeoutDataSource(example: .paradiso_23_304)
//        TakeoutDataSource.Example.allCases
//            .forEach({
//                let d = TakeoutDataSource(example: $0)
//                print("\(d.entireMenu.allSections.count) \(d.entireMenu.allItems.count)")
//                d.entireMenu
//            })

        let d = TakeoutDataSource(example: self.selectedExample)


        let rowCount = d.entries.count/columnCount
        let smallSize = CGSize(width: size.width/CGFloat(columnCount), height: size.height/CGFloat(rowCount))
        for i in 0..<columnCount {
            for j in 0..<rowCount {
                let x = CGFloat(i)*smallSize.width
                let addView = EntryView(frame: CGRect(x: x + margin, y: CGFloat(j)*smallSize.height + CGFloat(i)*CGFloat(j) + margin, width: smallSize.width - 2*margin, height: smallSize.height + CGFloat(i) - 2*margin))
                addView.backgroundColor = .white// UIColor(white: (0.95 - (1+CGFloat(i))*(CGFloat(j)+1)/CGFloat(120)), alpha: 1.0)
                //shoot. shadow probs isn't showing up because clips to bounds for corner radius. need to add a shadow layer
                addView.layer.shadowOffset = CGSize(width: 0, height: 0)
                addView.layer.shadowColor = UIColor.black.cgColor
                addView.layer.shadowOpacity = 0.4
                addView.layer.shadowRadius = 1.0
                addView.layer.cornerRadius = 3
                addView.layer.masksToBounds = true
                addView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 1, y: 1, width: addView.bounds.width - 2, height: addView.bounds.height - 2), cornerRadius: 3).cgPath
                var lFrame = addView.bounds
                lFrame.origin.x += 8
                lFrame.size.height /= 2.0
                let label = UILabel(frame: lFrame)
                label.text = d.entries[ i*rowCount + j].title
                label.textColor = .darkGray//  UIColor(hue: 0.58, saturation: 0.76, brightness: 0.84, alpha: 1.00)
                label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                let button = UIButton(type: .custom)
                button.frame = addView.bounds
                button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
                addView.item = d.entries[ i*rowCount + j]
                addView.addSubview(label)
                addView.addSubview(button)
                addView.layer.masksToBounds = false
                sectionedView.addSubview(addView)
            }
        }
        let lastFrame = sectionedView.subviews.reduce(CGPoint.zero) { CGPoint(x: max($0.x, $1.frame.maxX), y: max($0.y, $1.frame.maxY)) }
        sectionedView.frame = CGRect(origin: .zero, size: CGSize(width: lastFrame.x, height: lastFrame.y))

        return SectionedView(view: sectionedView, numberOfColumns: 5, margin: margin)

    }

    @objc
    func didTap(_ sender: UIButton) {
        let entry = sender.superview as? EntryView
        print(entry?.item)
        self.bottomBarVC?.cartLabel.text = entry?.item?.title
    }

}
class BottomBarVC: UIViewController {
    @IBOutlet weak var cartView: UIView?
    @IBOutlet weak var searchView: UIView?

    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchImageTrailingConstraint: NSLayoutConstraint!
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
    }

    @objc
    func didTap(_ tapGR: UITapGestureRecognizer) {
        self.toggleViews()
    }

    private func toggleViews() {
        let upatedConstant = self.leadingConstraint.constant == Layout.floatingLeadingMargin
            ? -(self.view.frame.width - (2*Layout.exposedViewWidth - Layout.buttonSpacing) + 8)
            : Layout.floatingLeadingMargin
        self.leadingConstraint?.constant = upatedConstant
        self.view.gestureRecognizers?.forEach({$0.isEnabled = false })

        let textLeading: CGFloat = self.textLeadingConstraint.constant == 70 ? 8.0 : 70.0

        self.textLeadingConstraint.constant = textLeading

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

struct Layout {
    static let buttonSpacing: CGFloat = 16.0
    static let floatingLeadingMargin: CGFloat = 8.0
    static let exposedViewWidth: CGFloat = 80.0
    static let cornerRadius: CGFloat = 4.0
}

