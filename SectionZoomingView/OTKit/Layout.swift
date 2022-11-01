import UIKit

/*
 A home for layout constants that we don't inherit from OTKit, for whatever reason
 */

public struct Layout {
    /// 4.0
    static let menuItemMargin: CGFloat = 4.0
    /// 16.0
    static let buttonSpacing: CGFloat = 16.0
    /// 16.0
    static let bottomDrawerMargin: CGFloat = 16.0
    /// 8.0
    static let bottomDrawerInterMargin: CGFloat = 8.0
    /// 8.0
    static let floatingLeadingMargin: CGFloat = 8.0
    /// 80.0
    static let exposedViewWidth: CGFloat = 80.0
    /// 4.0
    static let cornerRadius: CGFloat = 4.0
}

extension CGFloat {
    /// 4.0
    static let otk_menuItemMargin: CGFloat = 4.0
    /// 16.0
    static let otk_buttonSpacing: CGFloat = 16.0
    /// 16.0
    static let otk_bottomDrawerMargin: CGFloat = 16.0
    /// 32.0
    static let otk_bottomButtonSpacing: CGFloat = 32.0
    /// 32.0
    static let otk_incrementButtonHeight: CGFloat = 40
    /// 8.0
    static let otk_bottomDrawerInterMargin: CGFloat = 8.0
    /// 8.0
    static let otk_floatingLeadingMargin: CGFloat = 8.0
    /// 80.0
    static let otk_exposedViewWidth: CGFloat = 80.0
    /// 4.0
    static let otk_cornerRadius: CGFloat = 4.0
}

extension UIColor {
    static var otk_ashDark: UIColor { return UIColor(named: "otKit_ash_dark") ?? .black }
    static var otk_ashDarker: UIColor { return UIColor(named: "otKit_ash_darker") ?? .black }
    static var otk_ashLight: UIColor { return UIColor(named: "otKit_ash_light") ?? .black }
    static var otk_ashLighter: UIColor { return UIColor(named: "otKit_ash_lighter") ?? .black }
    static var otk_ashLightest: UIColor { return UIColor(named: "otKit_ash_lightest") ?? .black }
    static var otk_greenLighter: UIColor { return UIColor(named: "otKit_green_lighter") ?? .black }
    static var otk_white_white: UIColor { return UIColor(named: "otKit_white_white") ?? .black }
    static var otk_whiteAsh: UIColor { return UIColor(named: "otKit_white_ash") ?? .black }
    static var otk_whiteAshDark: UIColor { return UIColor(named: "otKit_white_ash_dark") ?? .black }
}
