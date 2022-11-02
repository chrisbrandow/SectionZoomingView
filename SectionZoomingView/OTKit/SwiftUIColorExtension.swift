//
//  SwiftUIColorExtension.swift
//  OTCommon
//
//  Created by Jack Rubin on 7/21/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import SwiftUI

extension Color {
    /// hex value: 18856b, 1fa888
    public static var aqua: Color { return Color(UIColor(named: "otKit_aqua") ?? .black)}
    /// hex value: 0c4134, 0xeefcf9
    public static var aqua_dark: Color { return Color(UIColor(named: "otKit_aqua_dark") ?? .black)}
    /// hex value: 0x09342a, 0x09342a
    public static var aqua_darker: Color { return Color(UIColor(named: "otKit_aqua_darker") ?? .black)}
    /// hex value: 1fa888, 0x18856b
    public static var aqua_light: Color { return Color(UIColor(named: "otKit_aqua_light") ?? .black)}
    /// hex value: 0xeefcf9, 0x0c4134
    public static var aqua_lightest: Color { return Color(UIColor(named: "otKit_aqua_lightest") ?? .black)}
    /// hex value: 3ddbb6, 3ddbb6
    public static var aqua_lighter: Color { return Color(UIColor(named: "otKit_aqua_lighter") ?? .black)}
    /// hex value: 0x6f737b, 0xd8d9db
    public static var ash: Color { return Color(UIColor(named: "otKit_ash") ?? .black)}
    /// hex value: 0x2d333f, 0xffffff
    public static var ash_dark: Color { return Color(UIColor(named: "otKit_ash_dark") ?? .black)}
    /// hex value: 0x141a26, 0xffffff
    public static var ash_darker: Color { return Color(UIColor(named: "otKit_ash_darker") ?? .black)}
    /// hex value: 0x141a26, 0x141a26
    public static var ash_darker_immutable: Color { return Color(UIColor(named: "otKit_ash_darker_ash_darker") ?? .black)}
    /// hex value: 0x91949a, 0x91949a
    public static var ash_light: Color { return Color(UIColor(named: "otKit_ash_light") ?? .black)}
    /// hex value: 0xd8d9db, 0x6f737b
    public static var ash_lighter: Color { return Color(UIColor(named: "otKit_ash_lighter") ?? .black)}
    /// hex value: 0xd8d9db, 0xd8d9db
    public static var ash_lighter_immutable: Color { return Color(UIColor(named: "otKit_ash_lighter_ash_lighter") ?? .black)}
    /// hex value: 0xf1f2f4, 0x2d333f
    public static var ash_lightest: Color { return Color(UIColor(named: "otKit_ash_lightest") ?? .black)}
    /// hex value: 0xf1f2f4, 0x6f737b
    public static var ash_lightest_ash: Color { return Color(UIColor(named: "otKit_ash_lightest_ash") ?? .black)}
    /// hex value: 0xf1f2f4, 0xf1f2f4
    public static var ash_lightest_immutable: Color { return Color(UIColor(named: "otKit_ash_lightest_ash_lightest") ?? .black)}
    /// hex value: 0xf1f2f4, 0x141A26
    public static var ash_lightest_ash_darker: Color { return Color(UIColor(named: "otKit_ash_lightest_ash_darker") ?? .black)}
    /// hex value: 0x4a6fde, 0x6c8ae4
    public static var otk_blue: Color { return Color(UIColor(named: "otKit_blue") ?? .black)}
    /// hex value: 0x2146b5, 0xeef1fc
    public static var blue_dark: Color { return Color(UIColor(named: "otKit_blue_dark") ?? .black)}
    /// hex value: 0x0d1b45, 0x0d1b45
    public static var blue_darker: Color { return Color(UIColor(named: "otKit_blue_darker") ?? .black)}
    /// hex value: 0x6c8ae4, 0x6c8ae4
    public static var blue_light: Color { return Color(UIColor(named: "otKit_blue_light") ?? .black)}
    /// hex value: 0xb1c1f1, 0xb1c1f1
    public static var blue_lighter: Color { return Color(UIColor(named: "otKit_blue_lighter") ?? .black)}
    /// hex value: 0xeef1fc, 0x2146b5
    public static var blue_lightest: Color { return Color(UIColor(named: "otKit_blue_lightest") ?? .black)}
    /// hex value: 0xd82c82, 0xdf4e96
    public static var fuchsia: Color { return Color(UIColor(named: "otKit_fuchsia") ?? .black)}
    /// hex value: 0x971c59, 0x971c59
    public static var fuchsia_dark: Color { return Color(UIColor(named: "otKit_fuchsia_dark") ?? .black)}
    /// hex value: 0x450d29, 0x450d29
    public static var fuchsia_darker: Color { return Color(UIColor(named: "otKit_fuchsia_darker") ?? .black)}
    /// hex value: 0xdf4e96, 0xdf4e96
    public static var fuchsia_light: Color { return Color(UIColor(named: "otKit_fuchsia_light") ?? .black)}
    /// hex value: 0xfceef5, 0x971c59
    public static var fuchsia_lightest: Color { return Color(UIColor(named: "otKit_fuchsia_lightest") ?? .black)}
    /// hex value: 0xeb93bf, 0xeb93bf
    public static var fuchsia_lighter: Color { return Color(UIColor(named: "otKit_fuchsia_lighter") ?? .black)}
    /// hex value: 0x2f864d, 0x39a25e
    public static var otk_green: Color { return Color(UIColor(named: "otKit_green") ?? .black)}
    /// hex value: 0x194829, 0x64c987
    public static var green_dark: Color { return Color(UIColor(named: "otKit_green_dark") ?? .black)}
    /// hex value: 0x153c23,  0x153c23
    public static var green_darker: Color { return Color(UIColor(named: "otKit_green_darker") ?? .black)}
    /// hex value: 0x39a25e, 0x2f864d
    public static var green_light: Color { return Color(UIColor(named: "otKit_green_light") ?? .black)}
    /// hex value: 0x64c987, 0x64c987
    public static var green_lighter: Color { return Color(UIColor(named: "otKit_green_lighter") ?? .black)}
    /// hex value: 0xf0faf3, 0x194829
    public static var green_lightest: Color { return Color(UIColor(named: "otKit_green_lightest") ?? .black)}
    /// hex value: 0xc84f29, 0xd86441
    public static var otk_orange: Color { return Color(UIColor(named: "otKit_orange") ?? .black)}
    /// hex value: 0x83331b, 0xfcf1ee
    public static var orange_dark: Color { return Color(UIColor(named: "otKit_orange_dark") ?? .black)}
    /// hex value: 0x441a0e, 0x441a0e
    public static var orange_darker: Color { return Color(UIColor(named: "otKit_orange_darker") ?? .black)}
    /// hex value: 0xd86441, 0xd86441
    public static var orange_light: Color { return Color(UIColor(named: "otKit_orange_light") ?? .black)}
    /// hex value: 0xe69b84, 0xe69b84
    public static var orange_lighter: Color { return Color(UIColor(named: "otKit_orange_lighter") ?? .black)}
    /// hex value: 0xfcf1ee, 0x83331b
    public static var orange_lightest: Color { return Color(UIColor(named: "otKit_orange_lightest") ?? .black)}
    /// hex value: 0xad4cc3, 0xbb6acd
    public static var otk_purple: Color { return Color(UIColor(named: "otKit_purple") ?? .black)}
    /// hex value: 0x7c2f8e, 0xf8f0fa
    public static var purple_dark: Color { return Color(UIColor(named: "otKit_purple_dark") ?? .black)}
    /// hex value: 0x36143d, 0x36143d
    public static var purple_darker: Color { return Color(UIColor(named: "otKit_purple_darker") ?? .black)}
    /// hex value: 0xbb6acd, 0xad4cc3
    public static var purple_light: Color { return Color(UIColor(named: "otKit_purple_light") ?? .black)}
    /// hex value: 0xd7a7e2, 0xd7a7e2
    public static var purple_lighter: Color { return Color(UIColor(named: "otKit_purple_lighter") ?? .black)}
    /// hex value: 0xf8f0fa, 0x7c2f8e
    public static var purple_lightest: Color { return Color(UIColor(named: "otKit_purple_lightest") ?? .black)}
    /// hex value: 0xda3743, 0xda3743
    public static var otk_red: Color { return Color(UIColor(named: "otKit_red") ?? .black)}
    /// hex value: 0x931b23, 0xfceeef
    public static var red_dark: Color { return Color(UIColor(named: "otKit_red_dark") ?? .black)}
    /// hex value: 0x450d10, 0x450d10
    public static var red_darker: Color { return Color(UIColor(named: "otKit_red_darker") ?? .black)}
    /// hex value: 0x931b23, 0xfceeef
    public static var red_dark_red_lightest: Color { return Color(UIColor(named: "otKit_red_dark_red_lightest") ?? .black)}
    /// hex value: 0x931b23, 0x931b23
    public static var red_dark_immutable: Color { return Color(UIColor(named: "otKit_red_dark_immutable") ?? .black)}
    /// hex value: 0xe15b64, 0xe15b64
    public static var red_light: Color { return Color(UIColor(named: "otKit_red_light") ?? .black)}
    /// hex value: 0xeea0a5, 0xeea0a5
    public static var red_lighter: Color { return Color(UIColor(named: "otKit_red_lighter") ?? .black)}
    /// hex value: 0xfceeef, 0x931b23
    public static var red_lightest: Color { return Color(UIColor(named: "otKit_red_lightest") ?? .black)}
    /// hex value: 0xfceeef, 0x931b23
    public static var red_lightest_red_dark: Color { return Color(UIColor(named: "otKit_red_lightest_red_dark") ?? .black)}
    /// hex value: 0xfceeef, 0xffffff
    public static var red_white: Color { return Color(UIColor(named: "otKit_red_white") ?? .black)}
    /// hex value: 0x247f9e, 0x2b9abf
    public static var teal: Color { return Color(UIColor(named: "otKit_teal") ?? .black)}
    /// hex value: 0x2b9abf, 0x247f9e
    public static var teal_light: Color { return Color(UIColor(named: "otKit_teal_light") ?? .black)}
    /// hex value: 0x61bddb, 0x61bddb
    public static var teal_lighter: Color { return Color(UIColor(named: "otKit_teal_lighter") ?? .black)}
    /// hex value: 0xeef8fb, 0x0f3643
    public static var teal_lightest: Color { return Color(UIColor(named: "otKit_teal_lightest") ?? .black)}
    /// hex value: 0xeef8fb, 0xeef8fb
    public static var teal_lightest_immutable: Color { return Color(UIColor(named: "otKit_teal_lightest_teal_lightest") ?? .black)}
    /// hex value: 0x154a5b, 0xeef8fb
    public static var teal_dark: Color { return Color(UIColor(named: "otKit_teal_dark") ?? .black)}
    /// hex value: 0x0f3643, 0x0f3643
    public static var teal_darker: Color { return Color(UIColor(named: "otKit_teal_darker") ?? .black)}
    /// hex value: 0x7f5ce8, 0x9d82ed
    public static var violet: Color { return Color(UIColor(named: "otKit_violet") ?? .black)}
    /// hex value: 0x1a0a47, 0x1a0a47
    public static var violet_darker: Color { return Color(UIColor(named: "otKit_violet_darker") ?? .black)}
    /// hex value: 0x4d1fd6, 0xf1edfc
    public static var violet_dark: Color { return Color(UIColor(named: "otKit_violet_dark") ?? .black)}
    /// hex value: 0x9d82ed, 0x7f5ce8
    public static var violet_light: Color { return Color(UIColor(named: "otKit_violet_light") ?? .black)}
    /// hex value: 0xd5c9f7, 0xd5c9f7
    public static var violet_lighter: Color { return Color(UIColor(named: "otKit_violet_lighter") ?? .black)}
    /// hex value: 0xf1edfc, 0x4d1fd6
    public static var violet_lightest: Color { return Color(UIColor(named: "otKit_violet_lightest") ?? .black)}
    /// hex value: 0xffffff, 0x141a26
    public static var otk_white: Color { return Color(UIColor(named: "otKit_white") ?? .black)}
    /// hex value: 0xffffff, 0xffffff
    public static var white_immutable: Color { return Color(UIColor(named: "otKit_white_white") ?? .black)}
    /// hex value: 0xffffff, 0x6f737b
    public static var white_ash: Color { return Color(UIColor(named: "otKit_white_ash") ?? .black)}
    /// hex value: 0xffffff, 0x2d333f
    public static var white_ash_dark: Color { return Color(UIColor(named: "otKit_white_ash_dark") ?? .black)}
    /// hex value: 0xd99502, 0xdfaf08
    public static var otk_yellow: Color { return Color(UIColor(named: "otKit_yellow") ?? .black)}
    /// hex value: 0x885e01, 0xfff8eb
    public static var yellow_dark: Color { return Color(UIColor(named: "otKit_yellow_dark") ?? .black)}
    /// hex value: 0x513701, 0x513701
    public static var yellow_darker: Color { return Color(UIColor(named: "otKit_yellow_darker") ?? .black)}
    /// hex value: 0xfdaf08, 0xfdaf08
    public static var yellow_light: Color { return Color(UIColor(named: "otKit_yellow_light") ?? .black)}
    /// hex value: 0xfdc958, 0xfdc958
    public static var yellow_lighter: Color { return Color(UIColor(named: "otKit_yellow_lighter") ?? .black)}
    /// hex value: 0xfff8eb, 0x885e01
    public static var yellow_lightest: Color { return Color(UIColor(named: "otKit_yellow_lightest") ?? .black)}
}
