import SwiftUI

struct CartButtonView: View {
    enum Style {
        case confirm, cancel
    }

    var style: Style

    var title: String

    var isEnabled: Bool

    var onPress: () -> Void

    var body: some View {
        Button(self.title) {
            self.onPress()
        }
        .foregroundColor(self.foregroundColor)
        .font(.otf_systemFont(ofSize: 18, weight: .bold))
        .padding()
        .frame(maxWidth: .infinity)
        .background { self.backgroundColor }
        .cornerRadius(.otk_cornerRadius)
        .disabled(self.isEnabled == false)

        .overlay {
            RoundedRectangle(cornerRadius: .otk_cornerRadius)
                .stroke(self.strokeColor, lineWidth: 1)
        }
        .frame(maxWidth: .infinity)
    }

    private var foregroundColor: Color {
        switch self.style {
        case .confirm: return .otk_white
        case .cancel: return .ash_dark
        }
    }

    private var backgroundColor: Color {
        switch self.style {
        case .confirm: return self.isEnabled ? .otk_red : .ash_lighter
        case .cancel: return .clear
        }
    }

    private var strokeColor: Color {
        switch self.style {
        case .confirm: return .clear
        case .cancel: return .ash_lighter
        }
    }
}

struct CartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CartButtonView(style: .confirm, title: "Add to Cart", isEnabled: true, onPress: {})
            .previewDisplayName("Confirm")
        CartButtonView(style: .confirm, title: "Add to Cart", isEnabled: false, onPress: {})
            .previewDisplayName("Confirm (Disabled)")
        CartButtonView(style: .cancel, title: "Cancel", isEnabled: true, onPress: {})
            .previewDisplayName("Cancel")
    }
}
