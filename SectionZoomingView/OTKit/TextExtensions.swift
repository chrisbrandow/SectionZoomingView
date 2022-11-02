//
//  SectionTitle.swift
//  OpenTable
//
//  Created by Jack Rubin on 7/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import SwiftUI

extension Text {
    enum TitleType: Double {case title = 24.0, subtitle = 18.0}
    
    func otk_configureSectionTitle(_ titleType: TitleType) -> some View {
        self.font(Font.otf_systemFontOfSize(titleType.rawValue))
            .foregroundColor(Color.ash_dark)
            .padding(.horizontal, .otk_mediumSpacing)
    }

    /**
     Sets a font appropriate for body text on the view
     
     This variant adds additional line spacing to match CSS / Figma line height.

     - Parameters:
        - fontSize: Size in points of the font
        - weight: Weight of the font

     - Note: This was added to confom to a design spec for the Promotions Header. It may or may not be what you're looking for. If you use this anywhere else, please remove this comment.
     */
    func otk_configureBodyText(fontSize: CGFloat = 14,
                               weight: UIFont.Weight = .regular) -> some View {
        let lineHeight = OTKit.Font.lineHeight(fontSize: fontSize)
        return self.font(.otf_systemFont(ofSize: fontSize, weight: weight))
            .lineSpacing((lineHeight - fontSize) * 0.5)
    }
}

extension NavigationLink {
    func otk_configureSecondaryButton() -> some View {
        self.font(.otf_systemFont(ofSize: 14.0, weight: .semibold))
            .foregroundColor(Color.otk_red)
    }
}

extension View {
    func otk_background() -> some View {
        self.background(Color.otk_white.edgesIgnoringSafeArea(.all))
    }
}
