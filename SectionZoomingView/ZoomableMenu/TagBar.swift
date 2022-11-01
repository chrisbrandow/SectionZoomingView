//
//  TagBar.swift
//  SectionZoomingView
//
//  Created by Ryosuke Onaka on 11/1/22.
//

import SwiftUI

struct TagBar: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                TagText(title: "Vegetarian")
                TagText(title: "Gluten free")
                TagText(title: "Vegan")
                TagText(title: "Raw")
                TagText(title: "Dairy")
            }
            .padding(1)
        }
    }
}

struct TagText: View {
    let title: String

    var body: some View {
        Text(title)
            .foregroundColor(.black)
            .font(Font(uiFont: UIFont(name: "BrandonText-Bold", size: 12)!))
            .padding([.leading, .trailing], 16)
            .padding([.top, .bottom], 8)
            .overlay(
                Capsule(style: .continuous)
                    .stroke(.gray, lineWidth: 1)
            )
    }
}

struct TagBar_Previews: PreviewProvider {
    static var previews: some View {
        TagBar()
    }
}
