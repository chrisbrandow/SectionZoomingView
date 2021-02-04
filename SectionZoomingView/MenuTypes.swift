//
//  MenuTypes.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/4/21.
//

import Foundation

//TODO: Chris Brandow  2021-02-02 to find a good example of menus, add this `HomeRestaurantCarouselCell
public enum Currency: Equatable {

    case CAD, GBP, MXN, USD, EUR, JPY, AUD, AED, unknown

    public static func fromString(_ type: String?) -> Currency {
        guard let type = type else { return .unknown }

        switch type.uppercased() {
        case "CAD":
            return .CAD
        case "GBP":
            return .GBP
        case "MXN":
            return .MXN
        case "USD":
            return .USD
        case "EUR":
            return .EUR
        case "JPY":
            return .JPY
        case "AUD":
            return .AUD
        case "AED":
            return .AED
        default:
            return .unknown
        }
    }

    public var stringValue: String {
        switch self {
        case .CAD:
            return "CAD"
        case .GBP:
            return "GBP"
        case .MXN:
            return "MXN"
        case .USD:
            return "USD"
        case .EUR:
            return "EUR"
        case .JPY:
            return "JPY"
        case .AUD:
            return "AUD"
        case .AED:
            return "AED"
        default:
            return "USD"
        }
    }
}


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

public struct TakeoutMenuGroup: Equatable, CustomDebugStringConvertible {
    private let menus: [TakeoutMenu]
    let title: String
    public init(menus: [TakeoutMenu], title: String) {
        self.menus = menus
        self.title = title
    }

    public var debugDescription: String {
        return "menus: \(self.menus)"
    }

    public var allSections: [TakeoutMenuSection] {
        self.menus.flatMap { $0.sections }
    }

    public var allItems: [TakeoutMenuItem] {
        self.menus.flatMap { $0.items }
    }

    public func contains(_ item: TakeoutMenuItem) -> Bool {
        return self.allItems.contains(item)
    }

    public func isPreviewOf(_ other: TakeoutMenuGroup) -> Bool {
        return Set(self.allItems).isSubset(of: other.allItems)
    }

    public func setItemsSoldOut(for ids: [String]) {
        ids.forEach { id in
            guard let item = self.allItems.first(where: { $0.id == id }) else {
                return
            }
            item.setSoldOut(true)
        }
    }
}

// MARK: - TakeoutMenu

public struct TakeoutMenu: Equatable, CustomDebugStringConvertible {
    public let name: String
    public let menuDescription: String?
    public let items: [TakeoutMenuItem]
    public let sections: [TakeoutMenuSection]

    init(name: String, menuDescription: String?, sections: [TakeoutMenuSection]) {
        self.name = name
        self.menuDescription = menuDescription
        self.sections = sections
        self.items = sections.flatMap { $0.items }
    }

    public func contains(_ item: TakeoutMenuItem) -> Bool {
        return self.items.contains(item)
    }

    public var debugDescription: String {
        return "name: \(self.name); items: \(self.items)"
    }

    public static func ==(lhs: TakeoutMenu, rhs: TakeoutMenu) -> Bool {
        return lhs.name == rhs.name && lhs.items == rhs.items
    }
}

// MARK: - TakeoutMenuSection

public struct TakeoutMenuSection {
    public let name: String?
    public let sectionDescription: String?
    public let items: [TakeoutMenuItem]
}

// MARK: - TakeoutMenuItem

public class TakeoutMenuItem: Equatable, Hashable {

    public let id: String
    public let name: String
    public let itemDescription: String?
    public private(set) var isSoldOut: Bool
    public let attributes: [String]
    public let modifierGroups: [TakeoutModifierGroup]
    public let price: Price

    init(id: String, name: String, itemDescription: String?, isSoldOut: Bool, attributes: [String], modifierGroups: [TakeoutModifierGroup], price: Price) {
        self.id = id
        self.name = name
        self.itemDescription = itemDescription
        self.isSoldOut = isSoldOut
        self.attributes = attributes
        self.modifierGroups = modifierGroups
        self.price = price
    }

    public func setSoldOut(_ value: Bool) {
        self.isSoldOut = value
    }

    public static func ==(lhs: TakeoutMenuItem, rhs: TakeoutMenuItem) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: - TakeoutModifierGroup

public struct TakeoutModifierGroup: Equatable, Hashable {
    public let id: String
    public let name: String
    public let description: String?
    public let required: Bool
    public let allowsMultipleSelection: Bool
    public let minimumAllowed: Int?
    public let maximumAllowed: Int?
    public let modifiers: [TakeoutModifier]

    public static func ==(lhs: TakeoutModifierGroup, rhs: TakeoutModifierGroup) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - TakeoutModifier

public struct TakeoutModifier: Equatable, Hashable {
    public let id: String
    public let name: String
    public let description: String?
    public let price: Price?
    public let tax: Price?

    public static func ==(lhs: TakeoutModifier, rhs: TakeoutModifier) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Obj-C Interop


// MARK: - TakeoutMenuAssembler

@objc
public final class TakeoutMenuAssembler: NSObject {

    @objc(sharedInstance)
    public static let shared = TakeoutMenuAssembler()

    public func createMenus(from dto: [String:Any], title: String) -> TakeoutMenuGroup {
        guard let menuDtos = dto["menus"] as? [[String:Any]] else {
            return TakeoutMenuGroup(menus: [], title: title)
        }

        let menus = menuDtos.compactMap { self.createMenu(from: $0) }
        return TakeoutMenuGroup(menus: menus, title: title)
    }

    private func createMenu(from dto: [String:Any]) -> TakeoutMenu? {
        let description = dto["description"] as? String
        guard let name = dto["name"] as? String,
              let sectionDtos = dto["groups"] as? [[String:Any]] else {
            return nil
        }

        let sections = sectionDtos.compactMap { self.createSection(from: $0) }
        assert(sections.isEmpty == false, "as per spec, can't create a menu with no items")
        return TakeoutMenu(name: name, menuDescription: description, sections: sections)
    }

    private func createSection(from dto: [String:Any]) -> TakeoutMenuSection? {
        let name = dto["name"] as? String
        let description = dto["description"] as? String

        guard let itemDtos = dto["items"] as? [[String:Any]] else {
            return nil
        }
        let items = itemDtos.compactMap { self.createItem(from: $0) }
        guard items.isEmpty == false else {
            return nil
        }

        return TakeoutMenuSection(name: name, sectionDescription: description, items: items)
    }

    private func createItem(from dto: [String:Any]) -> TakeoutMenuItem? {
        guard let id = dto["id"] as? String,
              let name = dto["name"] as? String,
              let price = dto["price"] as? [String:Any],
              let amount = price["amount"] as? Int,
              let currencyString = price["currency"] as? String else {
            return nil
        }

        let currency = Currency.fromString(currencyString)

        let description = dto["description"] as? String
        let attributes = dto["attributes"] as? [String] ?? []
        let isSoldOut = dto["isSoldOut"] as? Bool ?? false

        let modifierGroupDtos = dto["modifierGroups"] as? [[String:Any]] ?? []
        let modifierGroups = modifierGroupDtos.compactMap { self.createModifierGroup(from: $0) }

        let itemPrice = Price(amountTimes100: Decimal(amount), currency: currency)
        return TakeoutMenuItem(id: id, name: name, itemDescription: description, isSoldOut: isSoldOut, attributes: attributes, modifierGroups: modifierGroups, price: itemPrice)
    }

    private func createModifierGroup(from dto: [String:Any]) -> TakeoutModifierGroup? {
        guard let id = dto["id"] as? String,
              let name = dto["name"] as? String,
              let modifierDtos = dto["modifiers"] as? [[String:Any]] else {
            return nil
        }

        let description = dto["description"] as? String
        let required = dto["required"] as? Bool ?? false
        let allowsMultipleSelection = dto["multipleSelection"] as? Bool ?? false
        let minimumRequired = dto["minChoices"] as? Int
        let maximumRequired = dto["maxChoices"] as? Int

        let modifiers = modifierDtos.compactMap { self.createModifier(from: $0) }

        // no empty modifier groups
        guard modifiers.isEmpty == false else {
            return nil
        }

        return TakeoutModifierGroup(id: id, name: name, description: description, required: required, allowsMultipleSelection: allowsMultipleSelection, minimumAllowed: minimumRequired, maximumAllowed: maximumRequired, modifiers: modifiers)
    }

    private func createModifier(from dto: [String:Any]) -> TakeoutModifier? {
        guard let id = dto["id"] as? String,
              let name = dto["name"] as? String else {
            return nil
        }
        let description = dto["description"] as? String

        var price: Price?
        if let priceDto = dto["price"] as? [String:Any],
           let priceAmount = priceDto["amount"] as? Int,
           let priceCurrencyString = priceDto["currency"] as? String {
            let priceCurrency = Currency.fromString(priceCurrencyString)
            price = Price(amountTimes100: Decimal(priceAmount), currency: priceCurrency)
        }

        var tax: Price?
        if let taxDto = dto["tax"] as? [String:Any],
           let taxAmount = taxDto["amount"] as? Int,
           let taxCurrencyString = taxDto["currency"] as? String {
            let taxCurrency = Currency.fromString(taxCurrencyString)
            tax = Price(amountTimes100: Decimal(taxAmount), currency: taxCurrency)
        }

        return TakeoutModifier(id: id, name: name, description: description, price: price, tax: tax)
    }
}
