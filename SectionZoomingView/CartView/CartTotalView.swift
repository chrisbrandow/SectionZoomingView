//
//  CartTotalView.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/1/22.
//

import SwiftUI

struct CartTotalView: View {
    var total: Price

    var body: some View {
        HStack {
            Text("Total")
            Spacer()
            Text(total.formattedDescription ?? "ERROR")
        }
    }
}

struct CartTotalView_Previews: PreviewProvider {
    static var previews: some View {
        CartTotalView(total: Price(amountTimes100: 6900, currency: .USD))
    }
}
