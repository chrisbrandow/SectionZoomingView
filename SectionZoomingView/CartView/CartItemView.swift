import SwiftUI

struct CartItemView: View {
    @State var item: Cart.Item

    var body: some View {
        VStack(alignment: .leading, spacing: .otk_mediumSpacing) {
            HStack(alignment: .top, spacing: .otk_mediumSpacing) {
                Text(item.menuItem.name)
                    .otk_configureBodyText(fontSize: 14, weight: .bold)
                    .layoutPriority(1)
                Spacer()
                Text(item.menuItem.price.formattedDescription ?? "")
                    .otk_configureBodyText(fontSize: 14)
                    .foregroundColor(.ash_dark)
                    .fixedSize(horizontal: true, vertical: false)
            }
            if let description = item.menuItem.itemDescription {
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

struct CartItemView_Previews: PreviewProvider {
    @State static var item: Cart.Item = .stub(index: 1)

    static var previews: some View {
        CartItemView(item: item)
//            .frame(width: 390, height: 100)
            .previewLayout(.sizeThatFits)
    }
}
