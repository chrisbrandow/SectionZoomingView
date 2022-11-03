import Foundation
import Combine

// So sleazy... OMG 🙈 Don't let your kids see this, or they will grow up confused, living
// a solitary life, unable to fit into society.

class GlobalState: ObservableObject {
    static let shared = GlobalState()

    @Published
    var isSumbitted: Bool = false

    // The active diner
    var diner: Diner = .doug

    /// Posts to `NotificationCenter.default` when the cart changes, with
    /// `userInfo: ["cart": theNewCart]`
    static let cartChangedNotification = Notification.Name("The cart done gone up and changed on us, pardner!!!")

    var restaurantName: String { selectedExample.displayName }

    var selectedExample = MenuDataSource.Example.paradiso_23_304

    /// Updates to `cart` should be published via both Combine and
    /// NotificationCenter. Choose your fighter!!!
    @Published
    private(set) var cart: Cart {
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

    func clearCart() {
        var newCart = cart
        newCart.items = []
        self.setCart(newCart)
        self.isSumbitted = false
    }

    func setCart(_ newCart: Cart) {
        DispatchQueue.main.async {
            self.cart = newCart
        }
    }

    var fakeDiners: Set<FakeOtherDiner> = Set()

    func startFakeOrdering(diner: Diner, interval: TimeInterval) {
        let fake = FakeOtherDiner(diner: diner, interval: interval, maxItems: 4)
        fakeDiners.insert(fake)
    }

    func stopFakeOrdering() {
        fakeDiners.removeAll()
    }
}

extension GlobalState {
    static func stub(itemCount: Int = 4) -> GlobalState {
        let items: [Cart.Item] = (0 ..< itemCount)
            .map { Cart.Item.stub(index: $0) }
        let cart = Cart(items: items)
        return GlobalState(cart: cart)
    }
}
