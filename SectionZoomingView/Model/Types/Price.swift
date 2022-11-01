import Foundation

struct Price: Codable, Equatable, Hashable {
    var amount: Decimal
    var currency: Currency?

    init(amountTimes100: Decimal, currency: Currency?) {
        self.amount = amountTimes100 / 100
        self.currency = currency
    }

    init(exactAmount: Decimal, currency: Currency?) {
        self.amount = exactAmount
        self.currency = currency
    }

    static func *(lhs: Price, rhs: Decimal) -> Price {
        return Price(exactAmount: lhs.amount * rhs, currency: lhs.currency)
    }

    var formattedDescription: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = self.currency?.stringValue

        return formatter.string(from: NSDecimalNumber(decimal: self.amount))
    }
}

extension Price: CustomDebugStringConvertible {
    var debugDescription: String {
        return "amount: \(self.amount),\ncurrency: \(self.currency?.stringValue ?? "-")"
    }
}
