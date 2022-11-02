//
//  TagBar.swift
//  SectionZoomingView
//
//  Created by Ryosuke Onaka on 11/1/22.
//

import SwiftUI

struct TagBar: View {
    @ObservedObject var viewModel: TagBarViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                TagButton(tag: .vegetarian,
                          tappedTag: $viewModel.tappedTag)
                TagButton(tag: .glutenFree,
                          tappedTag: $viewModel.tappedTag)
                TagButton(tag: .vegan,
                          tappedTag: $viewModel.tappedTag)
                TagButton(tag: .raw,
                          tappedTag: $viewModel.tappedTag)
                TagButton(tag: .dairy,
                          tappedTag: $viewModel.tappedTag)
            }
            .padding(1)
        }
    }
}

struct TagButton: View {
    let tag: MenuTag
    @Binding var tappedTag: MenuTag

    var body: some View {
        Button(
            action: {
                if tag == tappedTag {
                    tappedTag = .none
                }
                else {
                    tappedTag = tag
                }
            },
            label: {
                Text(tag.rawValue)
                    .foregroundColor(tappedTag == tag ? Color(.otk_greenDark): Color(.otk_ashDark))
                    .font(.caption)
                    .padding([.leading, .trailing], 16)
                    .padding([.top, .bottom], 8)
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(tappedTag == tag ? Color(.otk_green): Color(.otk_ashLighter), lineWidth: 1)
                    )
                    .background(tappedTag == tag ? Color(.otk_greenLightest): Color(.otk_white))
            }
        )
    }
}

struct TagText: View {
    let title: String

    var body: some View {
        Text(title)
            .foregroundColor(Color(.otk_ashDark))
            .font(.caption)
            .padding([.leading, .trailing], 16)
            .padding([.top, .bottom], 8)
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color(.otk_ashLighter), lineWidth: 1)
            )
    }
}

struct TagBar_Previews: PreviewProvider {
    static var previews: some View {
        TagBar(viewModel: TagBarViewModel())
    }
}
