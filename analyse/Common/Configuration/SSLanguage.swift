//
//  SSLanguage.swift
//  stocks-ios
//
//  Created by Eason Lee on 09/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public enum SSLanguage: Int, ConfigEnumable {

    case chineseSimplified = 0
    case chineseTraditional = 1
    case english = 2
    case german = 3
    case french = 4
//    case japanese = 5
    case hindi = 6
    case italian = 7
    case spanish = 8
    case portuguese = 9
    case malay = 10
    case indonesian = 11
    case thai = 12
    
    public static var allValues: [SSLanguage] {
        return [
            .chineseSimplified,
            .chineseTraditional,
            .english,
            .german,
            .french,
            //    case japanese = 5
            .hindi,
            .italian,
            .spanish,
            .portuguese,
            .malay,
            .indonesian,
            .thai,
        ]
    }

    public var isChinese: Bool {
        return [.chineseSimplified, .chineseTraditional].contains(self)
    }

    public var locale: Locale {
        switch self {
        case .chineseSimplified:
            return LocaleName.chineseSimplified.locale
        case .chineseTraditional:
            return LocaleName.chineseTraditional.locale
        case .german:
            return LocaleName.german.locale
        case .french:
            return LocaleName.french.locale
//        case .japanese:
//            return LocaleName.japanese.locale
        case .hindi:
            return LocaleName.hindi.locale
        case .italian:
            return LocaleName.italian.locale
        case .spanish:
            return LocaleName.spanish.locale
        case .portuguese:
            return LocaleName.portuguese.locale
        case .malay:
            return LocaleName.malay.locale
        case .indonesian:
            return LocaleName.indonesian.locale
        case .thai:
            return LocaleName.thai.locale
        default:
            return LocaleName.english.locale
        }
    }

    // 新闻时间的本地化。locale变量的chineseSimplified应用在SwiftDate库上似乎有问题。
    public var newsLocale: Locale {
        switch self {
        case .chineseSimplified:
            return Locale(identifier: "zh-Hans-CN")
        case .chineseTraditional:
            return Locale(identifier: "zh-Hant-CN")
        default:
            return locale
        }
    }
    
    public static func matchType(_ value: String) -> SSLanguage? {
        for language in allValues {
            if language.value == value {
                return language
            }
        }
        return nil
    }

    public var value: String {
        switch self {
        case .chineseSimplified:
            return "zh"
        case .chineseTraditional:
            return "zh-hant"
        case .german:
            return "de"
        case .french:
            return "fr"
        case .hindi:
            return "hi"
        case .italian:
            return "it"
        case .spanish:
            return "es"
        case .portuguese:
            return "pt"
        case .malay:
            return "ms"
        case .indonesian:
            return "id"
        case .thai:
            return "th"
        case .english:
            return "en"
        }
    }
    
    // 以当前语言为官方语言的国家
    fileprivate var country: [String] {
        
        switch self {
        case .chineseSimplified:
            return [
                "CN"
            ]
        case .chineseTraditional:
            return [
                "TW",
                "HK",
                "MO",
            ]
        case .german:
            return [
                "DE"
            ]
        case .french:
            return [
                "FR",//法国
                "MC",//摩纳哥
                "CD",//刚果（金）
                "CG",//刚果（布）
                "CI",//科特迪瓦
                "HT",//海地
                "TN",//突尼斯
                "CF",//中非
            ]
        case .hindi:
            return ["IN"]
        case .italian:
            return ["IT"]
        case .spanish:
            return [
                "ES",//西班牙
                "AR",//阿根廷
                "CL",//智利
                "CO",//哥伦比亚
                "CR",//哥斯达黎加
                "CU",//古巴
                "DO",//多米尼加
                "EC",//厄瓜多尔
                "MX",//墨西哥
                "PA",//巴拿马
                "UY",//乌拉圭
            ]
        case .portuguese:
            return [
                "PT",//葡萄牙
                "AO",//安哥拉
                "BR",//巴西
                "MZ",//莫桑比克
            ]
        case .malay:
            return []
        case .indonesian:
            return ["ID"]
        case .thai:
            return ["TH"]
        case .english:
            return []
        }
    }
}

/// Configration enumable protocol
extension SSLanguage {

    public var text: String {
        switch self {
        case .chineseSimplified:
            return i18n("setting.config.language.zh_hans")
        case .chineseTraditional:
            return i18n("setting.config.language.zh_hant")
        case .english:
            return i18n("setting.config.language.en")
        case .german:
            return i18n("setting.config.language.german")
        case .french:
            return i18n("setting.config.language.french")
        case .hindi:
            return i18n("setting.config.language.hindi")
        case .italian:
            return i18n("setting.config.language.italian")
        case .spanish:
            return i18n("setting.config.language.spanish")
        case .portuguese:
            return i18n("setting.config.language.portuguese")
        case .malay:
            return i18n("setting.config.language.malay")
        case .indonesian:
            return i18n("setting.config.language.indonesian")
        case .thai:
            return i18n("setting.config.language.thai")
//        default:
//            return i18n("setting.config.language.en")
        }
    }

    public static var defaultValue: SSLanguage {

        guard let language = Locale.preferredLanguages.first else {
            return .english
            
        }
        
        if language.hasPrefix("zh-Hant") || language.hasPrefix("zh-HK") || language.hasPrefix("zh-TW") {
            return .chineseTraditional
        }
        
        for lan in SSLanguage.allValues {
            if language.hasPrefix(lan.value) {
                return lan
            }
        }

        // 再根据当前地区来判断
        guard let code = Locale.current.regionCode else {
            return .english
        }
        
        for lan in SSLanguage.allValues {
            if lan.country.contains(code) {
                return lan
            }
        }

        return .english
    }

    public static var title: String {
        return i18n("setting.config.language")
    }

    public static var storageKey: ConfigKey {
        return .language
    }

    public var remoteValue: AnyObject {
        return self.value as AnyObject
    }

    public static var key: String {
        return "language"
    }
    
    public var resourceSuffix: String {
        switch self {
        case .chineseSimplified:
            return ".zh_hans"
        case .chineseTraditional:
            return ".zh_hant"
        default:
            return ".en"
        }
    }
}
