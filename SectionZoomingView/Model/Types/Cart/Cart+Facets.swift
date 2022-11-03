import Foundation

// Various convenience functions for grouping cart items by some property
extension Cart {
    enum Error: Swift.Error {
        /// The order contains items in multiple currencies, which is unsupported
        case multipleCurrencies(Set<Currency>)
    }

    /// Total of all items in the cart
    ///
    /// A quirk or our menu structure is that each item can have its own currency. While it's probably not going to
    /// happen in the real world to see multiple currencies on one menu, we have to prepare for the eventuality.
    /// I'm not sure what the UI implications of this are, so you should probably just take the first item of this
    /// array.
    ///
    /// Or just think of a better way to valiate / prevent this at the Menu construction phase of things.
    // TODO: validate this when we're building the menu. It's awkward to handle errors here
    func totalPrice() throws -> Price {
        let currencies = Set(self.items.compactMap { $0.menuItem.price.currency })
        if currencies.count > 1 {
            throw Error.multipleCurrencies(currencies)
        }

        return items.reduce(Price(amountTimes100: 0, currency: currencies.first)) {
            $0 + $1.totalPrice
        }
    }

    func totalItems() -> Int {
        return items.reduce(0) { $0 + $1.quantity }
    }

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
