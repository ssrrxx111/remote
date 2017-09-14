//
//  SSAppearance.swift
//  stocks-ios
//
//  主题 国际化 字体...
//
//  Created by Eason Lee on 04/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

fileprivate enum AppearanceType {
    case appearance, theme, language, font, refresh
}

fileprivate class ValueTypeWrapper<Base: NSObject>: NSObject {

    var value: (Base) -> Void
    weak var base: Base?

    init(_ value: @escaping (Base) -> Void,
         base: Base,
         type: AppearanceType = .appearance) {

        self.value = value
        self.base = base

        super.init()

        var notifications: [Notification.Name]
        switch type {
        case .appearance:
            notifications = [
                ConfigKey.language.notification,
                ConfigKey.colorScheme.notification,
                ConfigKey.theme.notification,
                ConfigKey.fontSize.notification,
                ConfigKey.titleStyle.notification
            ]
        case .language:
            notifications = [
                ConfigKey.language.notification,
                ConfigKey.titleStyle.notification
            ]
        case .theme:
            notifications = [
                ConfigKey.theme.notification,
                ConfigKey.colorScheme.notification
            ]
        case .font:
            notifications = [
                ConfigKey.fontSize.notification
            ]
        case .refresh:
            notifications = [
                ConfigKey.refresh.notification
            ]
        }

        for noti in notifications {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(receivedNoti),
                                                   name: noti,
                                                   object: nil)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func receivedNoti() {
        if let _base = base {
            value(_base)
        }
    }
}

fileprivate struct AppearanceAssociatedKeys {

    static var appearanceKey = "appearanceKey"
    static var fontHandlerKey = "fontHandlerKey"
    static var themeHandlerKey = "themeHandlerKey"
    static var languageHandlerKey = "languageHandlerKey"
    static var refreshHandlerKey = "refreshHandlerKey"
    
}

extension SSSwifty where Base: NSObject {

    /// 视觉相关代码闭包
    /// 多次赋值会覆盖之前的句柄
    /// 第一次赋值 & 收到相关通知 会执行此句柄
    ///
    /// - Parameter handler: 关联句柄
    public func appearance(_ handler: @escaping (Base) -> Void) {
        handler(base)
        let wrapper = ValueTypeWrapper(handler, base: base, type: .appearance)
        objc_setAssociatedObject(base, &AppearanceAssociatedKeys.appearanceKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    public func themeHandler(_ handler: @escaping (Base) -> Void) {
        handler(base)
        let wrapper = ValueTypeWrapper(handler, base: base, type: .theme)
        objc_setAssociatedObject(base, &AppearanceAssociatedKeys.themeHandlerKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    public func languageHandler(_ handler: @escaping (Base) -> Void) {
        handler(base)
        let wrapper = ValueTypeWrapper(handler, base: base, type: .language)
        objc_setAssociatedObject(base, &AppearanceAssociatedKeys.languageHandlerKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    public func fontHandler(_ handler: @escaping (Base) -> Void) {
        handler(base)
        let wrapper = ValueTypeWrapper(handler, base: base, type: .font)
        objc_setAssociatedObject(base, &AppearanceAssociatedKeys.fontHandlerKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    public func refreshHandler(_ handler: @escaping (Base) -> Void) {
        handler(base)
        let wrapper = ValueTypeWrapper(handler, base: base, type: .refresh)
        objc_setAssociatedObject(base, &AppearanceAssociatedKeys.refreshHandlerKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
