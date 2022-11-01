//
//  File.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 11/1/22.
//

import UIKit


// single entry in a cart. represents the ordered item, and likely a user who ordered
struct CartEntry: Codable {
    // orderedItem (id?)
    // user?
    // status?
    // course?
}

struct Cart: Codable {
    var orders: [DinerOrder]
    // allItems
    // courses
    // …
}

struct DinerOrder: Codable {
    var dinerId: String

    var courses: [Int: Course]
}

struct Course: Codable {
    var items: [MenuItem]
//    enum : Codable, Equatable, Hashable {
//        case appetizer, salad, main, dessert, generic(Int)
//    }

}

