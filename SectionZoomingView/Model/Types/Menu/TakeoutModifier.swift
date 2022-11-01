//
//  TakeoutModifier.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/1/22.
//

import Foundation

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
