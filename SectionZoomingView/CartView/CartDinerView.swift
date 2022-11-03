//
//  CartDinerView.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import SwiftUI

/// Displays an avatar / initials and diner's name for cart listings
struct CartDinerView: View {
    var diner: Diner

    var body: some View {
        HStack {
            DinerInitialsView(diner: diner)
            Text("Added by \(diner.firstName)")
                .foregroundColor(.ash)
                .font(.otf_systemFontOfSize(14))
            Spacer()
        }
    }
}

struct CartDinerView_Previews: PreviewProvider {
    static var previews: some View {
        CartDinerView(diner: .doug)
    }
}
