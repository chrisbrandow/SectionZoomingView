//
//  File.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 11/1/22.
//

import UIKit

struct Cart: Codable {
    var orders: [Self.Order]
}

extension Cart {
    struct Item: Codable {
        var id: String
        var menuItem: MenuItem
        var quantity: Int = 1
        var course: Int?
    }
}

extension Cart {
    struct Order: Codable {
        var dinerId: String

        var items: [Cart.Item]
    }
}

extension Cart {
    static func stub() throws -> Self {
        Cart(orders: [try .stub()])
    }
}

extension Cart.Order {
    static func stub() throws -> Self {
        return Cart.Order(dinerId: UUID().uuidString,
                          items: try (0 ..< 4).map { _ in try .stub() })
    }
}

extension Cart.Item {
    static func stub() throws -> Self {
        Cart.Item(id: UUID().uuidString, menuItem: .random())
    }
}

fileprivate extension MenuItem {
    static func random() -> Self {
        return try! MenuDataSource.load(example: .laPressa_4_14, title: "A Random Menu")
            .allItems
            .randomElement()!
    }
}
