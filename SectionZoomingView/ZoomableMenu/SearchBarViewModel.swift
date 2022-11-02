//
//  SearchBarViewModel.swift
//  SectionZoomingView
//
//  Created by Ryosuke Onaka on 11/1/22.
//

import Combine

class SearchBarViewModel: ObservableObject {
    @Published var searchQuery: String = ""
}
