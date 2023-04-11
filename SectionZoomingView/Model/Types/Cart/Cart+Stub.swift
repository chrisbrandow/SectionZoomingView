import Foundation

// MARK: Stubs
extension Cart {
    static func stub() -> Self {
        Cart(items: (0 ..< 5).map { Item.stub(index: $0) })
    }
}

extension Cart.Item {
    static func stub(index: Int) -> Self {
        Cart.Item(menuItem: .stub(index: index), diners: [.allCases[index % Diner.allCases.count]], course: (0...1).randomElement() ?? 0)
    }
}

