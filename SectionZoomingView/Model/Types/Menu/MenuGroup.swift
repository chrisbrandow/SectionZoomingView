import Foundation

struct MenuGroup: Codable, Equatable {
    var menus: [Menu]

    var title: String?

    var allSections: [Menu.Section] {
        self.menus.flatMap { $0.sections }
    }

    var allItems: [MenuItem] {
        self.menus.flatMap { $0.items }
    }

    func contains(_ item: MenuItem) -> Bool {
        return self.allItems.contains(item)
    }

    func isPreviewOf(_ other: Self) -> Bool {
        return Set(self.allItems).isSubset(of: other.allItems)
    }

//    func setItemsSoldOut(forItemIds ids: [String]) {
//        ids.forEach { id in
//            guard let item = self.allItems.first(where: { $0.id == id }) else {
//                return
//            }
//            item.isSoldOut = true
//        }
//    }
}

extension MenuGroup: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "menus: \(self.menus)"
    }
}
