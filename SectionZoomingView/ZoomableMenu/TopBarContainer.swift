//
//  TopBarContainer.swift
//  SectionZoomingView
//
//  Created by Ryosuke Onaka on 11/1/22.
//

import SwiftUI

struct TopBarContainer: View {
    let searchBarViewModel: SearchBarViewModel

    init(searchBarViewModel: SearchBarViewModel) {
        self.searchBarViewModel = searchBarViewModel
    }

    var body: some View {
        VStack {
            SearchBar(viewModel: searchBarViewModel)
            TagBar()
        }
        .padding([.leading, .trailing], 8)
    }
}

struct TopBarContainer_Previews: PreviewProvider {
    static var previews: some View {
        TopBarContainer(searchBarViewModel: SearchBarViewModel())
    }
}
