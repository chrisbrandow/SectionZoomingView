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
    static func stub() -> Self {
        Cart(orders: [.stub()])
    }
}

extension Cart.Order {
    static func stub() -> Self {
        return Cart.Order(dinerId: UUID().uuidString,
                          items: (0 ..< 4).map { .stub(index: $0) })
    }
}

extension Cart.Item {
    static func stub(index: Int) -> Self {
        Cart.Item(id: UUID().uuidString, menuItem: .stub(index: index))
    }
}

fileprivate extension MenuItem {
    static func stub(index: Int) -> Self {
        let allItems = try! MenuDataSource
            .load(example: .laPressa_4_14, title: "A Random Menu")
            .allItems
        // Just wrap around to beginning if needed
        let safeIndex = index % allItems.count
        return allItems[safeIndex]
    }

    static func random() -> Self {
        return try! MenuDataSource.load(example: .laPressa_4_14, title: "A Random Menu")
            .allItems
            .randomElement()!
    }
}
