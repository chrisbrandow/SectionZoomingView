import Foundation
import Combine

class CartViewModel: ObservableObject {
    @Published var cart: Cart

    init(cart: Cart) {
        self.cart = cart
    }
}
