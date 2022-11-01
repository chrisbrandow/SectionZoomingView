import SwiftUI

struct CartView: View {
    @ObservedObject
    var viewModel: CartViewModel

    var body: some View {
        VStack(spacing: .otk_mediumSpacing) {
            ForEach(viewModel.cart.orders.flatMap { $0.items}) {
                CartItemView(item: $0)
                    .background {
                        Color(uiColor: .otk_white)
                            .cornerRadius(8)
                            .shadow(color: Color(uiColor: .otk_ash_lighter), radius: 6, y: 6)
                    }
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
