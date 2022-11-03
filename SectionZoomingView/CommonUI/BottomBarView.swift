//
//  BottomBarView.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject
    var globalState: GlobalState

    var cart: Cart { self.globalState.cart }

    var onPressViewCart: () -> Void

    var cartDescription: String {
        guard self.cart.items.count > 0
        else { return "Your cart is empty" }

        return [try? cart.totalPrice().formattedDescription,
                "\(self.cart.totalItems()) items"]
            .compactMap { $0 }
            .joined(separator: " • ")
    }

    var body: some View {
        HStack {
            Text(self.cartDescription)
                .layoutPriority(1)
                .font(.otf_systemFontOfSize(16))
            Spacer()
            Button("View cart", action: self.onPressViewCart)
                .font(.otf_systemFont(ofSize: 16, weight: .semibold))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundColor(.otk_white)
        .background {
            Color.otk_red
        }
        .cornerRadius(.otk_cornerRadius)
        .padding([.leading, .trailing])
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView() {}
            .environmentObject(GlobalState.stub())
            .previewDisplayName("With Items")
        BottomBarView() {}
            .environmentObject(GlobalState.stub(itemCount: 0))
            .previewDisplayName("Empty")
    }
}
