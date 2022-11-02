//
//  AddToCartView.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import SwiftUI

struct AddToCartView: View {
    var item: MenuItem

    @State var quantity: Int

    var onAddToCart: (Cart.Item) -> Void

    var onCancel: () -> Void

    var cartItem: Cart.Item {
        Cart.Item(menuItem: self.item,
                  quantity: self.quantity)
    }

    var addToCartButtonTitle: String {
        if let price = self.item.price.formattedDescription {
            return "Add to cart • \(price)"
        } else {
            return "Add to cart"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .otk_mediumSpacing) {
            HStack(alignment: .top, spacing: .otk_mediumSpacing) {
                Text(item.name)
                    .otk_configureBodyText(fontSize: 24, weight: .bold)
                    .layoutPriority(2)
                Spacer()
                Text(item.price.formattedDescription ?? "")
                    .otk_configureBodyText(fontSize: 18)
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
            ItemQuantityView(quantity: $quantity)
                .padding([.top, .bottom], .otk_largeSpacing)
            self.addToCartButton()
            self.cancelButton()
        }
        .padding()
    }

    func addToCartButton() -> some View {
        Button(self.addToCartButtonTitle) {
            self.onAddToCart(self.cartItem)
        }
        .foregroundColor(.otk_white)
        .font(.otf_systemFont(ofSize: 18, weight: .bold))
        .padding()
        .frame(maxWidth: .infinity)
        .background { Color.otk_red }
        .cornerRadius(.otk_cornerRadius)
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
        AddToCartView(item: .stub(index: 1),
                      quantity: 1,
                      onAddToCart: { _ in},
                      onCancel: {})
    }
}
