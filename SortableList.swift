//
//  SortableList.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 11/4/22.
//

import SwiftUI

class SelectionViewModel: ObservableObject {
    struct Item {
        let title: String
        let isHeader: Bool
    }
    @Published var sections: [Item] = [
        .init(title: "Appetizer", isHeader: true),
        .init(title: "A", isHeader: false),
        .init(title: "B", isHeader: false),
        .init(title: "C", isHeader: false),
        .init(title: "Main Course", isHeader: true),
        .init(title: "D", isHeader: false),
        .init(title: "E", isHeader: false),
        .init(title: "F", isHeader: false),

    ]
}

struct SelectionView: View {
    @ObservedObject var selectionViewModel: SelectionViewModel

    var body: some View {
        List {
            ForEach(selectionViewModel.sections, id: \.title) { item in
                if item.isHeader {
                    Text("\(item.title)")
                        .moveDisabled(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .top, .bottom])
                        .background(Color.gray)
                        .listRowSeparator(.hidden)
                        .lineLimit(0)




                } else {
                    CartItemView(item: Cart.Item.stub(index: item.title == "D" ? 0 : 1))
//                    Text(item.title)
                        .moveDisabled(false)
                }
            }.onMove(perform: { indices, newOffset in
                print("should move")
            })
        }.environment(\.editMode, .constant(.active))
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView(selectionViewModel: .init())
    }
}
