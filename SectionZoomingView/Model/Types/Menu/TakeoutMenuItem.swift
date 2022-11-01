import Foundation

// MARK: MenuItem
struct MenuItem: Codable, Equatable, Hashable {
    var id: String
    var name: String
    var itemDescription: String?
    var isSoldOut: Bool?
    var attributes: [String]
    var modifierGroups: [Self.ModifierGroup]
    var price: Price

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: Modifier
extension MenuItem {
    struct Modifier: Codable, Equatable, Hashable {
        var id: String
        var name: String
        var description: String?
        var price: Price?
        var tax: Price?

        static func ==(lhs: Self, rhs: Self) -> Bool {
            return lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(self.id)
        }
    }
}

// MARK: ModifierGroup
extension MenuItem {
    struct ModifierGroup: Codable {
        var id: String
        var name: String
        var description: String?
        var required: Bool?
        var allowsMultipleSelection: Bool?
        var minimumAllowed: Int?
        var maximumAllowed: Int?
        var modifiers: [MenuItem.Modifier]

        static func ==(lhs: Self, rhs: Self) -> Bool {
            return lhs.id == rhs.id
        }
    }
}

