//
//  CartHeaderView.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import SwiftUI

struct CartHeaderView: View {
    var title: String

    var restaurantName: String?

    var dinerCount: Int

    private func dinerCountDescription() -> String? {
        guard dinerCount > 1 else { return nil }
        return "You and \(dinerCount) people are ordering"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(Font.otf_systemFont(ofSize: 24, weight: .bold))
                .padding([.bottom], 4)
            if let restaurantName = restaurantName {
                HStack {
                    Image("ic_restaurant")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 24)
                    Text(restaurantName)
                    Spacer()
                }
            }
            if let description = dinerCountDescription() {
                HStack {
                    Image("ic_partycount")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 24)
                    Text(description)
                    Spacer()
                }
            }
        }
        .font(Font.otf_systemFontOfSize(16))
        .foregroundColor(Color.ash_dark)
    }
}

struct CartHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CartHeaderView(title: "Your Cart", restaurantName: "Leo's Oyster Bar", dinerCount: 3)
    }
}
