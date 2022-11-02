import Foundation

extension MenuItem {
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
