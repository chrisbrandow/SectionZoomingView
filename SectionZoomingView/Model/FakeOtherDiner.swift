/*
 Simulates orders coming in asynchronously from other diners
 */
import Foundation

class FakeOtherDiner {
    var diner: Diner

    let timer: Timer

    init(diner: Diner, interval: TimeInterval = 1) {
        self.diner = diner
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            print("it's working, son.")
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
