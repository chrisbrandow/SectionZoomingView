//
//  Font+UIFont.swift
//  SectionZoomingView
//
//  Created by Ryosuke Onaka on 11/1/22.
//

import SwiftUI

extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
