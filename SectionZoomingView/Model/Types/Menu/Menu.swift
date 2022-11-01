import Foundation

struct Menu {
    // Stored
    var name: String
    var menuDescription: String?
    var sections: [Self.Section]

    // Computed
    var items: [MenuItem] {
        sections.flatMap { $0.items }
    }

    func contains(_ item: MenuItem) -> Bool {
        return self.items.contains(item)
    }
}

// MARK: Codable
extension Menu: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case menuDescription = "description"
        case sections = "groups"
    }
}

// MARK: Equatable
extension Menu: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name && lhs.items == rhs.items
    }
}

// MARK: CustomDebugStringConbertible
extension Menu: CustomDebugStringConvertible {
    var debugDescription: String {
        return "name: \(self.name); items: \(self.items)"
    }
}

// MARK: Menu Section
extension Menu {
    struct Section: Codable {
        var name: String?
        var sectionDescription: String?
        var items: [MenuItem]
    }
}
