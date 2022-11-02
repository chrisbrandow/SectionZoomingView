//
//  SearchBar.swift
//  SectionZoomingView
//
//  Created by Ryosuke Onaka on 11/1/22.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var viewModel: SearchBarViewModel

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.otk_ash))
            TextField("", text: $viewModel.searchQuery)
                .foregroundColor(Color(.otk_ashDarker))
                .font(.callout)
        }
        .frame(height: 40)
        .padding(.leading, 8)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color(.otk_ashLightest), lineWidth: 1)
                // TODO: drop shadow
        )
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(viewModel: SearchBarViewModel())
    }
}
