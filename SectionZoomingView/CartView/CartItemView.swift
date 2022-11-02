import SwiftUI

struct CartItemView: View {
    @State var item: Cart.Item

    @State var shouldShowDescription: Bool = false

    var lineLimit: Int = 1

    var body: some View {
        VStack(alignment: .leading, spacing: .otk_mediumSpacing) {
            HStack(alignment: .top, spacing: .otk_mediumSpacing) {
                Text(item.menuItem.name)
                    .otk_configureBodyText(fontSize: 16, weight: .semibold)
                    .lineLimit(lineLimit)
                    .layoutPriority(1)
                Spacer()
                Text(item.menuItem.price.formattedDescription ?? "")
                    .otk_configureBodyText(fontSize: 16)
                    .foregroundColor(.ash_dark)
                    .fixedSize(horizontal: true, vertical: false)
            }
            if let description = item.menuItem.itemDescription, shouldShowDescription {
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
            .previewLayout(.sizeThatFits)
    }
}
