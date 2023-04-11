//
//  AddToCartView.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import SwiftUI

struct AddToCartView: View {
    var menuItem: MenuItem

    var diner: Diner

    @State var quantity: Int

    var onAddToCart: (Cart.Item) -> Void

    var onCancel: () -> Void

    var cartItem: Cart.Item {
        Cart.Item(menuItem: self.menuItem,
                  diners: [self.diner],
                  quantity: self.quantity)
    }

    var addToCartButtonTitle: String {
        if self.quantity > 0, let price = self.cartItem.totalPrice.formattedDescription {
            return "Add to cart • \(price)"
        } else {
            return "Add to cart"
        }
    }

    var body: some View {
        // Outer container to let the spacer grow, so we get a half-modal behavior
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: .otk_mediumSpacing) {
                MenuItemView(item: self.menuItem)
                ItemQuantityView(quantity: $quantity)
                    .padding([.top, .bottom], .otk_largeSpacing)
                CartButtonView(
                    style: .confirm,
                    title: self.addToCartButtonTitle,
                    isEnabled: self.quantity > 0) {
                        self.onAddToCart(self.cartItem)
                    }
                CartButtonView(
                    style: .cancel, title: "Cancel", isEnabled: true) {
                        self.onCancel()
                    }
            }
            .padding(.otk_mediumSpacing)
            .padding([.top], .otk_mediumSpacing) // Add a little more, just to the top
            .background (Color.white_ash)
            .cornerRadius(16
            )
        }.padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .background { Color(.clear)  }
        .frame(maxHeight: .infinity)

    }
}

struct AddToCartView_Previews: PreviewProvider {
    static var previews: some View {
        AddToCartView(menuItem: .stub(index: 1),
                      diner: .doug,
                      quantity: 1,
                      onAddToCart: { _ in},
                      onCancel: {})
    }
}
