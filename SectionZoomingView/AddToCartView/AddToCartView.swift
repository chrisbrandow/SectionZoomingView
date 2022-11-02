//
//  AddToCartView.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import SwiftUI

struct AddToCartView: View {
    var item: MenuItem

    var body: some View {
        VStack(alignment: .leading, spacing: .otk_mediumSpacing) {
            HStack(alignment: .top, spacing: .otk_mediumSpacing) {
                Text(item.name)
                    .otk_configureBodyText(fontSize: 14, weight: .bold)
                    .layoutPriority(1)
                Spacer()
                Text(item.price.formattedDescription ?? "")
                    .otk_configureBodyText(fontSize: 14)
                    .foregroundColor(.ash_dark)
                    .fixedSize(horizontal: true, vertical: false)
            }
            if let description = item.itemDescription {
                Text(description)
                    .otk_configureBodyText(fontSize: 12)
                    .lineLimit(2)
                    .foregroundColor(.ash)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
    }
}

struct AddToCartView_Previews: PreviewProvider {
    static var previews: some View {
        AddToCartView(item: .stub(index: 1))
    }
}
