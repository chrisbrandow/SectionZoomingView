//
//  TakeoutMenu.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/1/22.
//

import Foundation

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

