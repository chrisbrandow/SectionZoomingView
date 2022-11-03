/*
 Simulates orders coming in asynchronously from other diners
 */
import Foundation

class FakeOtherDiner {
    var diner: Diner

    var timer: Timer

    init(diner: Diner, interval: TimeInterval = 2, maxItems: Int) {
        self.diner = diner

        var addedItems: Int = 0

        print("\(diner.firstName) is ordering")

        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            let item = Cart.Item(menuItem: .random(), diners: [diner])
            GlobalState.shared.addToCart(item)

            addedItems += 1

            print("\(diner.firstName) added item \(item.menuItem.name) (total: \(addedItems))")
            if addedItems >= maxItems {
                print("\(diner.firstName) is finished ordering")
                timer.invalidate()
            }
        }
    }

    deinit {
        self.timer.invalidate()
    }
}

extension FakeOtherDiner: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(diner.hashValue)
    }
}

extension FakeOtherDiner: Equatable {
    static func == (lhs: FakeOtherDiner, rhs: FakeOtherDiner) -> Bool {
        lhs.diner == rhs.diner
    }
}
