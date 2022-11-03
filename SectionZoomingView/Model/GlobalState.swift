import Foundation
import Combine

// So sleazy... OMG 🙈 Don't let your kids see this, or they will grow up confused, living
// a solitary life, unable to fit into society.

class GlobalState: ObservableObject {
    static let shared = GlobalState()

    /// Posts to `NotificationCenter.default` when the cart changes, with
    /// `userInfo: ["cart": theNewCart]`
    static let cartChangedNotification = Notification.Name("The cart done gone up and changed on us, pardner!!!")

    /// Updates to `cart` should be published via both Combine and
    /// NotificationCenter. Choose your fighter!!!
    @Published
    var cart: Cart {
        didSet {
            print("Cart updated with item count: \(self.cart.items.count)")
            NotificationCenter.default.post(name: Self.cartChangedNotification,
                                            object: self,
                                            userInfo: ["cart": self.cart])
        }
    }

    init(cart: Cart = Cart(items: [])) {
        self.cart = cart
    }

    /// Use this. Or don't. Whatever. The cart updates will be published nontheless.
    func addToCart(_ item: Cart.Item) {
        var newCart = cart
        newCart.items.append(item)
        self.cart = newCart
    }
}

extension GlobalState {
    static func stub(itemCount: Int = 4) -> GlobalState {
        let cart = Cart(items: (0 ..< itemCount).map { Cart.Item.stub(index: $0) })
        return GlobalState(cart: cart)
    }
}
