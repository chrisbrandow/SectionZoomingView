//
//  TagBarViewModel.swift
//  SectionZoomingView
//
//  Created by Ryosuke Onaka on 11/2/22.
//

import SwiftUI

// TODO: move logic here so we can test
class TagBarViewModel: ObservableObject {
    @Published var tappedTag: MenuTag = .none
}
