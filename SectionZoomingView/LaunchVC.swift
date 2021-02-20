//
//  ViewController.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 12/23/20.
//

import UIKit

class LaunchVC: UIViewController {//}, ZoomableViewProvider {
    var didLaunchOnce = false

    @IBOutlet var stackView: UIStackView?

    // to make it easier to integrate into OpenTable, i should move teh datasource
    // to ParentVC, then "load" it from there, based on the name
    var selectedExample = TakeoutDataSource.Example.mint_11_123

    override func viewDidLoad() {
        super.viewDidLoad()
        for example in TakeoutDataSource.Example.allCases {

            let button = UIButton(type: .custom)
            button.setTitle(example.displayName, for: .normal)
            button.setTitleColor(.darkGray, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.cornerRadius = Layout.cornerRadius
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.self.selectedExample = example
                self.performSegue(withIdentifier: "showZoomable", sender: self)
            }), for: .touchUpInside)
            self.stackView?.addArrangedSubview(button)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.didLaunchOnce == false else {
            return
        }
        self.didLaunchOnce = true
        self.performSegue(withIdentifier: "showZoomable", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? ParentVC)?.selectedExample = self.selectedExample
    }

}

class EntryView: UIView {
    var item: TakeoutMenuItem?

    var titleLabel = UILabel()
    var bigTitleLabel = UILabel()
    var descriptionLabel = UILabel()
    var priceLabel = UILabel()
    var button = UIButton()
    var badge = UIView()
    override var description: String {
        return self.frame.debugDescription// self.item?.name ?? " no item"
    }

    var isNarrowCell: Bool {
        guard let item = self.item
        else { return false }
        return item.itemDescription?.isEmpty != false
    }

    var isSectionHeader: Bool {
        return self.item == nil
    }
}

