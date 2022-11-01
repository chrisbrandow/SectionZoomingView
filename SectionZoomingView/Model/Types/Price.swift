//
//  Price.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/1/22.
//

import Foundation

public struct Price: CustomDebugStringConvertible, Hashable {
    public let amount: Decimal
    public let currency: Currency?

    public init(amountTimes100: Decimal, currency: Currency?) {
        self.amount = amountTimes100 / 100
        self.currency = currency
    }

    public init(exactAmount: Decimal, currency: Currency?) {
        self.amount = exactAmount
        self.currency = currency
    }

    public static func *(lhs: Price, rhs: Decimal) -> Price {
        return Price(exactAmount: lhs.amount * rhs, currency: lhs.currency)
    }

    public var debugDescription: String {
        return "amount: \(self.amount),\ncurrency: \(self.currency?.stringValue ?? "-")"
    }

    public var formattedDescription: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = self.currency?.stringValue

        return formatter.string(from: NSDecimalNumber(decimal: self.amount))
    }
}
