//
//  DinerInitialsView.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import SwiftUI

struct DinerInitialsView: View {
    var diner: Diner

    var body: some View {
        Text(diner.initials)
            .frame(width: 24, height: 24)
            .font(.otf_systemFont(ofSize: 12, weight: .bold))
            .foregroundColor(.otk_white)
            .background {
                Circle()
                    .fill(Color.pseudoRandom(for: diner.initials))
            }

    }
}

fileprivate extension Color {
    private static func someRandomColors() -> [Color] {
        [.otk_purple, .otk_blue, .otk_green, .otk_orange]
    }

    // Stable random color for a string based on its hash
    static func pseudoRandom(for string: String) -> Color {
        let colors = someRandomColors()
        let i = abs(string.hashValue) % colors.count
        return colors[i]
    }
}

struct DinerInitialsView_Previews: PreviewProvider {
    static var previews: some View {
        DinerInitialsView(diner: .doug)
    }
}
