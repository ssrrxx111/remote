//
//  NSObject+Swifty.swift
//  NewUstock
//
//  Created by adad184 on 8/12/16.
//  Copyright © 2016 ustock. All rights reserved.
//

import Foundation

extension SSSwifty where Base: NSObject {

//    @discardableResult
//    public func handleTheme(_ handler: @escaping () -> Void ) -> USSwifty {
//        self.base.usThemeHandler = handler
//
//        return self
//    }
//
//    @discardableResult
//    public func handleColor(_ handler: @escaping () -> Void ) -> USSwifty {
//        self.base.usColorHandler = handler
//
//        return self
//    }
//
//    @discardableResult
//    public func handleI18n(_ handler: @escaping () -> Void ) -> USSwifty {
//        self.base.usI18nHandler = handler
//
//        return self
//    }

    @discardableResult
    public func customize(_ handler: ((_ obj:Base) -> Void)) -> Base {
        handler(self.base)

        return self.base
    }
}

extension SSSwifty where Base: NSObject {

    public static var className: String {
        return "\(Base.self)"
    }

    public var className: String {
        return "\(type(of: self.base))"
    }
}


open class SSClosureWrapper: NSObject {
    public var closure: (() -> Void)?

    public init(_ closure: (() -> Void)?) {
        self.closure = closure
    }
}

//extension NSObject {
//
//    typealias SSThemeUpdateClosure = () -> Void
//    typealias SSColorUpdateClosure = () -> Void
//    typealias SSI18nUpdateClosure = () -> Void
//
//    private struct SSAssociatedKeys {
//        static var themeClosure = "themeClosure"
//        static var colorClosure = "colorClosure"
//        static var i18nClosure = "i18nClosure"
//    }
//
//    var ssThemeHandler: SSThemeUpdateClosure? {
//        get {
//            if let object = objc_getAssociatedObject(self, &SSAssociatedKeys.themeClosure) as? SSClosureWrapper {
//                return object.closure
//            }
//            return nil
//        }
//        set {
//            let object = SSClosureWrapper(newValue)
//            objc_setAssociatedObject(self, &SSAssociatedKeys.themeClosure, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//
//            if newValue != nil {
//                _ = NotificationCenter.default
//                    .rx.notification(USSettingNotifications.AppearenceTheme)
//                    .takeUntil(object.rx.deallocated)
//                    .subscribe(
//                        onNext: { [weak self] (_) in
//
//                            guard let `self` = self else {
//                                return
//                            }
//
//                            self.ssThemeHandler?()
//                        }
//                )
//            }
//
//            newValue?()
//        }
//    }
//
//    var ssColorHandler: SSThemeUpdateClosure? {
//        get {
//            if let object = objc_getAssociatedObject(self, &SSAssociatedKeys.colorClosure) as? SSClosureWrapper {
//                return object.closure
//            }
//            return nil
//        }
//        set {
//            let object = SSClosureWrapper(newValue)
//            objc_setAssociatedObject(self, &USAssociatedKeys.colorClosure, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//
//            if newValue != nil {
//                _ = NotificationCenter.default
//                    .rx.notification( USSettingNotifications.AppearenceColorScheme)
//                    .takeUntil(object.rx.deallocated)
//                    .subscribe(
//                        onNext: { [weak self] (_) in
//
//                            guard let `self` = self else {
//                                return
//                            }
//
//                            self.ssColorHandler?()
//                        }
//                )
//            }
//
//            newValue?()
//        }
//    }
//
//    var ssI18nHandler: SSI18nUpdateClosure? {
//        get {
//            if let object = objc_getAssociatedObject(self, &SSAssociatedKeys.i18nClosure) as? SSClosureWrapper {
//                return object.closure
//            }
//            return nil
//        }
//        set {
//            let object = SSClosureWrapper(newValue)
//            objc_setAssociatedObject(self, &SSAssociatedKeys.i18nClosure, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//
//            if newValue != nil {
//                _ = NotificationCenter.default
//                    .rx.notification( USSettingNotifications.Language)
//                    .takeUntil(object.rx.deallocated)
//                    .takeUntil(self.rx.deallocated)
//                    .subscribe(
//                        onNext: { [weak self] (_) in
//
//                            guard let `self` = self else {
//                                return
//                            }
//                            
//                            self.ssI18nHandler?()
//                        }
//                )
//            }
//
//            newValue?()
//        }
//    }
//}
