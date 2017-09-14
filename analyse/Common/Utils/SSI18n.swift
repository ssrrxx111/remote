//
//  SSI18n.swift
//  stocks-ios
//
//  Created by Eason Lee on 09/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public func i18n(_ identifier: String) -> String {
    return SSI18n.standard.localized(identifier: identifier)
}

public func i18n(_ identifier: [String]) -> [String] {
    return SSI18n.standard.localizedMulti(identifier: identifier)
}

public func i18n(_ identifier: String, arguments: [CVarArg]) -> String {
    return SSI18n.standard.localized(identifier: identifier, arguments: arguments)
}

public func i18nAll(_ identifier: String) -> [String] {
    var allText = [String]()
    for locale in SSLanguage.allValues.map({ $0.locale }) {
        let tool = SSI18n(locale)
        allText.append(tool.localized(identifier: identifier))
    }
    return allText
}

public struct SSI18n {

    static let standard: SSI18n = SSI18n()

    private init() {}

    fileprivate init(_ locale: Locale) {
        self.setupLocale = locale
    }

    fileprivate var setupLocale: Locale?

    internal var locale: Locale {
        if let val = setupLocale {
            return val
        } else {
            return StocksConfig.language.locale
        }
    }

    private func localizedResourceBundle() -> Bundle? {

        let localeID = locale.collatorIdentifier
        guard let innerLanguagePath = Bundle.main.path(forResource: localeID, ofType: "lproj") else {
            return defaultBundle
        }
        return Bundle(path: innerLanguagePath)
    }

    internal func localized(identifier: String, arguments: [CVarArg]) -> String {

        guard
            let bundle = localizedResourceBundle(),
            let defaultBundle = defaultBundle
            else { return "" }


        var localized_str = NSLocalizedString(identifier, bundle: bundle, comment: "")
        if localized_str == identifier {
            let default_str = NSLocalizedString(identifier, bundle: defaultBundle, comment: "")
            return String(format: default_str, arguments: arguments)
        } else {
            localized_str = String(format: localized_str, arguments: arguments)
            return localized_str
        }
    }

    internal func localized(identifier: String) -> String {
        guard
            let bundle = localizedResourceBundle(),
            let defaultBundle = defaultBundle
            else { return "" }

        let localized_str = NSLocalizedString(identifier, bundle: bundle, comment: "")
        if localized_str == identifier {
            let default_str = NSLocalizedString(identifier, bundle: defaultBundle, comment: "")
            return default_str
        } else {
            return localized_str
        }
    }

    internal func localizedMulti(identifier: [String]) -> [String] {
        return localizedMulti(identifier: identifier, arguments: [])
    }

    internal func localizedMulti(identifier: [String], arguments: CVarArg...) -> [String] {

        guard
            let bundle = localizedResourceBundle(),
            let defaultBundle = defaultBundle
            else { return [] }

        var ret = [String]()
        for id in identifier {
            let localized_str = NSLocalizedString(id, bundle: bundle, comment: "")
            if localized_str == id {
                let default_str = NSLocalizedString(id, bundle: defaultBundle, comment: "")
                ret.append(String(format: default_str, arguments: arguments))
            } else {
                ret.append(String(format: localized_str, arguments: arguments))
            }
        }
        return ret
    }

    // MARK: - Default Value

    private var defaultBundle: Bundle? {
        return nil
    }

}
