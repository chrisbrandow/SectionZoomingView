//
//  ItemQuantityView.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import SwiftUI

struct ItemQuantityView: View {
    @Binding var quantity: Int

    var minimumQuantity: Int = 0
    var maximumQuantity: Int = .max

    var body: some View {
        HStack(spacing: 8) {
            Spacer()
            self.button("−", isEmabled: self.quantity > self.minimumQuantity) {
                self.quantity = max(self.minimumQuantity, self.quantity - 1)
            }
            Text("\(quantity)")
                .frame(width: 40)
            self.button("+", isEmabled: self.quantity < self.maximumQuantity) {
                self.quantity = min(self.maximumQuantity, self.quantity + 1)
            }
            Spacer()
        }
    }

    private func button(_ title: String, isEmabled: @autoclosure () -> Bool, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .disabled(isEmabled() == false)
            .font(Font.otf_systemFontOfSize(24))
            .frame(width: 40, height: 40)
            .background {
                Circle()
                    .foregroundColor(.otk_white)
                    .otk_shadow()
            }
            .foregroundColor(isEmabled() ? .ash_dark : .ash_lighter)
    }
}

fileprivate struct CircleButtonView: View {
    var text: String
    var body: some View {
        Text(text)
            .otk_configureBodyText(fontSize: 24)
            .padding()
    }
}

struct ItemQuantityView_Previews: PreviewProvider {
    struct PreviewContainer: View {
        @State var quantity: Int = 1
        var body: some View {
            ItemQuantityView(quantity: $quantity)
        }
    }

    static var previews: some View {
        PreviewContainer(quantity: 1)
    }
}
