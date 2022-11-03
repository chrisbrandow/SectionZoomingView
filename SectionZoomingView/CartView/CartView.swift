import SwiftUI

struct CartView: View {
    @ObservedObject
    var viewModel: CartViewModel

    var body: some View {
        VStack(spacing: .otk_mediumSpacing) {
            ForEach(viewModel.cart.items) {
                CartItemView(item: $0)
                    .background {
                        Color(uiColor: .otk_white)
                            .cornerRadius(8)
                            .otk_shadow()
                    }
            }
            if let total = try? viewModel.cart.totalPrice() {
                CartTotalView(total: total)
            }
        }.padding()
    }
}

struct CartView_Previews: PreviewProvider {
    static var viewModel = CartViewModel(cart: .stub())

    static var previews: some View {
        CartView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
    }
}
