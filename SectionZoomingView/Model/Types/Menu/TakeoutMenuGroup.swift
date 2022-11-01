//
//  TakeoutMenuGroup.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/1/22.
//

import Foundation

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

