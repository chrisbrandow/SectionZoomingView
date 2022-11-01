//
//  TakeoutMenuAssembler.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/1/22.
//

import Foundation

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

