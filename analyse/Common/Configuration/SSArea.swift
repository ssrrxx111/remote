//
//  SSArea.swift
//  NewUstock
//
//  Created by adad184 on 8/17/16.
//  Copyright © 2016 ustock. All rights reserved.
//

public enum SSArea: String {
    
    case CN = "CN"
    case HK = "HK"
    case JP = "JP"
    case SG = "SG"
    case IN = "IN"
    case US = "US"
    case CA = "CA"
    case GB = "GB"
    case DE = "DE"
    case DK = "DK"
    case SE = "SE"
    case FI = "FI"
    case IS = "IS"
    case NO = "NO"
    case NL = "NL"
    case BE = "BE"
    case PT = "PT"
    case FR = "FR"
    case ES = "ES"
    case CH = "CH"
    case TW = "TW"
    case AE = "AE"
    case AU = "AU"
    case BR = "BR"
    case IL = "IL"
    case LU = "LU"
    case MX = "MX"
    case SA = "SA"
    case KR = "KR"
    case IT = "IT"
    case EE = "EE"
    case LV = "LV"
    case LT = "LT"
    case ZA = "ZA"
    case unkonw
    
    private static var iconImageMap: [Bool: [String: UIImage]] = [:]
    
    public var color: UIColor {
        var colorInt: Int = 0xA05050
        
        if StocksConfig.appearance.isLight {
            
            switch self {
                
            case .CN:
                colorInt = 0xED6E6E
            case .HK:
                colorInt = 0xB77ADA
            case .JP:
                colorInt = 0xB9AFAF
            case .SG:
                colorInt = 0xDF758E
            case .IN:
                colorInt = 0xB9CC7E
            case .US:
                colorInt = 0x8896DD
            case .CA:
                colorInt = 0xE68357
            case .GB:
                colorInt = 0x9488DD
            case .DE:
                colorInt = 0xE2B13B
            case .DK:
                colorInt = 0xE3788F
            case .SE:
                colorInt = 0x7672D8
            case .FI:
                colorInt = 0x4EB7C0
            case .IS:
                colorInt = 0x9BC966
            case .NO:
                colorInt = 0x5FBC73
            case .NL:
                colorInt = 0xBB6AA6
            case .BE:
                colorInt = 0xACB662
            case .PT:
                colorInt = 0xC9A25F
            case .FR:
                colorInt = 0xCB8759
            case .ES:
                colorInt = 0xBCA95F
            case .CH:
                colorInt = 0xE4AA39
            case .TW:
                colorInt = 0x8B8FDF
            case .AE:
                colorInt = 0x69B597
            case .AU:
                colorInt = 0xA188E8
            case .BR:
                colorInt = 0x74B27E
            case .IL:
                colorInt = 0x8DACDA
            case .LU:
                colorInt = 0x6FAEB5
            case .MX:
                colorInt = 0xE6897A
            case .SA:
                colorInt = 0x8CAB79
            case .KR:
                colorInt = 0x726DE0
            case .IT:
                colorInt = 0x6FB96E
            case .EE:
                colorInt = 0x4E598B
            case .LV:
                colorInt = 0xA54141
            case .LT:
                colorInt = 0xD3C86A
            case .ZA:
                colorInt = 0x5FB38B
            default:
                colorInt = 0xED6E6E
                
            }
        } else {
            
            switch self {
                
            case .CN:
                colorInt = 0xA05050
            case .HK:
                colorInt = 0x7E5F8A
            case .JP:
                colorInt = 0x8B8B8B
            case .SG:
                colorInt = 0x9D475B
            case .IN:
                colorInt = 0x92714B
            case .US:
                colorInt = 0x5F7C8A
            case .CA:
                colorInt = 0x9D5D47
            case .GB:
                colorInt = 0x535C90
            case .DE:
                colorInt = 0x916929
            case .DK:
                colorInt = 0x904C43
            case .SE:
                colorInt = 0x54588A
            case .FI:
                colorInt = 0x4E6A90
            case .IS:
                colorInt = 0x6B844E
            case .NO:
                colorInt = 0x537C5C
            case .NL:
                colorInt = 0x537C72
            case .BE:
                colorInt = 0x777C53
            case .PT:
                colorInt = 0x7C6D53
            case .FR:
                colorInt = 0x814D2A
            case .ES:
                colorInt = 0x815D2A
            case .CH:
                colorInt = 0x7d7743
            case .TW:
                colorInt = 0x434686
            case .AE:
                colorInt = 0x457361
            case .AU:
                colorInt = 0x484386
            case .BR:
                colorInt = 0x477345
            case .IL:
                colorInt = 0x435E86
            case .LU:
                colorInt = 0x497D83
            case .MX:
                colorInt = 0x904343
            case .SA:
                colorInt = 0x567345
            case .KR:
                colorInt = 0x534FAA
            case .IT:
                colorInt = 0x4E883C
            case .EE:
                colorInt = 0x4E598B
            case .LV:
                colorInt = 0xE66868
            case .LT:
                colorInt = 0x948B43
            case .ZA:
                colorInt = 0x3E755B
            default:
                colorInt = 0xA05050
                
            }
        }
        return UIColor(hex: colorInt)
    }
    
    public var imageName: String {
        switch self {
        case .GB:
            return "UK"
        default:
            return self.rawValue
        }
    }
    
    public func image(_ size: CGSize? = CGSize(width: 32, height: 32)) -> UIImage? {
        if let size = size {
            return self.dequeueIconImage()?.ss.resize(size)
        } else {
            return self.dequeueIconImage()
        }
    }
    
    public func icon() -> UIImage? {
        return self.dequeueIconImage()
    }
    
    private func dequeueIconImage() -> UIImage? {
        if let image = SSArea.iconImageMap[StocksConfig.appearance.isLight]?[self.imageName] {
            return image
        }
        let defulatSize = CGSize(width: 32, height: 32)
        let imageLabel = UILabel().ss.customize { (view) in
            view.text = imageName
            view.font = UIFont.boldSystemFont(ofSize: defulatSize.width/2 + 1.5)
            view.textColor = SSColor.c101.color
            view.backgroundColor = self.color
            view.layer.cornerRadius = 4
            view.layer.masksToBounds = true
            view.sizeToFit()
            view.width = defulatSize.width
            view.height = defulatSize.width
            view.textAlignment = .center
            view.top = 16
        }
        guard let image = Utils.screenShot(imageLabel) else {
            return nil
        }
        SSArea.iconImageMap[StocksConfig.appearance.isLight]?[self.imageName] = image
        
        return image
    }
}
