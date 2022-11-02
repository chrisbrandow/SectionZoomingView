//
//  AddToCartView.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import SwiftUI

struct AddToCartView: View {
    var menuItem: MenuItem

    @State var quantity: Int

    var onAddToCart: (Cart.Item) -> Void

    var onCancel: () -> Void

    var cartItem: Cart.Item {
        Cart.Item(menuItem: self.menuItem,
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
                self.addToCartButton()
                self.cancelButton()
            }
            .padding(.otk_mediumSpacing)
            .padding([.top], .otk_mediumSpacing) // Add a little more, just to the top
            .background (Color.white_ash)
        }
        .background { Color(.clear) }
        .frame(maxHeight: .infinity)
    }

    func addToCartButton() -> some View {
        Button(self.addToCartButtonTitle) {
            self.onAddToCart(self.cartItem)
        }
        .foregroundColor(.otk_white)
        .font(.otf_systemFont(ofSize: 18, weight: .bold))
        .padding()
        .frame(maxWidth: .infinity)
        .background { self.quantity > 0 ? Color.otk_red : Color.ash_lighter }
        .cornerRadius(.otk_cornerRadius)
        .disabled(self.quantity < 1)
    }

    func cancelButton() -> some View {
        Button("Cancel") {
            self.onCancel()
        }
        .foregroundColor(Color.ash_dark)
        .font(.otf_systemFont(ofSize: 18, weight: .bold))
        .padding()
        .frame(maxWidth: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: .otk_cornerRadius)
                .stroke(Color.ash_lighter, lineWidth: 1)
        }
        .frame(maxWidth: .infinity)
    }

}

struct AddToCartView_Previews: PreviewProvider {
    static var previews: some View {
        AddToCartView(menuItem: .stub(index: 1),
                      quantity: 1,
                      onAddToCart: { _ in},
                      onCancel: {})
    }
}
