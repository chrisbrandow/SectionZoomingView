import Foundation
import Combine

class CartViewModel: ObservableObject {
    @Published var cart: Cart

    init(cart: Cart) {
        self.cart = cart
    }
}

extension Cart {
    func itemsByDinerId() -> [Item.DinerID: [Item]] {
        var result: [Item.DinerID: [Item]] = [:]
        self.items.forEach { item in
            item.diners.forEach { diner in
                var dinerItems = result[diner] ?? []
                dinerItems.append(item)
                result[diner] = dinerItems
            }
        }
        return result
    }

    /// All items ordered by their courses.
    ///
    /// Empty courses will be compacted - for instance, an order whose items only
    /// belong to courses 0, 1, and 4 will produce an array of length 3
    func itemsByCourse() -> [[Item]] {
        var courses: [Int: [Item]] = [:]
        self.items.forEach { item in
            var courseItems = courses[item.course] ?? []
            courseItems.append(item)
            courses[item.course] = courseItems
        }
        return courses.keys
            .sorted()
            .map { courses[$0] }
            .compactMap { $0 }
    }
}
