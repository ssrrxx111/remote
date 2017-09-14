//
//  SSColor.swift
//  stocks-ios
//
//  Created by Eason Lee on 03/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

typealias SSColorThemeMap = [Int: UIColor]

public enum SSColor: Int {
    public typealias RawValue = Int

    case c1001  // 按钮和主题蓝色
    case c1002  // 修改按钮
    case c1003  // 删除按钮
    
    case c101   //背景颜色
    case c102   //卡片颜色
    case c103   //底栏
    case c104   //导航栏图标颜色
    case c105   //个股购买弹窗
    case c106   //市场选择关注地区cell背景色
    case c107   //组合选取按钮背景色

    case c201   //涨跌绿色
    case c202   //涨跌红色
    case c203   //涨跌黄色

    case c301   //重要文字
    case c302   //次要文字
    case c303   //重要文字
    case c304   //标红文字

    case c305   //财经日历标题分类
    case c306   //财经日历标题分类
    case c307   //财经日历标题分类
    case c308   //财报图表文字
    case c309   //财报图表文字
    case c310   //资金图表文字
    case c311   //资金图表文字
    case c312   //个股部分灰色文字

    case c401   //主题主色
    case c402   //主题辅色
    case c403   //按钮禁用
    case c404   //分割线
    case c405   //点击高亮
    case c406   //按钮高亮
    case c407   //状态栏主色
    case c408   //状态栏辅色
    case c409   //个人背景主色
    case c410   //个人背景辅色
    case c411   //导航栏标签
    case c412   //导航栏辅色
    case c413   //导航栏分割线
    case c414   //阴影颜色
    case c415   //分割线
    case c416   //分割线
    case c417   //分割线
    case c418   //渐变色块
    case c419
    case c420
    case c421   // 输入框背景色
    case c422   // 按钮disable置灰
    case c423
    case c424
    case c425
    case c426
    case c427
    case c428

    case c501   //走势图主线
    case c502   //走势图阴影
    case c503   //走势图成交量颜色
    case c504   //持仓图十字线颜色
    case c505   //昨收
    case c508   //分割线

    case c601   //财报图表颜色
    case c602   //财报图表颜色
    case c603   //财报图表颜色
    case c604   //资金图表颜色
    case c605   //资金图表颜色
    case c606   //资金图表颜色
    case c607   //资金图表颜色
    case c608   //资金图表颜色
    case c609   //资金图表颜色
    case c610   //资金图表颜色
    case c611   //分析师推荐图表
    case c612   //分析师推荐图表
    case c613   //分析师推荐图表
    case c614   //分析师推荐图表
    case c615   //bidAsk
    case c616   //bidAsk
    case c617   //bidAsk
    case c618   //bidAsk

    case c701   //概况图表颜色
    case c702
    case c703
    case c704
    case c705
    case c706
    case c707
    case c708
    case c709
    case c710
    case c711
    case c712

    case c801
    case c802
    case c803
    case c804

    case c901
    case c902
    case c903
    case c904
    case c905

    case riseText
    case riseArea
    case widgetRiseText // 只需要显示亮色版
    case fallText
    case fallArea
    case widgetFallText // 只需要显示亮色版

    case blue
    case red
    case orange
    case green
    case black

    case none
    case debug

    private static var blueTheme: [Int: UIColor] = {

        var theme = [Int: UIColor]()

        theme[SSColor.c101.rawValue] = UIColor(0xF6F7F8FF)
        theme[SSColor.c102.rawValue] = UIColor(0xFFFFFFFF)
        theme[SSColor.c103.rawValue] = UIColor(0xFFFFFFFF)
        theme[SSColor.c104.rawValue] = UIColor(0xF6F7F8FF)
        theme[SSColor.c105.rawValue] = UIColor(0xFFFFFFFF)
        theme[SSColor.c106.rawValue] = UIColor(0xFFFFFFFF)
        theme[SSColor.c107.rawValue] = UIColor(0xFBFBFBFF)

        theme[SSColor.c201.rawValue] = UIColor(0x2CBB85FF)
        theme[SSColor.c202.rawValue] = UIColor(0xFD4C5FFF)
        theme[SSColor.c203.rawValue] = UIColor(0xFFAE29FF)

        theme[SSColor.c301.rawValue] = UIColor(0x4A4A4AFF)
        theme[SSColor.c302.rawValue] = UIColor(0x9B9B9BFF)
        theme[SSColor.c303.rawValue] = UIColor(0xFFFFFFFF)
        theme[SSColor.c304.rawValue] = UIColor(0x6471FBFF)
        theme[SSColor.c305.rawValue] = UIColor(0xF7A700FF)
        theme[SSColor.c306.rawValue] = UIColor(0x22BC84FF)
        theme[SSColor.c307.rawValue] = UIColor(0xB969FFFF)
        theme[SSColor.c308.rawValue] = UIColor(0x229E5AFF)
        theme[SSColor.c309.rawValue] = UIColor(0x327DC9FF)
        theme[SSColor.c310.rawValue] = UIColor(0xE23B30FF)
        theme[SSColor.c311.rawValue] = UIColor(0x008F68FF)
        theme[SSColor.c312.rawValue] = UIColor(0x787878FF)
        
        theme[SSColor.c401.rawValue] = UIColor(0x6471FBFF)
        theme[SSColor.c402.rawValue] = UIColor(0x6A99FFFF)
        theme[SSColor.c403.rawValue] = UIColor(0xEDEDEDFF)
        theme[SSColor.c404.rawValue] = UIColor(0xEDEEEFFF)
        theme[SSColor.c405.rawValue] = UIColor(0xF3F3F3FF)
        theme[SSColor.c406.rawValue] = UIColor(0x5560D5FF)
        theme[SSColor.c407.rawValue] = theme[SSColor.c401.rawValue]
        theme[SSColor.c408.rawValue] = theme[SSColor.c402.rawValue]
        theme[SSColor.c409.rawValue] = theme[SSColor.c401.rawValue]
        theme[SSColor.c410.rawValue] = theme[SSColor.c402.rawValue]
        theme[SSColor.c411.rawValue] = UIColor(0xFFFFFFFF)
        theme[SSColor.c412.rawValue] = UIColor(0xFFFFFFFF)
        theme[SSColor.c413.rawValue] = UIColor(0)
        theme[SSColor.c414.rawValue] = UIColor(0x000000FF)
        theme[SSColor.c415.rawValue] = UIColor(0xEDEEEFFF)
        theme[SSColor.c416.rawValue] = UIColor(0)
        theme[SSColor.c417.rawValue] = theme[SSColor.c401.rawValue]
        theme[SSColor.c418.rawValue] = theme[SSColor.c407.rawValue]
        theme[SSColor.c419.rawValue] = theme[SSColor.c408.rawValue]
        theme[SSColor.c420.rawValue] = UIColor(0x4A4A4AFF)
        theme[SSColor.c421.rawValue] = UIColor(0xF6F7F8FF)
        theme[SSColor.c422.rawValue] = UIColor(0x9B9B9BFF)
        theme[SSColor.c423.rawValue] = UIColor(0xFBD54EFF)
        theme[SSColor.c424.rawValue] = UIColor(0x71400BFF)
        theme[SSColor.c425.rawValue] = UIColor(0xE38714FF)
        theme[SSColor.c426.rawValue] = UIColor(0xFFF9E9FF)
        theme[SSColor.c427.rawValue] = UIColor(0xFFFFFFFF)
        theme[SSColor.c428.rawValue] = UIColor(0xEDEDEDFF)

        theme[SSColor.c501.rawValue] = UIColor(0x6B99FFFF)
        theme[SSColor.c502.rawValue] = UIColor(0xD2E0FFFF)
        theme[SSColor.c503.rawValue] = UIColor(0xD0DAEEFF)
        theme[SSColor.c504.rawValue] = UIColor(0xD0D4FDFF)
        theme[SSColor.c505.rawValue] = UIColor(0xB2C9FFFF)
        theme[SSColor.c508.rawValue] = UIColor(0xEFEFEFFF)

        theme[SSColor.c601.rawValue] = UIColor(0x3BB481FF)
        theme[SSColor.c602.rawValue] = UIColor(0x66A4E3FF)
        theme[SSColor.c603.rawValue] = UIColor(0xFFA10CFF)
        theme[SSColor.c604.rawValue] = UIColor(0xFF7800FF)
        theme[SSColor.c605.rawValue] = UIColor(0xE23B30FF)
        theme[SSColor.c606.rawValue] = UIColor(0xC13832FF)
        theme[SSColor.c607.rawValue] = UIColor(0x6FB74FFF)
        theme[SSColor.c608.rawValue] = UIColor(0x309F50FF)
        theme[SSColor.c609.rawValue] = UIColor(0x008F68FF)
        theme[SSColor.c610.rawValue] = UIColor(0x00645EFF)
        theme[SSColor.c611.rawValue] = UIColor(0x3BB472FF)
        theme[SSColor.c612.rawValue] = UIColor(0xFFC00CFF)
        theme[SSColor.c613.rawValue] = UIColor(0x7498EBFF)
        theme[SSColor.c614.rawValue] = UIColor(0xBABABAFF)
        theme[SSColor.c615.rawValue] = UIColor(0xFF7171FF)
        theme[SSColor.c616.rawValue] = UIColor(0x3ABEB0FF)
        theme[SSColor.c617.rawValue] = UIColor(0xFFF9F9FF)
        theme[SSColor.c618.rawValue] = UIColor(0xF7FFFFFF)
        
        theme[SSColor.c701.rawValue] = UIColor(0x71AAE3FF)
        theme[SSColor.c702.rawValue] = UIColor(0x66A4E3FF)
        theme[SSColor.c703.rawValue] = UIColor(0x81C9A2FF)
        theme[SSColor.c704.rawValue] = UIColor(0xCEDD37FF)
        theme[SSColor.c705.rawValue] = UIColor(0xDDCE3BFF)
        theme[SSColor.c706.rawValue] = UIColor(0xDC9B39FF)
        theme[SSColor.c707.rawValue] = UIColor(0xDC6C39FF)
        theme[SSColor.c708.rawValue] = UIColor(0xE35F5AFF)
        theme[SSColor.c709.rawValue] = UIColor(0xE35B94FF)
        theme[SSColor.c710.rawValue] = UIColor(0xDA64DBFF)
        theme[SSColor.c711.rawValue] = UIColor(0x6678E3FF)
        theme[SSColor.c712.rawValue] = UIColor(0xE0E0E0FF)
        
        theme[SSColor.c1001.rawValue] = UIColor(0x4FA2F6FF)
        theme[SSColor.c1002.rawValue] = UIColor(0x59BC68FF)
        theme[SSColor.c1003.rawValue] = UIColor(0xFC464BFF)

        theme[SSColor.none.rawValue] = UIColor(0)

        return theme
    }()

    private static var orangeTheme: SSColorThemeMap = {

        var theme = SSColor.blueTheme

        theme[SSColor.c401.rawValue] = UIColor(0xFF5E03FF)
        theme[SSColor.c402.rawValue] = UIColor(0xFE8720FF)
        theme[SSColor.c406.rawValue] = UIColor(0xE55402FF)
        theme[SSColor.c407.rawValue] = UIColor(0xFF5E03FF)
        theme[SSColor.c408.rawValue] = UIColor(0xFE8720FF)
        theme[SSColor.c409.rawValue] = UIColor(0xFF5E03FF)
        theme[SSColor.c410.rawValue] = UIColor(0xFE8720FF)
        theme[SSColor.c417.rawValue] = theme[SSColor.c401.rawValue]
        theme[SSColor.c418.rawValue] = UIColor(0xFF5E03FF)
        theme[SSColor.c419.rawValue] = UIColor(0xFE8720FF)
        
        theme[SSColor.c504.rawValue] = UIColor(0xFFD0B4FF)

        return theme
    }()

    private static var greenTheme: SSColorThemeMap = {

        var theme = SSColor.blueTheme

        theme[SSColor.c401.rawValue] = UIColor(0x00BA6BFF)
        theme[SSColor.c402.rawValue] = UIColor(0x2ED373FF)
        theme[SSColor.c406.rawValue] = UIColor(0x00A760FF)
        theme[SSColor.c407.rawValue] = UIColor(0x00BA6BFF)
        theme[SSColor.c408.rawValue] = UIColor(0x2ED373FF)
        theme[SSColor.c409.rawValue] = UIColor(0x00BA6BFF)
        theme[SSColor.c410.rawValue] = UIColor(0x2ED373FF)
        theme[SSColor.c417.rawValue] = theme[SSColor.c401.rawValue]
        theme[SSColor.c418.rawValue] = UIColor(0x00BA6BFF)
        theme[SSColor.c419.rawValue] = UIColor(0x2ED373FF)
        
        theme[SSColor.c504.rawValue] = UIColor(0xB3EAD2FF)

        return theme
    }()

    private static var redTheme: SSColorThemeMap = {

        var theme = SSColor.blueTheme

        theme[SSColor.c401.rawValue] = UIColor(0xE92E21FF)
        theme[SSColor.c402.rawValue] = UIColor(0xFE5429FF)
        theme[SSColor.c406.rawValue] = UIColor(0xD12A1EFF)
        theme[SSColor.c407.rawValue] = UIColor(0xE92E21FF)
        theme[SSColor.c408.rawValue] = UIColor(0xFE5429FF)
        theme[SSColor.c409.rawValue] = UIColor(0xE92E21FF)
        theme[SSColor.c410.rawValue] = UIColor(0xFE5429FF)
        theme[SSColor.c417.rawValue] = theme[SSColor.c401.rawValue]
        theme[SSColor.c418.rawValue] = UIColor(0xE92E21FF)
        theme[SSColor.c419.rawValue] = UIColor(0xFE5429FF)
        
        theme[SSColor.c504.rawValue] = UIColor(0xF9C1BDFF)

        return theme
    }()

    private static var blackTheme: SSColorThemeMap = {

        var theme = SSColor.blueTheme
        
        theme[SSColor.c101.rawValue] = UIColor(0x111B24FF)
        theme[SSColor.c102.rawValue] = UIColor(0x131D27FF)
        theme[SSColor.c103.rawValue] = UIColor(0x17212AFF)
        theme[SSColor.c104.rawValue] = UIColor(0xDEDDDDFF)
        theme[SSColor.c105.rawValue] = UIColor(0x202E3AFF)
        theme[SSColor.c106.rawValue] = UIColor(0x17212AFF)
        theme[SSColor.c107.rawValue] = UIColor(0x192630FF)

        theme[SSColor.c201.rawValue] = UIColor(0x36D7B7FF)
        theme[SSColor.c202.rawValue] = UIColor(0xFB5154FF)
        theme[SSColor.c203.rawValue] = UIColor(0xFFAE29FF)
        
        theme[SSColor.c301.rawValue] = UIColor(0xDEDDDDFF)
        theme[SSColor.c302.rawValue] = UIColor(0x92979CFF)
        theme[SSColor.c303.rawValue] = UIColor(0xFFFFFFFF)
        theme[SSColor.c304.rawValue] = UIColor(0x608EFFFF)
        
        theme[SSColor.c312.rawValue] = UIColor(0x929292FF)
        
        theme[SSColor.c401.rawValue] = UIColor(0x608EFFFF)
        theme[SSColor.c402.rawValue] = UIColor(0x6A99FFFF)
        theme[SSColor.c403.rawValue] = UIColor(0x242F3AFF)
        theme[SSColor.c404.rawValue] = UIColor(0x1A232DFF)
        theme[SSColor.c405.rawValue] = UIColor(0x1C252DFF)
        theme[SSColor.c406.rawValue] = UIColor(0x5560D5FF)
        theme[SSColor.c407.rawValue] = UIColor(0x17212AFF)
        theme[SSColor.c408.rawValue] = UIColor(0x17212AFF)
        theme[SSColor.c409.rawValue] = UIColor(0x131E28FF)
        theme[SSColor.c410.rawValue] = UIColor(0x131E28FF)
        theme[SSColor.c411.rawValue] = theme[SSColor.c401.rawValue]
        theme[SSColor.c412.rawValue] = theme[SSColor.c401.rawValue]
        theme[SSColor.c413.rawValue] = UIColor(0x131E28FF)
        theme[SSColor.c414.rawValue] = UIColor(0)
        theme[SSColor.c415.rawValue] = UIColor(0xFFFFFFFF)
        theme[SSColor.c416.rawValue] = UIColor(0x353535FF)
        theme[SSColor.c417.rawValue] = UIColor(0x05080BFF)
        theme[SSColor.c418.rawValue] = UIColor(0x687CFFFF)
        theme[SSColor.c419.rawValue] = UIColor(0x62A1FFFF)
        theme[SSColor.c420.rawValue] = UIColor(0x656C71FF)
        theme[SSColor.c421.rawValue] = UIColor(0x1E262FFF)
        theme[SSColor.c422.rawValue] = UIColor(0x3B444CFF)
        theme[SSColor.c423.rawValue] = UIColor(0xCD912EFF)
        theme[SSColor.c424.rawValue] = UIColor(0xFFFFFFFF)
        theme[SSColor.c425.rawValue] = UIColor(0xCD912EFF)
        theme[SSColor.c426.rawValue] = UIColor(0x273948FF)
        theme[SSColor.c427.rawValue] = UIColor(0x1E2C38FF)
        theme[SSColor.c428.rawValue] = UIColor(0x131D27FF)

        theme[SSColor.c501.rawValue] = UIColor(0xEBEBEBFF)
        theme[SSColor.c502.rawValue] = UIColor(0x00000000)
        theme[SSColor.c503.rawValue] = UIColor(0x696969FF)
        theme[SSColor.c505.rawValue] = UIColor(0x353E47FF)
        theme[SSColor.c508.rawValue] = UIColor(0x1D1E20FF)
        
        theme[SSColor.c601.rawValue] = UIColor(0x22AB71FF)
        theme[SSColor.c602.rawValue] = UIColor(0x4896FFFF)
        theme[SSColor.c603.rawValue] = UIColor(0xF49807FF)
        theme[SSColor.c604.rawValue] = UIColor(0xB42E28FF)
        theme[SSColor.c605.rawValue] = UIColor(0xD53126FF)
        theme[SSColor.c606.rawValue] = UIColor(0xFF7800FF)
        theme[SSColor.c607.rawValue] = UIColor(0x005F59FF)
        theme[SSColor.c608.rawValue] = UIColor(0x008560FF)
        theme[SSColor.c609.rawValue] = UIColor(0x189B53FF)
        theme[SSColor.c610.rawValue] = UIColor(0x5CA33CFF)
        theme[SSColor.c611.rawValue] = UIColor(0x00835FFF)
        theme[SSColor.c612.rawValue] = UIColor(0xE4A902FF)
        theme[SSColor.c613.rawValue] = UIColor(0x6288E0FF)
        theme[SSColor.c614.rawValue] = UIColor(0x6A6A6AFF)
        
        theme[SSColor.c615.rawValue] = UIColor(0xAD4646FF)
        theme[SSColor.c616.rawValue] = UIColor(0x198A7EFF)
        theme[SSColor.c617.rawValue] = UIColor(0x25242CFF)
        theme[SSColor.c618.rawValue] = UIColor(0x172B32FF)
        
        theme[SSColor.c702.rawValue] = UIColor(0x5797D9FF)
        theme[SSColor.c703.rawValue] = UIColor(0x70BC93FF)
        theme[SSColor.c704.rawValue] = UIColor(0x9FBD2DFF)
        theme[SSColor.c705.rawValue] = UIColor(0xD1B732FF)
        theme[SSColor.c706.rawValue] = UIColor(0xD48C1FFF)
        theme[SSColor.c707.rawValue] = UIColor(0xD65F29FF)
        theme[SSColor.c708.rawValue] = UIColor(0xD94F4EFF)
        theme[SSColor.c709.rawValue] = UIColor(0xE0487EFF)
        theme[SSColor.c710.rawValue] = UIColor(0xD761D5FF)
        theme[SSColor.c711.rawValue] = UIColor(0x586AD4FF)
        theme[SSColor.c712.rawValue] = UIColor(0x606569FF)
        
        theme[SSColor.c1001.rawValue] = UIColor(0x4FA2F6FF)

        return theme
    }()

    public var color: UIColor {
        get {
            return SSColor.getColor(self)
        }
    }
    
    // 暗色下的
    public var dark: UIColor {
        get {
            return SSColor.getColor(self, theme: SSTheme.black)
        }
    }
    
    // 亮色主题下取特定蓝色主题
    public var light: UIColor {
        get {
            return SSColor.getColor(self, theme: SSTheme.blue)
        }
    }

    public var cgColor: CGColor {
        return self.color.cgColor
    }

    private static func getThemeMap(_ theme: SSTheme) -> SSColorThemeMap {
        switch theme {
        case .blue:
            return SSColor.blueTheme
        case .orange:
            return SSColor.orangeTheme
        case .green:
            return SSColor.greenTheme
        case .red:
            return SSColor.redTheme
        case .black:
            return SSColor.blackTheme
        }
    }

    public static func getColor(_ color: SSColor, theme: SSTheme? = nil) -> UIColor {

        let theme = theme ?? SSAppearanceConfig.shared.theme
        var themeMap = SSColor.getThemeMap(theme)

        switch color {
        case .debug:
            return UIColor.cyan
        case .blue:
            return SSColor.getColor(.c407, theme: .blue)
        case .orange:
            return SSColor.getColor(.c407, theme: .orange)
        case .red:
            return SSColor.getColor(.c407, theme: .red)
        case .green:
            return SSColor.getColor(.c407, theme: .green)
        case .black:
            return SSColor.getColor(.c407, theme: .black)
        case .riseText:
            switch StocksConfig.appearance.colorScheme {
            case .red:
                return SSColor.c202.color
            case .green:
                return SSColor.c201.color
            case .yellow:
                return SSColor.c201.color
            }
        case .widgetRiseText:
            switch StocksConfig.appearance.colorScheme {
            case .red:
                return SSColor.c202.light
            case .green:
                return SSColor.c201.light
            case .yellow:
                return SSColor.c201.light
            }
        case .riseArea:
            switch StocksConfig.appearance.colorScheme {
            case .red:
                return SSColor.c202.color
            case .green:
                return SSColor.c201.color
            case .yellow:
                return SSColor.c201.color
            }
        case .fallText:
            switch StocksConfig.appearance.colorScheme {
            case .red:
                return SSColor.c201.color
            case .green:
                return SSColor.c202.color
            case .yellow:
                return SSColor.c203.color
            }
        case .widgetFallText:
            switch StocksConfig.appearance.colorScheme {
            case .red:
                return SSColor.c201.light
            case .green:
                return SSColor.c202.light
            case .yellow:
                return SSColor.c203.light
            }
        case .fallArea:
            switch StocksConfig.appearance.colorScheme {
            case .red:
                return SSColor.c201.color
            case .green:
                return SSColor.c202.color
            case .yellow:
                return SSColor.c203.color
            }
        default:
            return themeMap[color.rawValue] ?? UIColor.black
        }
    }
}

