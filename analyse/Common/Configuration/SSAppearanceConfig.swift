//
//  SSAppearanceConfig.swift
//  Common
//
//  Created by Eason Lee on 16/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public struct SSAppearanceConfig {

    public static let shared = SSAppearanceConfig()

    private init() {}

    // Theme

    public var theme: SSTheme {
        if let value = config.value(of: .theme) as? Int,
            let type = SSTheme(rawValue: value) {
            return type
        } else {
            config.set(.theme, value: SSTheme.blue.rawValue)
            return .blue
        }
    }

    public var isLight: Bool {
        return theme != .black
    }

    // Color scheme

    public var colorScheme: SSColorScheme {

        if let value = config.value(of: .colorScheme) as? Int,
            let type = SSColorScheme(rawValue: value) {
            return type
        } else {
            var scheme = SSColorScheme.green
            if let regionCode = Locale.current.regionCode {
                if ["CN", "JP", "TW"].contains(regionCode) {
                    scheme = .red
                }
            }
            config.set(.colorScheme, value: scheme.rawValue)
            return scheme
        }
    }

    // Title style

    public var titleStyle: SSTitleStyle {
        if let value = config.value(of: .titleStyle) as? Int,
            let type = SSTitleStyle(rawValue: value) {
            return type
        } else {
            var type = SSTitleStyle.symbol
            if StocksConfig.language == .chineseSimplified || StocksConfig.language == .chineseTraditional {
                type = .name
            }
            config.set(.titleStyle, value: type.rawValue)
            return type
        }
    }
}
