//
//  TopBarContainer.swift
//  SectionZoomingView
//
//  Created by Ryosuke Onaka on 11/1/22.
//

import SwiftUI

struct TopBarContainer: View {
    var body: some View {
        VStack {
            SearchBar()
            TagBar()
        }
        .padding([.leading, .trailing], 8)
    }
}

struct TopBarContainer_Previews: PreviewProvider {
    static var previews: some View {
        TopBarContainer()
    }
}
