//
//  Shadow.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import Foundation
import SwiftUI

extension View {
    func otk_shadow() -> some View {
        self.shadow(color: Color(uiColor: .otk_ash_lighter), radius: 4, y: 2)
    }
}
