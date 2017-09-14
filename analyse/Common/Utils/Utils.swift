//
//  Utils.swift
//  Common
//
//  Created by JunrenHuang on 6/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import UIKit
import CoreFoundation
import CoreTelephony

private let kPasswordPrefix = "wl_app-a&b@!423^"

public class Utils {

    public static var currentLocale: String {
        return ((Locale.current as NSLocale).object(forKey: NSLocale.Key.identifier) as? String) ?? "en_US"
    }

    public static var currentCurrencyCode: String {
        return ((Locale.current as NSLocale).object(forKey: NSLocale.Key.currencyCode) as? String) ?? "CNY"
    }

    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }

    public static var phoneType: String {
        return UIDevice.current.modelName
    }

    public static var timeZone: String {
        return TimeZone.autoupdatingCurrent.identifier
    }

    public static var appVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    public static var version: String {
        guard
            let dict = Bundle.main.infoDictionary,
            let version = dict["CFBundleShortVersionString"] as? String,
            let build = dict["CFBundleVersion"] as? String
            else {
                return ""
        }

        return "\(version)(\(build))"
    }
    
    public static func urlParameter() -> String {
        
        return "theme=\(StocksConfig.appearance.theme == .black ? "2" : "1")&color=\(StocksConfig.appearance.colorScheme.rawValue)&hl=\(StocksConfig.language.value)"
    }

    public static func mongoObjectID() -> String {

        var date = Int32(Date().timeIntervalSince1970).bigEndian
        let buffer1 = UnsafeBufferPointer(start: &date, count: 1)
        let s1 = Data(buffer: buffer1).map { String(format: "%02hhx", $0) }.joined()

        let uuid = UUID().uuidString
        var uuidHash = uuid.hashValue.bigEndian
        let buffer2 = UnsafeBufferPointer(start: &uuidHash, count: 1)
        let s2 = Data(buffer: buffer2)[0..<3].map { String(format: "%02hhx", $0) }.joined()

        var pid = UInt32(ProcessInfo.processInfo.processIdentifier).bigEndian
        let buffer3 = UnsafeBufferPointer(start: &pid, count: 1)
        let s3 = Data(buffer: buffer3)[0..<2].map { String(format: "%02hhx", $0) }.joined()

        var random2 = arc4random().bigEndian
        let buffer4 = UnsafeBufferPointer(start: &random2, count: 1)
        let s4 = Data(buffer: buffer4)[0..<3].map { String(format: "%02hhx", $0) }.joined()
        
        return s1 + s2 + s3 + s4
    }

    /// 是否处于大中华地区
    public static func isGreaterChina() -> Bool {

        if let region = Locale.current.regionCode {
            // 中国 台湾 香港 澳门 新加坡
            let regions = ["CN", "TW", "HK", "MO", "SG"]
            return regions.contains(region)
        } else {
            return false
        }
    }

    public static func findExchangeRate(_ sourceSymbol: String, destinationSymbol: String) -> Double? {
        
        return nil
    }

    public static func findShadowImage(under view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1 {
            return (view as? UIImageView)
        }

        for subview in view.subviews {
            if let imageView = findShadowImage(under: subview) {
                return imageView
            }
        }
        return nil
    }
    
    /// MD5
    public static func password(_ string: String) -> String? {
        let new = kPasswordPrefix + string
        return new.md5()
    }
    
    /// 获取设备uuid，删除应用会重置
    public static func getDeviceUUID() -> String {
        return SSUUID.uuidForDevice()
    }
    
    public static var isChinese: Bool = false
    
    public static var splitWidth = 1.0 / UIScreen.main.scale
    public static var screenWidth = UIScreen.main.bounds.size.width
    public static var screenHeight = UIScreen.main.bounds.size.height
    
    public static var statusHeight = UIApplication.shared.statusBarFrame.size.height
    
    public static func getMNCAndMCC() -> (String, String) {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrieInfo = networkInfo.subscriberCellularProvider
        let MNC = carrieInfo?.mobileNetworkCode ?? "-1"
        let MCC = carrieInfo?.mobileCountryCode ?? "-1"
        return (MNC, MCC)
    }
    
    public static var barFixedSpace: UIBarButtonItem {
        let space: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = -14.0
        
        return space
    }
    
    public static func makeBarButtonItems(_ items: [UIBarButtonItem], adjust: CGFloat = 0) -> [UIBarButtonItem] {
        
        let space = self.barFixedSpace
        space.width = space.width + adjust
        var array = [space]
        array.append(contentsOf: items)
        
        return array
    }
    
    public static func makeBarIconButton(image: UIImage?, target: AnyObject?, action: Selector, width: CGFloat = 38.0, height: CGFloat = 44.0, tintColor: SSColor = SSColor.c303) -> UIBarButtonItem {
        let button = UIButton(type: UIButtonType.system).ss.customize { (view) in
            
            view.setImage(image, for: .normal)
            view.titleLabel?.font = SSFont.t05.font
            view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            view.addTarget(target, action: action, for: .touchUpInside)
            
            view.ss.themeHandler({ (view) in
                view.tintColor = tintColor.color
            })
        }
        
        return UIBarButtonItem(customView: button)
    }
    
    public static func makeBarIconButton(title: String?, target: AnyObject?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: UIButtonType.system).ss.customize { (view) in
            
            view.setTitle(title, for: .normal)
            view.titleLabel?.font = SSFont.t05.font
            view.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
            view.addTarget(target, action: action, for: .touchUpInside)
            
            view.ss.themeHandler({ (view) in
                
                view.setTitleColor(SSColor.c503.color, for: .normal)
                view.setTitleColor(SSColor.c302.color, for: .disabled)
            })
        }
        
        return UIBarButtonItem(customView: button)
    }
    
    public static func makeBarIconButton(view: UIView) -> UIBarButtonItem {
        
        return UIBarButtonItem(customView: view)
    }
    
    public static func hideKeyboard() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }

    /// iOS截图，使用WKWebView截图会有问题
    ///
    /// - Parameter view: 显示图片View
    /// - Returns: 截取图片
    public static func screenShot(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        view.layer.render(in: context)
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capturedImage
    }
    
    /// 截取图片到指定大小
    public static func removeImageBorder(_ image: UIImage) -> UIImage? {
        let rectWidth = (image.size.width - 2) * image.scale
        let rectHeight = (image.size.height - 8) * image.scale
        guard let imageRef = image.cgImage?.cropping(to: CGRect(x: 1 * image.scale, y: 1 * image.scale, width: rectWidth, height: rectHeight)) else {
            return nil
        }
        let newImage = UIImage(cgImage: imageRef)
        return newImage
    }
    
    /// 获取时分秒 10000  -> 1小时20分30秒
    public static func getSecondDescription(second: Int) -> String {
        let lock = second
        let s = lock % 60
        let m = (lock - s) / 60
        //        let m = (lock - s) / 60 % 60;
        //        let h = ((lock - s) / 60 - m) / 60 % 24;
        var timeString = ""
        // 1分钟以下显示秒
        if m <= 0 {
            timeString = "\(s)\(i18n("setting.config.security.lock.time.sec"))"
        } else {
            timeString = "\(m)\(i18n("setting.config.security.lock.time.min")) \(s)\(i18n("setting.config.security.lock.time.sec"))"
        }
        return timeString
    }
    
    static public func convertStringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String: Any]
            } catch let error as NSError {
                SSLog(error)
            }
        }
        return nil
    }
    
    static public func convertDictionaryToString(dict:[String: Any]) -> String {
        var result:String = ""
        do {
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
    /// 根据币种名称 usd获取对应的币种符号
    ///
    /// - Parameter code: 币种名称  - usd
    /// - Returns: 币种符号 - $
    static public func getSymbolForCurrencyCode(code: String) -> String? {
        return (SSLanguage.english.locale as NSLocale).displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
    
}

public extension UIDevice {

    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPod5,1": return "iPod Touch 5"
        case "iPod7,1": return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1": return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2": return "iPhone 5"
        case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone8,4": return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
        case "iPad5,1", "iPad5,2": return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": return "iPad Pro"
        case "AppleTV5,3": return "Apple TV"
        case "i386", "x86_64": return "Simulator"
        default: return identifier
        }
    }

    static var isPad: Bool {
        return current.userInterfaceIdiom == .pad
    }

    static var isPhone: Bool {
        return current.userInterfaceIdiom == .phone
    }

}
