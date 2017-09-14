//
//  NSMutableAttributedString+Extension.swift
//  FMBase
//
//  Created by webull on 2017/6/2.
//  Copyright © 2017年 fumi. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    public func addLink(_ source: String, link: String, attributes: [String : Any]? = nil) {
        let linkString = NSMutableAttributedString(string: source, attributes: attributes)
        let range: NSRange = NSRange(location: 0, length: linkString.length)
        linkString.beginEditing()
        linkString.addAttribute(NSLinkAttributeName, value: link, range: range)
        linkString.endEditing()
        self.append(linkString)
    }
    
    public func append(_ string: String, attributes: [String : Any]? = nil) {
        let attrString = NSAttributedString(string: string, attributes: attributes)
        self.append(attrString)
    }
}
