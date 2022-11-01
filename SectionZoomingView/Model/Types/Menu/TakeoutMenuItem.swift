//
//  TakeoutMenuItem.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/1/22.
//

import Foundation

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
