//
//  UIUtils.swift
//  Common
//
//  Created by adad184 on 10/05/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public struct UIUtils {

    public struct ScreenSize
    {
        public static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        public static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        public static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        public static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }

    public struct DeviceType
    {
        public static let IS_IPHONE            = UIDevice.current.userInterfaceIdiom == .phone
        public static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        public static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        public static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        public static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        public static let IS_IPHONE_7          = IS_IPHONE_6
        public static let IS_IPHONE_7P         = IS_IPHONE_6P
        public static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        public static let IS_IPAD_PRO_9_7      = IS_IPAD
        public static let IS_IPAD_PRO_12_9     = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    }

    public struct Version{
        public static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
        public static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
        public static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
        public static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
        public static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
    }
    
    public static let UIMargin: CGFloat = 8.0
    public static let navbarSpace: CGFloat = -8.0
    public static let seperatorWidth: CGFloat = 1.0 / UIScreen.main.scale
    public static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    public static let screenHeight: CGFloat = UIScreen.main.bounds.size.height

    public static func button(
        target: Any?,
        action: Selector,
        image: String? = nil,
        title: String? = nil,
        color: SSColor? = nil,
        inset: CGFloat? = nil
        ) -> UIButton {

        return UIButton(type: .custom).ss.customize { button in

            let color = color ?? SSColor.c104

            button.ss.themeHandler { (btn) in
                btn.tintColor = color.color
                btn.setTitleColor(color.color, for: .normal)
                btn.setTitleColor(color.color.withAlphaComponent(0.5), for: .highlighted)
                btn.setTitleColor(SSColor.c302.color, for: .disabled)

                if let image = image {
                    btn.setImage(SSImage.name(image)?.ss.tint(color.color), for: .normal)
                    btn.setImage(SSImage.name(image)?.ss.tint(color.color.withAlphaComponent(0.5)), for: .highlighted)
                }
            }
            button.ss.languageHandler { (btn) in
                if let title = title {
                    btn.setTitle(i18n(title), for: .normal)
                }
            }
            button.ss.fontHandler { (button) in
                button.titleLabel?.font = SSFont.t06.bold
            }
            if let inset = inset {
                button.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
            }
            button.addTarget(target, action: action, for: .touchUpInside)

            button.sizeToFit()
        }
    }

    public static func themeButton(
        target: Any? = nil,
        action: Selector? = nil,
        title: String? = nil,
        image: String? = nil,
        isPurchase: Bool = false
        ) -> UIButton {

        return UIButton(type: .custom).ss.customize { button in
            button.ss.themeHandler { (btn) in

                btn.tintColor = SSColor.c303.color
                btn.setTitleColor(SSColor.c303.color, for: .normal)
                btn.setTitleColor(SSColor.c303.color.withAlphaComponent(0.5), for: .highlighted)
                btn.setTitleColor(SSColor.c303.color.withAlphaComponent(0.5), for: .disabled)

                btn.setBackgroundImage(
                    UIImage.ss.image(SSColor.c401.color, size: CGSize(width: 20, height: 20), cornerRadius: 4).ss.stretch(),
                    for: .normal
                )
                btn.setBackgroundImage(
                    UIImage.ss.image(SSColor.c406.color, size: CGSize(width: 20, height: 20), cornerRadius: 4).ss.stretch(),
                    for: .highlighted
                )
                let disableColor = isPurchase ? SSColor.c102.color : SSColor.c422.color
                btn.setBackgroundImage(
                    UIImage.ss.image(disableColor, size: CGSize(width: 20, height: 20), cornerRadius: 4).ss.stretch(),
                    for: .disabled
                )

                if let image = image {
                    btn.setImage(SSImage.name(image)?.ss.tint(SSColor.c303.color), for: .normal)
                    btn.setImage(SSImage.name(image)?.ss.tint(SSColor.c303.color.withAlphaComponent(0.5)), for: .highlighted)
                }
            }
            button.ss.languageHandler { (btn) in
                if let title = title {
                    btn.setTitle(i18n(title), for: .normal)
                }
            }
            button.ss.fontHandler { (button) in
                button.titleLabel?.font = SSFont.t05.bold
            }
            if let target = target,
                let action = action {
                button.addTarget(target, action: action, for: .touchUpInside)
            }
        }
    }
    
    public static func bottomButton(
        target: Any?,
        action: Selector? = nil,
        title: String? = nil,
        image: String? = nil

        ) -> UIButton {
        
        return UIButton(type: .custom).ss.customize { button in
            button.ss.themeHandler { (btn) in
                
                btn.tintColor = SSColor.c401.color
                btn.setTitleColor(SSColor.c401.color, for: .normal)
                btn.imageView?.tintColor = SSColor.c401.color
                btn.setBackgroundImage(
                    UIImage.ss.image(SSColor.c103.color, size: CGSize(width: 20, height: 20)).ss.stretch(),
                    for: .normal
                )
                btn.setBackgroundImage(
                    UIImage.ss.image(SSColor.c405.color, size: CGSize(width: 20, height: 20)).ss.stretch(),
                    for: .highlighted
                )
            }
            if let title = title {
                button.ss.languageHandler { (btn) in
                    btn.setTitle(i18n(title), for: .normal)
                }
                button.ss.fontHandler { (button) in
                    button.titleLabel?.font = SSFont.t05.bold
                }
                button.setImage(UIImage(named: "common.add")?.ss.template(), for: .normal)
                button.setImage(UIImage(named: "common.add")?.ss.template(), for: .highlighted)
            }
            if let image = image {
                button.setImage(UIImage(named: image)?.ss.template(), for: .normal)
                button.setImage(UIImage(named: image)?.ss.template(), for: .highlighted)
            }
            if let target = target,
                let action = action {
                button.addTarget(target, action: action, for: .touchUpInside)
            }
            
            _ = UIView().ss.customize { (view) in
                
                button.addSubview(view)
                view.snp.makeConstraints { (make) in
                    make.left.top.right.equalToSuperview()
                    make.height.equalTo(UIUtils.seperatorWidth)
                }
                
                view.ss.themeHandler({ (view) in
                    view.backgroundColor = SSColor.c413.color
                })
            }

            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
            button.ss.applyShadow(SSShadowType.top)
        }
    }

    public static func barButtonItem(target: Any?, action: Selector, image: String, color: SSColor? = nil) -> UIBarButtonItem {

        return UIBarButtonItem(customView:
            UIUtils.button(
                target: target,
                action: action,
                image: image,
                title: nil,
                color: color
        ))
    }

    public static func barButtonItem(target: Any?, action: Selector, title: String, color: SSColor? = nil) -> UIBarButtonItem {

        return UIBarButtonItem(customView:
            UIUtils.button(
                target: target,
                action: action,
                image: nil,
                title: title,
                color: color
        ))
    }

    public static func fixedSpacer(offset: CGFloat = UIUtils.navbarSpace) -> UIBarButtonItem {

        return UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil).ss.customize { item in
            item.width = offset
        }
    }
    
    public static func navigatinBarBackgroundColor (
        size: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 64),
        from: SSColor = .c407,
        to: SSColor = .c408
        ) -> UIColor {
        
        return UIColor(patternImage: UIUtils.navigatinBarBackgroundImage(size:size, from:from, to: to))
    }
    
    public static func navigatinBarBackgroundImage(
        size: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 64),
        from: SSColor = .c407,
        to: SSColor = .c408
        ) -> UIImage {
        
        return CAGradientLayer(
            frame: CGRect(origin: .zero, size: size),
            colors: [
                from.color,
                to.color
            ]
            ).creatGradientImage() ?? UIImage()
    }
    
    public static func themeGradientLayer(
        size: CGSize = CGSize.zero,
        from: SSColor = .c418,
        to: SSColor = .c419
        ) -> CAGradientLayer {
        
        return CAGradientLayer(
            frame: CGRect(origin: .zero, size: size),
            colors: [
                from.color,
                to.color
            ]
        )
    }
    
    public static func HKEXPromptView(title: String = "market.tab.region.footerView") -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIUtils.screenWidth, height: 50))
        let promptLabel = UILabel()
        promptLabel.numberOfLines = 0
        promptLabel.font = SSFont.t07.bold
        promptLabel.textAlignment = .center
        promptLabel.ss.themeHandler({ (label) in
            label.textColor = SSColor.c302.color
        })
        promptLabel.ss.languageHandler({ (label) in
            label.text = i18n(title)
        })
        view.addSubview(promptLabel)
        promptLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(view)
            make.leading.equalTo(view.snp.leading).offset(8)
            make.trailing.equalTo(view.snp.trailing).offset(-8)
        })
        return view
    }
    
    /// 标的涨跌幅颜色判断逻辑更新，以或的形式判断涨跌颜色
    ///
    /// - Parameters:
    ///   - changeValue: 涨跌额
    ///   - changeRatioValue: 涨跌幅
    ///   - label: 需要变换颜色的label
    ///   - defaultColor: 默认颜色
    
    public static func modifyLabelColor(_ changeValue: Double, changeRatioValue: Double, label: UILabel, defaultColor: UIColor = SSColor.c302.color) {
        
        if changeValue > 0 || changeRatioValue > 0 {
            label.ss.themeHandler { (label) in
                label.textColor = SSColor.riseArea.color
            }
        } else if changeValue < 0 || changeRatioValue < 0 {
            label.ss.themeHandler { (label) in
                label.textColor = SSColor.fallArea.color
            }
        } else {
            label.ss.themeHandler { (label) in
                label.textColor = defaultColor
            }
        }
    }
    
    public static func currencyImage(_ currency: String) -> UIImage? {
        
        var nation: String = ""
        switch currency {
        case "GBP":
            nation = "GB"
        case "EUR":
            nation = "EU"
        case "CAD":
            nation = "CA"
        case "CHF":
            nation = "CH"
        case "CNY":
            nation = "CN"
        case "CNH":
            nation = "CN"
        case "DKK":
            nation = "DK"
        case "HKD":
            nation = "HK"
        case "INR":
            nation = "IN"
        case "ISK":
            nation = "IS"
        case "JPY":
            nation = "JP"
        case "KRW":
            nation = "KR"
        case "NOK":
            nation = "NO"
        case "SEK":
            nation = "SE"
        case "SGD":
            nation = "SG"
        case "USD":
            nation = "US"
        case "AUD":
            nation = "AU"
        default:
            nation = currency
        }
        
        return SSImage.name("region.id.\(nation)")
    }
}

public extension CAGradientLayer {
    
    public convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0.5)
        endPoint = CGPoint(x: 1, y: 0.5)
    }
    
    public func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}
