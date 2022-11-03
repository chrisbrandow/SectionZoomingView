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
        Circle()
            .fill(Color.pseudoRandom(for: diner.initials))
            .frame(minWidth: 24, minHeight: 24)
            .frame(maxWidth: 48, maxHeight: 48)
            .overlay {
                Text(diner.initials)
                    .font(.otf_systemFont(ofSize: 12, weight: .bold))
                    .foregroundColor(.otk_white)
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
