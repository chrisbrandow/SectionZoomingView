//
//  SearchBar.swift
//  SectionZoomingView
//
//  Created by Ryosuke Onaka on 11/1/22.
//

import SwiftUI

struct SearchBar: View {
    @State var query: String = ""

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("", text: $query)
                .foregroundColor(.black)
                .font(Font(uiFont: UIFont(name: "BrandonText-Bold", size: 12)!))
        }
        .frame(height: 40)
        .padding(.leading, 8)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.gray, lineWidth: 1)
                .shadow(color: .gray, radius: 8, x: 0, y: 2)
        )
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
