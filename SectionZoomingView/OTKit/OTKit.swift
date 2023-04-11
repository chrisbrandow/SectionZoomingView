//
//  OTKit.swift
//  OTPhone
//
//  Created by Olivier Larivain on 6/20/19.
//  Copyright © 2019 OpenTable, Inc. All rights reserved.
//

import UIKit

public struct OTKit {

    /// struct representing all OTKit Colors.
    /// NOTE: aliases (such as `darkText` should not be used in this class
    public struct Color {
        /// hex value: 18856b, 1fa888
        public static var aqua: UIColor { return UIColor(named: "otKit_aqua") ?? .black }
        /// hex value: 0c4134, 0xeefcf9
        public static var aqua_dark: UIColor { return UIColor(named: "otKit_aqua_dark") ?? .black }
        /// hex value: 0x09342a, 0x09342a
        public static var aqua_darker: UIColor { return UIColor(named: "otKit_aqua_darker") ?? .black }
        /// hex value: 1fa888, 0x18856b
        public static var aqua_light: UIColor { return UIColor(named: "otKit_aqua_light") ?? .black }
        /// hex value: 0xeefcf9, 0x0c4134
        public static var aqua_lightest: UIColor { return UIColor(named: "otKit_aqua_lightest") ?? .black }
        /// hex value: 3ddbb6, 3ddbb6
        public static var aqua_lighter: UIColor { return UIColor(named: "otKit_aqua_lighter") ?? .black }
        /// hex value: 0x6f737b, 0xd8d9db
        public static var ash: UIColor { return UIColor(named: "otKit_ash") ?? .black }
        /// hex value: 0x2d333f, 0xffffff
        public static var ash_dark: UIColor { return UIColor(named: "otKit_ash_dark") ?? .black }
        /// hex value: 0x141a26, 0xffffff
        public static var ash_darker: UIColor { return UIColor(named: "otKit_ash_darker") ?? .black }
        /// hex value: 0x141a26, 0x141a26
        public static var ash_darker_immutable: UIColor { return UIColor(named: "otKit_ash_darker_ash_darker") ?? .black }
        /// hex value: 0x141a26, 0xe15b64
        public static var ash_darker_red_light: UIColor { return UIColor(named: "otKit_ash_darker_red_light") ?? .black }
        /// hex value: 0x91949a, 0x91949a
        public static var ash_light: UIColor { return UIColor(named: "otKit_ash_light") ?? .black }
        /// hex value: 0xd8d9db, 0x6f737b
        public static var ash_lighter: UIColor { return UIColor(named: "otKit_ash_lighter") ?? .black }
        /// hex value: 0xd8d9db, 0xd8d9db
        public static var ash_lighter_immutable: UIColor { return UIColor(named: "otKit_ash_lighter_ash_lighter") ?? .black }
        /// hex value: 0xf1f2f4, 0x2d333f
        public static var ash_lightest: UIColor { return UIColor(named: "otKit_ash_lightest") ?? .black }
        /// hex value: 0xf1f2f4, 0x6f737b
        public static var ash_lightest_ash: UIColor { return UIColor(named: "otKit_ash_lightest_ash") ?? .black }
        /// hex value: 0xf1f2f4, 0xf1f2f4
        public static var ash_lightest_immutable: UIColor { return UIColor(named: "otKit_ash_lightest_ash_lightest") ?? .black }
        /// hex value: 0xf1f2f4, 0x141A26
        public static var ash_lightest_ash_darker: UIColor { return UIColor(named: "otKit_ash_lightest_ash_darker") ?? .black }
        /// hex value: 0x4a6fde, 0x6c8ae4
        public static var blue: UIColor { return UIColor(named: "otKit_blue") ?? .black }
        /// hex value: 0x2146b5, 0xeef1fc
        public static var blue_dark: UIColor { return UIColor(named: "otKit_blue_dark") ?? .black }
        /// hex value: 0x0d1b45, 0x0d1b45
        public static var blue_darker: UIColor { return UIColor(named: "otKit_blue_darker") ?? .black }
        /// hex value: 0x6c8ae4, 0x6c8ae4
        public static var blue_light: UIColor { return UIColor(named: "otKit_blue_light") ?? .black }
        /// hex value: 0xb1c1f1, 0xb1c1f1
        public static var blue_lighter: UIColor { return UIColor(named: "otKit_blue_lighter") ?? .black }
        /// hex value: 0xeef1fc, 0x2146b5
        public static var blue_lightest: UIColor { return UIColor(named: "otKit_blue_lightest") ?? .black }
        /// hex value: 0xd82c82, 0xdf4e96
        public static var fuchsia: UIColor { return UIColor(named: "otKit_fuchsia") ?? .black }
        /// hex value: 0x971c59, 0x971c59
        public static var fuchsia_dark: UIColor { return UIColor(named: "otKit_fuchsia_dark") ?? .black }
        /// hex value: 0x450d29, 0x450d29
        public static var fuchsia_darker: UIColor { return UIColor(named: "otKit_fuchsia_darker") ?? .black }
        /// hex value: 0xdf4e96, 0xdf4e96
        public static var fuchsia_light: UIColor { return UIColor(named: "otKit_fuchsia_light") ?? .black }
        /// hex value: 0xfceef5, 0x971c59
        public static var fuchsia_lightest: UIColor { return UIColor(named: "otKit_fuchsia_lightest") ?? .black }
        /// hex value: 0xeb93bf, 0xeb93bf
        public static var fuchsia_lighter: UIColor { return UIColor(named: "otKit_fuchsia_lighter") ?? .black }
        /// hex value: 0x2f864d, 0x39a25e
        public static var green: UIColor { return UIColor(named: "otKit_green") ?? .black }
        /// hex value: 0x194829, 0x64c987
        public static var green_dark: UIColor { return UIColor(named: "otKit_green_dark") ?? .black }
        /// hex value: 0x153c23,  0x153c23
        public static var green_darker: UIColor { return UIColor(named: "otKit_green_darker") ?? .black }
        /// hex value: 0x39a25e, 0x2f864d
        public static var green_light: UIColor { return UIColor(named: "otKit_green_light") ?? .black }
        /// hex value: 0x64c987, 0x64c987
        public static var green_lighter: UIColor { return UIColor(named: "otKit_green_lighter") ?? .black }
        /// hex value: 0xf0faf3, 0x194829
        public static var green_lightest: UIColor { return UIColor(named: "otKit_green_lightest") ?? .black }
        /// hex value: 0xc84f29, 0xd86441
        public static var orange: UIColor { return UIColor(named: "otKit_orange") ?? .black }
        /// hex value: 0x83331b, 0xfcf1ee
        public static var orange_dark: UIColor { return UIColor(named: "otKit_orange_dark") ?? .black }
        /// hex value: 0x441a0e, 0x441a0e
        public static var orange_darker: UIColor { return UIColor(named: "otKit_orange_darker") ?? .black }
        /// hex value: 0xd86441, 0xd86441
        public static var orange_light: UIColor { return UIColor(named: "otKit_orange_light") ?? .black }
        /// hex value: 0xe69b84, 0xe69b84
        public static var orange_lighter: UIColor { return UIColor(named: "otKit_orange_lighter") ?? .black }
        /// hex value: 0xfcf1ee, 0x83331b
        public static var orange_lightest: UIColor { return UIColor(named: "otKit_orange_lightest") ?? .black }
        /// hex value: 0xad4cc3, 0xbb6acd
        public static var purple: UIColor { return UIColor(named: "otKit_purple") ?? .black }
        /// hex value: 0x7c2f8e, 0xf8f0fa
        public static var purple_dark: UIColor { return UIColor(named: "otKit_purple_dark") ?? .black }
        /// hex value: 0x36143d, 0x36143d
        public static var purple_darker: UIColor { return UIColor(named: "otKit_purple_darker") ?? .black }
        /// hex value: 0xbb6acd, 0xad4cc3
        public static var purple_light: UIColor { return UIColor(named: "otKit_purple_light") ?? .black }
        /// hex value: 0xd7a7e2, 0xd7a7e2
        public static var purple_lighter: UIColor { return UIColor(named: "otKit_purple_lighter") ?? .black }
        /// hex value: 0xf8f0fa, 0x7c2f8e
        public static var purple_lightest: UIColor { return UIColor(named: "otKit_purple_lightest") ?? .black }
        /// hex value: 0xda3743, 0xda3743
        public static var red: UIColor { return UIColor(named: "otKit_red") ?? .black }
        /// hex value: 0x931b23, 0xfceeef
        public static var red_dark: UIColor { return UIColor(named: "otKit_red_dark") ?? .black }
        /// hex value: 0x450d10, 0x450d10
        public static var red_darker: UIColor { return UIColor(named: "otKit_red_darker") ?? .black }
        /// hex value: 0x931b23, 0xfceeef
        public static var red_dark_red_lightest: UIColor { return UIColor(named: "otKit_red_dark_red_lightest") ?? .black }
        /// hex value: 0x931b23, 0x931b23
        public static var red_dark_immutable: UIColor { return UIColor(named: "otKit_red_dark_immutable") ?? .black }
        /// hex value: 0xe15b64, 0xe15b64 
        public static var red_light: UIColor { return UIColor(named: "otKit_red_light") ?? .black }
        /// hex value: 0xeea0a5, 0xeea0a5
        public static var red_lighter: UIColor { return UIColor(named: "otKit_red_lighter") ?? .black }
        /// hex value: 0xfceeef, 0x931b23
        public static var red_lightest: UIColor { return UIColor(named: "otKit_red_lightest") ?? .black }
        /// hex value: 0xfceeef, 0x931b23
        public static var red_lightest_red_dark: UIColor { return UIColor(named: "otKit_red_lightest_red_dark") ?? .black }
        /// hex value: 0xfceeef, 0xffffff
        public static var red_white: UIColor { return UIColor(named: "otKit_red_white") ?? .black }
        /// hex value: 0x247f9e, 0x2b9abf
        public static var teal: UIColor { return UIColor(named: "otKit_teal") ?? .black }
        /// hex value: 0x2b9abf, 0x247f9e
        public static var teal_light: UIColor { return UIColor(named: "otKit_teal_light") ?? .black }
        /// hex value: 0x61bddb, 0x61bddb
        public static var teal_lighter: UIColor { return UIColor(named: "otKit_teal_lighter") ?? .black }
        /// hex value: 0xeef8fb, 0x0f3643
        public static var teal_lightest: UIColor { return UIColor(named: "otKit_teal_lightest") ?? .black }
        /// hex value: 0xeef8fb, 0xeef8fb
        public static var teal_lightest_immutable: UIColor { return UIColor(named: "otKit_teal_lightest_teal_lightest") ?? .black }
        /// hex value: 0x154a5b, 0xeef8fb
        public static var teal_dark: UIColor { return UIColor(named: "otKit_teal_dark") ?? .black }
        /// hex value: 0x0f3643, 0x0f3643
        public static var teal_darker: UIColor { return UIColor(named: "otKit_teal_darker") ?? .black }
        /// hex value: 0x7f5ce8, 0x9d82ed
        public static var violet: UIColor { return UIColor(named: "otKit_violet") ?? .black }
        /// hex value: 0x1a0a47, 0x1a0a47
        public static var violet_darker: UIColor { return UIColor(named: "otKit_violet_darker") ?? .black }
        /// hex value: 0x4d1fd6, 0xf1edfc
        public static var violet_dark: UIColor { return UIColor(named: "otKit_violet_dark") ?? .black }
        /// hex value: 0x9d82ed, 0x7f5ce8
        public static var violet_light: UIColor { return UIColor(named: "otKit_violet_light") ?? .black }
        /// hex value: 0xd5c9f7, 0xd5c9f7
        public static var violet_lighter: UIColor { return UIColor(named: "otKit_violet_lighter") ?? .black }
        /// hex value: 0xf1edfc, 0x4d1fd6
        public static var violet_lightest: UIColor { return UIColor(named: "otKit_violet_lightest") ?? .black }
        /// hex value: 0xffffff, 0x141a26
        public static var white: UIColor { return UIColor(named: "otKit_white") ?? .black }
        /// hex value: 0xffffff, 0xffffff
        public static var white_immutable: UIColor { return UIColor(named: "otKit_white_white") ?? .black }
        /// hex value: 0xffffff, 0x6f737b
        public static var white_ash: UIColor { return UIColor(named: "otKit_white_ash") ?? .black }
        /// hex value: 0xffffff, 0x2d333f
        public static var white_ash_dark: UIColor { return UIColor(named: "otKit_white_ash_dark") ?? .black }
        /// hex value: 0xd99502, 0xdfaf08
        public static var yellow: UIColor { return UIColor(named: "otKit_yellow") ?? .black }
        /// hex value: 0x885e01, 0xfff8eb
        public static var yellow_dark: UIColor { return UIColor(named: "otKit_yellow_dark") ?? .black }
        /// hex value: 0x513701, 0x513701
        public static var yellow_darker: UIColor { return UIColor(named: "otKit_yellow_darker") ?? .black }
        /// hex value: 0xfdaf08, 0xfdaf08
        public static var yellow_light: UIColor { return UIColor(named: "otKit_yellow_light") ?? .black }
        /// hex value: 0xfdc958, 0xfdc958
        public static var yellow_lighter: UIColor { return UIColor(named: "otKit_yellow_lighter") ?? .black }
        /// hex value: 0xfff8eb, 0x885e01
        public static var yellow_lightest: UIColor { return UIColor(named: "otKit_yellow_lightest") ?? .black }
    }

    /// convenience library for images found in folder `OTKit 24x24 Icons` in `Opentable/Assets.xcassets`
    /// all images must be 24x24 pts
    public struct Icon {
        ///OTKit icon - for `>` symbol
        public static let ic_advance = UIImage(named: "ic_advance")
        ///OTKit image with white checkmark on green circle
        public static let success = UIImage(named: "ic_success")
        ///OTKit image with white x on red circle
        public static let canceled_dining = UIImage(named: "ic_canceled_dining")
        ///OTKit image with vertical fork and knife
        public static let cuisine_light_default = UIImage(named: "ic_cuisine_light_default")
        ///OTKit image with vertical fork and knife, 24x24 red
        public static let cuisine_red = UIImage(named: "ic_cuisine_red_24")
        ///OTKit image with simple calendar, no inner cubes
        public static let ic_clock_red = UIImage(named: "ic_clock_red_24")
        ///OTKit image with simple calendar, no inner cubes
        public static let ic_calendar = UIImage(named: "ic_calendar_light_default")
        ///OTKit image calendar with '+' sign, 24x24 red
        public static let ic_calendar_share_red = UIImage(named: "ic_calendar_share_red_24")
        ///OTKit image for waitlist, looks like a menu, 24x24 red
        public static let waitlist_red = UIImage(named: "ic_description_red_24")
        ///OTKit image with covered dish 24x24 red
        public static let catering_red = UIImage(named: "ic_catering_red")
        ///OTKit image with red reservation card
        public static let ic_reservation_red = UIImage(named: "ic_reservation_red")
        ///OTKit image with sparkly dish 24x24 red
        public static let experiences_red = UIImage(named: "ic_experiences_24_red")
        ///OTKit image with circle with blueish background white bell outlins 24x24
        public static let pending_availability = UIImage(named: "ic_pending_availability")
        ///OTKit image with phone 24x24 red
        public static let phone_red = UIImage(named: "ic_phone_red_24")
        ///OTKit image with lunch sack dish 24x24 ash dark/white
        public static let pickup_ash_dark_white = UIImage(named: "ic_takeout")
        ///OTKit image with lunch sack dish 24x24 red
        public static let pickup_red = UIImage(named: "ic_pickup_red_24")
        ///OTKit image with shield dish 24x24 red
        public static let premium_access_red = UIImage(named: "ic_premium_access_24_red")
        ///OTKit icon - checkmark image for reusable Toast view
        public static let ic_toast_success = UIImage(named: "toast_success")
        ///OTKit icon - bookmark image for filled
        public static let ic_bookmark_selected = UIImage(named: "ic_bookmark_selected")
        ///OTKit icon - bookmark image for filled
        public static let ic_bookmark_unselected = UIImage(named: "ic_bookmark_unselected")
        ///OTKIT icon - diamond for points, 24x24 ashDark/white
        public static let points_diamond = UIImage(named: "ic_points_ash_dark")
        ///OTKIT icon - red diamond for points, 24xq4 red
        public static let points_diamond_red = UIImage(named: "ic_points_red_24")
        ///OTKIT icon - table attributes
        public static let table_categories = UIImage(named: "ic_table_categories")
        ///OTKIT icon - ticket stub, 24x24 red
        public static let ticket_red = UIImage(named: "ticketing-red-icon-24")
        ///OTKIT icon - grocery shopping time attributes
        public static let information = UIImage(named: "ic_information")
        ///OTKIT icon - default share icon, 24x24 red
        public static let share_red = UIImage(named: "ic_share_red_24")
        ///OTKIT icon - location pin icon, 24x24 ashDark, white
        public static let location = UIImage(named: "ic_location")
    }

    public struct Layout {
        /// 4.0
        public static let menuItemMargin: CGFloat = 4.0
        /// 4.0
        public static let xsmallSpacing: CGFloat = 4.0
        /// 8.0
        public static let smallSpacing: CGFloat = 8.0
        /// 12.0
        public static let mediumSmallSpacing: CGFloat = 12.0
        /// 16.0
        public static let mediumSpacing: CGFloat = 16.0
        /// 32.0
        public static let largeSpacing: CGFloat = 32.0
        /// 64.0
        public static let xlargeSpacing: CGFloat = 64.0
        /// 96.0
        public static let xxlargeSpacing: CGFloat = 96.0
        /// 16.0
        public static let borderRadiusLarge: CGFloat = 16.0
        /// 8.0
        public static let borderRadiusMedium: CGFloat = 8.0
        /// 4.0
        public static let borderRadiusSmall: CGFloat = 4.0
        /// 1.0
        public static let borderRadiusHairline: CGFloat = 1.0
        /// 2.0
        public static let borderRadiusXSmall: CGFloat = 2.0
        /// 24.0
        public static let defaultIconEdge: CGFloat = 24.0
        /// 80.0
        public static let iPadSideMargins: CGFloat = 80.0
    }

    public struct Font {
        public static func lineHeight(fontSize: CGFloat) -> CGFloat {
            // This is a placeholder function for an upcoming typography update
            // because Design has specified non-default lineheights

            // TODO: 1) Don't switch on float types. 2) Better default calculation 3) Why don't we have enums for this?
            // Possible solution: https://stackoverflow.com/questions/31656642/lesser-than-or-greater-than-in-swift-switch-statement
            switch fontSize {
            // xsmall-bold/med/reg | font-size: 14px | font-weight: bold/semibold/reg | line-height: 20px
            case 14.0: return 20.0
            // small-bold/med/reg  | font-size: 16px | font-weight: bold/semibold/reg | line-height: 24px
            case 16.0: return 24.0
            // medium-bold         | font-size: 18px | font-weight: bold              | line-height: 24px
            case 18.0: return 24.0
            // large-bold          | font-size: 22px | font-weight: bold              | line-height: 28px
            case 22.0: return 28.0
            // medium-bold         | font-size: 18px | font-weight: bold              | line-height: 24px
            case 24.0: return 32.0
            // xlarge-bold         | font-size: 28px | font-weight: bold              | line-height: 36px
            case 28.0: return 36.0
            // currently a special case for tastemaker
            case 32.0: return 40.0
            // xxlarge-bold        | font-size: 48px | font-weight: bold              | line-height: 56px
            case 48.0: return 56.0
            default: return fontSize < 18 ? 6: 8
            }
        }
        
        public static func lineHeight(for font: UIFont) -> CGFloat {
            switch font.pointSize {
            // xsmall-bold/med/reg | font-size: 14px | font-weight: bold/semibold/reg | line-height: 20px
            case 14.0: return 20.0
            // small-bold/med/reg  | font-size: 16px | font-weight: bold/semibold/reg | line-height: 24px
            case 16.0: return 24.0
            // medium-bold         | font-size: 18px | font-weight: bold              | line-height: 24px
            case 18.0: return 24.0
            // large-bold          | font-size: 22px | font-weight: bold              | line-height: 28px
            case 22.0: return 28.0
            // medium-bold         | font-size: 18px | font-weight: bold              | line-height: 24px
            case 24.0: return 32.0
            // xlarge-bold         | font-size: 28px | font-weight: bold              | line-height: 36px
            case 28.0: return 36.0
            // currently a special case for tastemaker
            case 32.0: return 40.0
            // xxlarge-bold        | font-size: 48px | font-weight: bold              | line-height: 56px
            case 48.0: return 56.0
            default: return font.lineHeight
            }
        }
    }
    
    public struct Border {

        /// ash_lighter, borderWidth = 1.0, radius = 4.0
        public static var ash_lighter_rounded: Border { Border(borderColor: Color.ash_lighter.cgColor) }

        /// ash_lighter, borderWidth = 1.0, radius = 8.0
        public static var ash_lighter_rounded_large: Border { Border(borderColor: Color.ash_lighter.cgColor, cornerRadius: Layout.smallSpacing) }

        /// ash_lighter_immutable, borderWidth = 1.0, radius = 4.0
        public static var ash_lighter_immutable_rounded: Border { Border(borderColor: Color.ash_lighter_immutable.cgColor) }

        /// ash_lightest_immutable, borderWidth = 1.0, radius = 4.0
        public static var ash_lightest_immutable_rounded: Border { Border(borderColor: Color.ash_lightest_immutable.cgColor) }

        /// ash_lightest, borderWidth = 1.0, radius = 8.0
        public static var ash_lightest_rounded_large: Border { Border(borderColor: Color.ash_lightest.cgColor, cornerRadius: Layout.smallSpacing) }

        /// ash_lightest_ash, borderWidth = 1.0, radius = 8.0
        public static var ash_lightest_ash_rounded_large: Border { Border(borderColor: Color.ash_lightest_ash.cgColor, cornerRadius: Layout.smallSpacing) }

        /// appTintColor, borderWidth = 1.0, radius = 4.0
        public static var app_tint_rounded: Border { Border(borderColor: GlobalConfiguration.shared.appTintColor.cgColor) }

        /// appTintColor, borderWidth = 2.0, radius = 4.0
        public static var app_tint_rounded_thick: Border { Border(borderColor: GlobalConfiguration.shared.appTintColor.cgColor, borderWidth: 2.0) }

        /// red_dark_red_lightest, borderWidth = 1.0, radius = 4.0
        public static var red_dark_red_lightest_rounded: Border { Border(borderColor: Color.red_dark_red_lightest.cgColor) }
        
        /// clear, borderWidth = 0.0, radius = 4.0
        public static var corners_only: Border { Border(borderColor: UIColor.clear.cgColor, borderWidth: 0.0) }

        /// clear, borderWidth = 0.0, radius = 8.0
        public static var large_corners_only: Border { Border(borderColor: UIColor.clear.cgColor, borderWidth: 0.0, cornerRadius: Layout.smallSpacing) }

        private(set) var borderColor: CGColor
        private(set) var borderWidth = Layout.borderRadiusHairline
        private(set) var cornerRadius = Layout.borderRadiusSmall

        public init(borderColor: CGColor, borderWidth: CGFloat? = nil, cornerRadius: CGFloat? = nil) {
            self.borderColor = borderColor
            if let width = borderWidth {
                self.borderWidth = width
            }
            if let radius = cornerRadius {
                self.cornerRadius = radius
            }
        }
    }

    public struct Shadow {

        /// .black, offset = {x:0,y:4}, radius = 8.0, opacity = 0.1
        public static var default_black: Shadow { Shadow(color: UIColor.black.cgColor, size: CGSize(width: 0.0, height: 4.0), shadowRadius: 8.0, shadowOpacity: 0.1) }
        /// .black, offset = .zer0, radius = 4.0, opacity = 0.12
        public static var black_15Percent: Shadow { Shadow(color: UIColor.black.cgColor, size: .zero, shadowRadius: 4.0, shadowOpacity: 0.15) }
        /// Typically used for vertical drop shadows below headers, etc. as in rest profile availability view
        /// .black, offset = {x:0,y:4}, radius = 4.0, opacity = 0.10
        public static var xsmall_black: Shadow { Shadow(color: UIColor.black.cgColor, size: CGSize(width: 0.0, height: 4.0), shadowRadius: 4.0, shadowOpacity: 0.1) }
        /// .black, offset = {x:0,y:1}, radius = 4.0, opacity = 0.10
        public static var roundButtonBlack: Shadow { Shadow(color: UIColor.black.cgColor, size: CGSize(width: 0, height: 1), shadowRadius: 4, shadowOpacity: 0.1)}
        public static var none: Shadow { Shadow(color: UIColor.clear.cgColor, size: CGSize(width: 0, height: 0), shadowRadius: 0, shadowOpacity: 0.0) }
        public static var expandableCardView: Shadow { Shadow(color: GlobalConfiguration.shared.shadowColor.cgColor,
                                                                    size: CGSize(width: 0, height: 2.0),
                                                                    shadowRadius: OTKit.Layout.xsmallSpacing,
                                                                    shadowOpacity: 0.5) }

        private(set) var color: CGColor
        private(set) var size: CGSize
        private(set) var shadowRadius: CGFloat
        private(set) var shadowOpacity: Float
    }
}

extension CALayer {
    public func apply(otk_border: OTKit.Border) {
        self.borderColor = otk_border.borderColor
        self.borderWidth = otk_border.borderWidth
        self.cornerRadius = otk_border.cornerRadius
    }

    public func apply(otk_shadow: OTKit.Shadow) {
        self.shadowColor = otk_shadow.color
        self.shadowOffset = otk_shadow.size
        self.shadowRadius = otk_shadow.shadowRadius
        self.shadowOpacity = otk_shadow.shadowOpacity
        self.masksToBounds = false
    }
}

extension CGFloat {
    /// 4.0
    public static let otk_xsmallSpacing: CGFloat = 4.0
    /// 8.0
    public static let otk_smallSpacing: CGFloat = 8.0
    /// 16.0
    public static let otk_mediumSpacing: CGFloat = 16.0
    /// 32.0
    public static let otk_largeSpacing: CGFloat = 32.0
    /// 64.0
    public static let otk_xlargeSpacing: CGFloat = 64.0
    /// 64.0
    public static let otk_xxlargeSpacing: CGFloat = 96.0
    /// 4.0
    public static let otk_borderRadiusSmall: CGFloat = 4.0
    /// 1.0
    public static let otk_borderRadiusHairline: CGFloat = 1.0
}

extension UIColor {
    /// hex value: 0x6f737b, 0xd8d9db
    public static var otk_ash: UIColor { OTKit.Color.ash }
    /// hex value: 0x2d333f, 0xffffff
    public static var otk_ash_dark: UIColor { OTKit.Color.ash_dark }
    /// hex value: 0x141a26, 0xffffff
    public static var otk_ash_darker: UIColor { OTKit.Color.ash_darker }
    /// hex value: 0xd8d9db, 0x6f737b
    public static var otk_ash_lighter: UIColor { OTKit.Color.ash_lighter }
    /// hex value: 0xf1f2f4, 0x2d333f
    public static var otk_ash_lightest: UIColor { OTKit.Color.ash_lightest }
    /// hex value: 0x4a6fde, 0x6c8ae4
    public static var otk_blue: UIColor { OTKit.Color.blue }
    /// hex value: 0x2b9abf, 0x2b9abf
    public static var otk_teal_light: UIColor { OTKit.Color.teal_light }
    /// hex value: 0xffffff, 0x141a26
    public static var otk_white: UIColor { OTKit.Color.white }
    /// hex value: 0xda3743, 0xda3743
    public static var otk_red: UIColor { OTKit.Color.red }
}

extension UIColor {

    public var hexValue: String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
     }
}

public extension NSAttributedString {
    typealias Attribute = [NSAttributedString.Key : Any]

    static func attributedText(withString string: String, boldStrings: [String], font: UIFont, textColor: UIColor, usingOtKitLineHeight: Bool = false, boldDynamicFont: UIFont? = nil) -> NSAttributedString {

        var attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : textColor]
        if usingOtKitLineHeight {
            attributes[NSAttributedString.Key.paragraphStyle] = NSParagraphStyle.otKit_Paragraph(with: font, linebreak: .byTruncatingTail, centered: true)
        }

        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        let boldFontAttribute: [NSAttributedString.Key: Any]
        if let boldDynamicFont = boldDynamicFont {
            boldFontAttribute = [NSAttributedString.Key.font: boldDynamicFont]
        } else {
            boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        }

        for boldString in boldStrings {
            let range = (string as NSString).range(of: boldString)
            attributedString.addAttributes(boldFontAttribute, range: range)
        }
        return attributedString
    }

    var lengthRange: NSRange {
        return NSRange(location: 0,length: self.length)
    }

    var otf_textAttributes: [NSAttributedString.Key: Any] {
        let range = NSRange(location: 0, length: self.length)
        return self.attributes(at: 0, longestEffectiveRange: nil, in: range)
    }
}

public extension NSParagraphStyle {

    static func otKit_Paragraph(with font: UIFont, linebreak: NSLineBreakMode, centered: Bool = false) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = OTKit.Font.lineHeight(for: font)
        paragraphStyle.maximumLineHeight = OTKit.Font.lineHeight(for: font)
        paragraphStyle.lineBreakMode = linebreak
        if centered {
            paragraphStyle.alignment = .center
        }
        return paragraphStyle
    }
}
