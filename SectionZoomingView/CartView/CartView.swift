import SwiftUI

struct CartView: View {
    @EnvironmentObject
    var globalState: GlobalState

    var cart: Cart { self.globalState.cart }

    var submitButtonTitle: String {
        ["Place order", try? self.cart.totalPrice().formattedDescription]
            .compactMap { $0 }
            .joined(separator: " • ")
    }

    var onSubmit: () -> Void

    var onInviteDiners: () -> Void = {}

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: .otk_mediumSpacing) {
                ScrollView {
                    // Items within the scroll view set their own leading / trailing
                    // padding else the shadow gets clipped.

                    CartHeaderView(title: "Your cart",
                                   restaurantName: self.globalState.restaurantName,
                                   dinerCount: self.cart.totalDiners())
                        .frame(maxWidth: .infinity)
                        .padding([.leading, .trailing])

                    Spacer(minLength: .otk_mediumSpacing)

                    self.inviteDinersButton()
                        .padding([.leading, .trailing])

                    Spacer(minLength: .otk_largeSpacing)

                    self.allCartItemsList()
                        .padding([.leading, .trailing])
                }.padding([.top])

                self.submitButton()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: Cart Items
    /// Main dispatch for displaying cart.
    ///
    /// Sorting and grouping will depend on the number of courses / diners in the order
    func allCartItemsList() -> some View {
        let result: any View

        if cart.totalCourses() > 1 {
            // Multiple courses, we breakdown by course first, then diner
            result = self.itemListByCourse(items: cart.items)
        } else if cart.totalDiners() > 1 {
            // No course ordering, multiple diners - still breakdown by diner
            result = self.itemListByDiner(items: cart.items)
        } else {
            // Single diner, no courses - just a simple list of items
            result = self.simpleItemsList(items: cart.items)
        }
        return AnyView(result)
    }

    func itemListByCourse(items: [Cart.Item]) -> some View {
        let coursesAsTuples = Array(self.cart.items.byCourse().enumerated())
        return ForEach(coursesAsTuples, id: \.offset) { (i, courseItems) in
            Text("Course \(i + 1)")
            self.singleCourseItemList(course: i, items: courseItems)
        }
    }

    func itemListByDiner(items: [Cart.Item]) -> some View {
        let sortedDinerTuples = items.byDiner()          // dictionary of items by diner
            .map { $0 }                                  // as array of tuples
            .sorted { $0.0.firstName < $1.0.firstName }  // sorted by diner first name

        return VStack(spacing: .otk_mediumSpacing) {
            ForEach(sortedDinerTuples, id: \.key) { (diner, items) in
                VStack {
                    CartDinerView(diner: diner)
                    self.singleDinerItemList(diner: diner, items: items)
                }
            }
        }
    }

    func singleCourseItemList(course: Int, items: [Cart.Item]) -> some View {
        let result: any View
        if cart.totalDiners() < 2 {
            result = itemListByDiner(items: items)
        } else {
            result = simpleItemsList(items: items)
        }
        return AnyView(result)
    }

    /// List of items for a single diner
    func singleDinerItemList(diner: Diner, items: [Cart.Item]) -> some View {
        // Item List
        ForEach(items) {
            self.cartItem(item: $0)
        }
    }

    /// Simple list of the given items
    func simpleItemsList(items: [Cart.Item]) -> some View {
        ForEach(items) { item in
            self.cartItem(item: item)
        }
    }

    /// A single list item
    func cartItem(item: Cart.Item) -> some View {
        CartItemView(item: item)
            .background {
                Color(uiColor: .otk_white)
                    .cornerRadius(.otk_cornerRadius)
                    .otk_shadow()
            }
    }

    // MARK: Buttons
    func submitButton() -> some View {
        Button(submitButtonTitle, action: onSubmit)
            .foregroundColor(Color.otk_white)
            .font(.otf_systemFont(ofSize: 18, weight: .bold))
            .padding()
            .frame(maxWidth: .infinity)
            .background { Color.otk_red }
            .cornerRadius(.otk_cornerRadius)
            .padding()
    }

    func inviteDinersButton() -> some View {
        HStack {
            Button("Invite Diners") {
                self.onInviteDiners()
            }
                .font(Font.otf_systemFont(ofSize: 12, weight: .semibold))
                .foregroundColor(Color.ash_dark)
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing])
                .overlay {
                    RoundedRectangle(cornerRadius: .otk_cornerRadius)
                        .stroke(Color.ash_lighter, lineWidth: 1)
                }
            Spacer()
        }

    }
}

struct CartView_Previews: PreviewProvider {
    static var viewModel = CartViewModel(cart: .stub())

    static var previews: some View {
        CartView() {}
            .environmentObject(GlobalState.stub(itemCount: 9))
            .previewLayout(.sizeThatFits)
    }
}
