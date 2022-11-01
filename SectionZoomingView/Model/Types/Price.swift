import Foundation

struct Price: Equatable, Hashable {
    private var amountTimes100: Decimal

    var currency: Currency?

    var amount: Decimal { amountTimes100 / 100 }

    init(amountTimes100: Decimal, currency: Currency?) {
        self.amountTimes100 = amountTimes100
        self.currency = currency
    }

    init(exactAmount: Decimal, currency: Currency?) {
        self.amountTimes100 = exactAmount * 100
        self.currency = currency
    }

    static func *(lhs: Price, rhs: Decimal) -> Price {
        Price(exactAmount: lhs.amount * rhs, currency: lhs.currency)
    }

    var formattedDescription: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = self.currency?.stringValue

        return formatter.string(from: NSDecimalNumber(decimal: self.amount))
    }
}

extension Price: Codable {
    enum CodingKeys: String, CodingKey {
        case amountTimes100 = "amount"
        case currency
    }
}

extension Price: CustomDebugStringConvertible {
    var debugDescription: String {
        return "amount: \(self.amount),\ncurrency: \(self.currency?.stringValue ?? "-")"
    }
}
