//
//  MenuItemView.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import SwiftUI

struct MenuItemView: View {
    var item: MenuItem

    var body: some View {
        VStack(alignment: .leading, spacing: .otk_mediumSpacing) {
            HStack(alignment: .top, spacing: .otk_mediumSpacing) {
                Text(self.item.name)
                    .otk_configureBodyText(fontSize: 18, weight: .bold)
                    .layoutPriority(2)
                Spacer()
                Text(self.item.price.formattedDescription ?? "")
                    .otk_configureBodyText(fontSize: 18)
                    .foregroundColor(.ash_dark)
                    .fixedSize(horizontal: true, vertical: false)
            }
            if let description = self.item.itemDescription {
                Text(description)
                    .otk_configureBodyText(fontSize: 12)
                    .lineLimit(2)
                    .foregroundColor(.ash)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView(item: .stub(index: 3))
    }
}
