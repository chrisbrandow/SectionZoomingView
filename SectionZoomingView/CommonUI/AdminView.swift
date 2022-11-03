import SwiftUI

struct AdminView: View {
    var onClose: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: .otk_largeSpacing) {
                Text("Active Diner")
                    .font(Font.otf_systemFont(ofSize: 24, weight: .bold))
                HStack(spacing: 16) {
                    ForEach(Diner.allCases) { diner in
                        Button {
                            GlobalState.shared.diner = diner
                            self.onClose()
                        } label: {
                            DinerInitialsView(diner: diner)
                                .frame(width: 48, height: 48)
                        }
                    }
                }

                Divider().padding()

                Text("Fake Diner Ordering")
                    .font(Font.otf_systemFont(ofSize: 24, weight: .bold))
                Text("Tap a diner to simulate fake ordering in UI")
                HStack(spacing: 16) {
                    ForEach(Diner.allCases) { diner in
                        Button {
                            GlobalState.shared.startFakeOrdering(diner: diner)
                            self.onClose()
                        } label: {
                            DinerInitialsView(diner: diner)
                                .frame(width: 48, height: 48)
                        }
                    }
                }

                CartButtonView(style: .confirm, title: "Stop Fake Ordering", isEnabled: true) {
                    GlobalState.shared.stopFakeOrdering()
                    self.onClose()
                }
                .foregroundColor(Color.otk_red)

                Divider().padding()

                CartButtonView(style: .confirm, title: "Clear cart", isEnabled: true) {
                    GlobalState.shared.clearCart()
                    self.onClose()
                }
                .foregroundColor(Color.otk_red)

                Spacer()
                    .layoutPriority(1)
            }
            .padding()
            .navigationTitle("Admin")
            .navigationBarItems(leading: Button("Done") {
                    self.onClose()
                }.padding([.top, .bottom, .trailing])
                .foregroundColor(Color.otk_red))
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView() {}
    }
}
