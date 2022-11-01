//
//  TakeoutModifierGroup.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/1/22.
//

import Foundation

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

