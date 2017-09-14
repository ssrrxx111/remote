//
//  NSString+Extensions.swift
//  Common
//
//  Created by Ze乐 on 2017/5/8.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation

extension NSString {
    public func size(for font: UIFont?, size: CGSize, mode: NSLineBreakMode, paragraphStyle: NSMutableParagraphStyle? = nil) -> CGSize {
        let font = font ?? UIFont.systemFont(ofSize: 12)
        var attr = [String: Any]()
        attr[NSFontAttributeName] = font
        if let style = paragraphStyle {
            attr[NSParagraphStyleAttributeName] = style
        }
        if mode != .byWordWrapping {
            if let style = paragraphStyle {
                style.lineBreakMode = mode
                attr[NSParagraphStyleAttributeName] = style
            } else {
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.lineBreakMode = mode
                attr[NSParagraphStyleAttributeName] = paraStyle
            }
        }
        let rect = self.boundingRect(with: size,
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     attributes: attr,
                                     context: nil)
        return rect.size
    }
    
    public func attributeSize(_ size: CGSize, attr: [String: Any]) -> CGSize {
        let rect = self.boundingRect(with: size,
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     attributes: attr,
                                     context: nil)
        return rect.size
    }
}
