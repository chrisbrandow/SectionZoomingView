import UIKit

// MARK: Cart
struct Cart: Codable {

    var items: [Self.Item]
}

// MARK: Cart Item
extension Cart {
    struct Item: Codable, Identifiable {
        /// The unique id of this item
        var id: UUID = UUID()

        /// The menu item the diners ordered
        var menuItem: MenuItem

        /// Diners who are responsible for this item.
        var diners: [Diner] = []

        /// Number of items ordered
        var quantity: Int = 1

        /// The meal sequence or "course" this item should be grouped with.
        ///
        /// Higher values will stage the item for later in the meal. The value here only matters relative to the other
        /// values in the order, and are not absolute.
        var course: Int = 0
    }
}

extension Cart.Item {
    var totalPrice: Price {
        self.menuItem.price * Decimal(self.quantity)
    }
}
