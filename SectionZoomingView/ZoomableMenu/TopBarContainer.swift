//
//  TopBarContainer.swift
//  SectionZoomingView
//
//  Created by Ryosuke Onaka on 11/1/22.
//

import SwiftUI

struct TopBarContainer: View {
    let searchBarViewModel: SearchBarViewModel
    let tagBarViewModel: TagBarViewModel

    init(searchBarViewModel: SearchBarViewModel,
         tagBarViewModel: TagBarViewModel) {
        self.searchBarViewModel = searchBarViewModel
        self.tagBarViewModel = tagBarViewModel
    }

    var body: some View {
        VStack {
            SearchBar(viewModel: searchBarViewModel)
            TagBar(viewModel: tagBarViewModel)
        }
        .padding([.leading, .trailing], 8)
    }
}

struct TopBarContainer_Previews: PreviewProvider {
    static var previews: some View {
        TopBarContainer(searchBarViewModel: SearchBarViewModel(),
                        tagBarViewModel: TagBarViewModel())
    }
}
