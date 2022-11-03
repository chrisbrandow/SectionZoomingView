import SwiftUI

struct AdminView: View {
    var onClose: () -> Void

    @State var fakeDuration: TimeInterval = 2

    var body: some View {
        NavigationView {
            VStack(spacing: .otk_largeSpacing) {
                Group {
                    Text("Active Diner")
                        .font(Font.otf_systemFont(ofSize: 18, weight: .bold))
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
                }

                Divider()

                Group {
                    Text("Fake Diner Ordering")
                        .font(Font.otf_systemFont(ofSize: 18, weight: .bold))
                    Text("Tap a diner to simulate fake ordering in UI")
                    HStack(spacing: 16) {
                        ForEach(Diner.allCases) { diner in
                            Button {
                                GlobalState.shared.startFakeOrdering(diner: diner, interval: fakeDuration)
                                self.onClose()
                            } label: {
                                DinerInitialsView(diner: diner)
                                    .frame(width: 48, height: 48)
                            }
                        }
                    }

                    HStack {
                        Text("Interval")
                        Slider(value: self.$fakeDuration, in: 1 ... 10)
                        Text(String(format: "%.1fs", self.fakeDuration))
                    }

                    CartButtonView(style: .cancel, title: "Stop Fake Ordering", isEnabled: true) {
                        GlobalState.shared.stopFakeOrdering()
                        self.onClose()
                    }
                    .foregroundColor(Color.otk_red)
                }

                Divider()

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
            .navigationBarTitleDisplayMode(.inline)
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
