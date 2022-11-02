//
//  UIAppearanceAdditions.swift
//  OpenTable
//
//  Created by Olivier Larivain on 2/12/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit
import SwiftUI

extension UILabel {

    public var isAttributed: Bool {
        guard let attributedText = self.attributedText else { return false }
        let range = NSMakeRange(0, attributedText.length)
        var allAttributes = [Dictionary<NSAttributedString.Key, Any>]()
        attributedText.enumerateAttributes(in: range, options: []) { attributes, _, _ in
            allAttributes.append(attributes)
        }
        return allAttributes.count > 1
    }

    @objc
    public func useCustomFontWhenPossible(_ ignored: String?) {
        if self.isAttributed {
            return
        }
        self.font = self.font?.otf_adjustedFont()
    }
    
    @objc
    public func useSystemFontFor(_ ignored: String?) {
        let size = self.font.pointSize
        self.font = UIFont.systemFont(ofSize: size)
    }

    @objc
    public func useBoldSystemFontFor(_ ignored: String?) {
        let size = self.font.pointSize
        self.font = UIFont.systemFont(ofSize: size, weight: .bold)
    }
}

extension UITextField {
    @objc
	public func useCustomFontWhenPossible(_ ignored: String?) {
        self.font = self.font?.otf_adjustedFont()
	}
}

extension UITextView {
    @objc
	public func useCustomFontWhenPossible(_ ignored: String?) {
        self.font = self.font?.otf_adjustedFont()
    }
}

extension UIFont {

    @objc
	public static func otf_systemFontOfSize(_ fontSize: CGFloat) -> UIFont {
		return UIFont.systemFont(ofSize: fontSize).otf_adjustedFont()
	}

    public static func otf_systemFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: weight).otf_adjustedFont()
    }
    
    public func otf_adjustedFont() -> UIFont {
        let fontSize = self.pointSize
        let name: String
        
        if fontSize >= 18{
            // use Brandon Text
            guard self.familyName != "Brandon Text" else { return self }
            name = "BrandonText-Bold"
            return UIFont(name: name, size: fontSize) ?? self
        }
        else {
            // use system font
            guard self.familyName != "Brandon Text" else { return self }
            
            // weight
            if self.fontName.hasSuffix("Bold") || self.fontName.hasSuffix("Medium") || self.fontName.hasSuffix("Semibold") {
                return UIFont.systemFont(ofSize: fontSize, weight: .semibold)
            } else  {
                return UIFont.systemFont(ofSize: fontSize, weight: .regular)
            }
            
        }
    }
}

extension Font {
    public static func otf_systemFontOfSize(_ fontSize: CGFloat) -> Font {
        return Font(UIFont.otf_systemFontOfSize(fontSize))
    }
    
    public static func otf_systemFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> Font {
        return Font(UIFont.otf_systemFont(ofSize: fontSize, weight: weight))
    }
    
}

public final class SanFranciscoSystemLabel: UILabel {

}

/// a label that should have bold font, but is under the OTKit threshold for bold (18 pt)s
public final class UndersizedBoldSystemLabel: UILabel {

}
