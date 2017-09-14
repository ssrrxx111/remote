//
//  SSImageButton.swift
//  stocks-ios
//
//  Created by Eason Lee on 13/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

public enum SSImagePosition {
    case top
    case left
    case bottom
    case right

    case topEdge
    case leftEdge
    case bottomEdge
    case rightEdge
    
    case topOffset
    
    case rightBottom

    case none
}

public class SSImageButton: UIButton {

    public var spacing: CGFloat
    public var position: SSImagePosition
    public var hitTestInset: UIEdgeInsets? = nil

    public init(position: SSImagePosition, spacing: CGFloat) {

        self.position = position
        self.spacing = spacing

        super.init(frame: CGRect.zero)

        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {

        self.position = .left
        self.spacing = 0.0

        super.init(coder: aDecoder)

        self.setup()
    }

    public func setup() {

    }

    override public func layoutSubviews() {

        super.layoutSubviews()

        let labelSize = self.titleLabel!.frame.size
        let imageSize = self.imageView!.frame.size

        let totalWidth = labelSize.width + imageSize.width + spacing
        let totalHeight = labelSize.height + imageSize.height + spacing

        var imageFrame = CGRect.zero
        var labelFrame = CGRect.zero

        switch self.position {
        case .left:
            imageFrame = CGRect(x: self.bounds.width / 2.0 - totalWidth / 2.0,
                                y: self.bounds.height / 2.0 - imageSize.height / 2.0,
                                width: imageSize.width,
                                height: imageSize.height)
            labelFrame = CGRect(x: imageFrame.maxX + spacing,
                                y: self.bounds.height / 2.0 - labelSize.height / 2.0,
                                width: labelSize.width,
                                height: labelSize.height)

        case .right:
            labelFrame = CGRect(x: self.bounds.width / 2.0 - totalWidth / 2.0,
                                y: self.bounds.height / 2.0 - labelSize.height / 2.0,
                                width: labelSize.width,
                                height: labelSize.height)
            imageFrame = CGRect(x: labelFrame.maxX + spacing,
                                y: self.bounds.height / 2.0 - imageSize.height / 2.0,
                                width: imageSize.width,
                                height: imageSize.height)
        case .top:
            imageFrame = CGRect(x: self.bounds.width / 2.0 - imageSize.width / 2.0,
                                y: self.bounds.height / 2.0 - totalHeight / 2.0,
                                width: imageSize.width,
                                height: imageSize.height)
            labelFrame = CGRect(x: 5,
                                y: imageFrame.maxY + spacing,
                                width: self.bounds.width - 10,
                                height: labelSize.height)
        case .bottom:
            labelFrame = CGRect(x: 5,
                                y: self.bounds.height / 2.0 - totalHeight / 2.0,
                                width: self.bounds.width - 10,
                                height: labelSize.height)
            imageFrame = CGRect(x: self.bounds.width / 2.0 - imageSize.width / 2.0,
                                y: labelFrame.maxY + spacing,
                                width: imageSize.width,
                                height: imageSize.height)

        case .leftEdge:
            imageFrame = CGRect(x: 0,
                                y: self.bounds.height / 2.0 - imageSize.height / 2.0,
                                width: imageSize.width,
                                height: imageSize.height)
            labelFrame = CGRect(x: imageSize.width + spacing,
                                y: self.bounds.height / 2.0 - labelSize.height / 2.0,
                                width: labelSize.width,
                                height: labelSize.height)
        case .rightEdge:
            labelFrame = CGRect(x: 0,
                                y: self.bounds.height / 2.0 - labelSize.height / 2.0,
                                width: labelSize.width,
                                height: labelSize.height)
            imageFrame = CGRect(x: labelFrame.maxX + spacing,
                                y: self.bounds.height / 2.0 - imageSize.height / 2.0,
                                width: imageSize.width,
                                height: imageSize.height)
//            labelFrame = CGRect(x: 0,
//                                y: self.bounds.height / 2.0 - labelSize.height / 2.0,
//                                width: labelSize.width,
//                                height: labelSize.height)
//            imageFrame = CGRect(x: self.bounds.width - imageSize.width - spacing,
//                                y: self.bounds.height / 2.0 - imageSize.height / 2.0,
//                                width: imageSize.width,
//                                height: imageSize.height)
        case .topEdge:
            imageFrame = CGRect(x: self.bounds.width / 2.0 - imageSize.width / 2.0,
                                y: 0,
                                width: imageSize.width,
                                height: imageSize.height)
            labelFrame = CGRect(x: 5,
                                y: imageSize.height + spacing,
                                width: self.bounds.width - 10,
                                height: labelSize.height)
        case .bottomEdge:
            labelFrame = CGRect(x: 5,
                                y: self.bounds.height - imageSize.height - labelSize.height - spacing,
                                width: self.bounds.width - 10,
                                height: labelSize.height)
            imageFrame = CGRect(x: self.bounds.width / 2.0 - imageSize.width / 2.0,
                                y: self.bounds.height - imageSize.height,
                                width: imageSize.width,
                                height: imageSize.height)
        case .topOffset:
            imageFrame = CGRect(x: self.bounds.width / 2.0 - imageSize.width / 2.0,
                                y: spacing,
                                width: imageSize.width,
                                height: imageSize.height)
            labelFrame = CGRect(x: 5,
                                y: self.bounds.height - labelSize.height - 2,
                                width: self.bounds.width - 10,
                                height: labelSize.height)
        case .rightBottom:
            labelFrame = CGRect(x: self.bounds.width / 2.0 - totalWidth / 2.0,
                                y: self.bounds.height / 2.0 - labelSize.height / 2.0,
                                width: labelSize.width,
                                height: labelSize.height)
            imageFrame = CGRect(x: labelFrame.maxX,
                                y: self.bounds.height - imageSize.height - spacing,
                                width: imageSize.width,
                                height: imageSize.height)
        default:
            break
        }
        
        self.titleLabel?.frame = labelFrame
        self.imageView?.frame = imageFrame

        // 提升上下的响应范围
        // 组合的价格和涨跌幅顶部似乎未生效。。

    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let inset = self.hitTestInset,
            UIEdgeInsetsInsetRect(self.bounds, inset).contains(point) {
            return self
        }
        
        return super.hitTest(point, with: event)
    }
}

public class SSDoubleImageButton: SSImageButton {

    public let coverImage: UIImageView = UIImageView()

    public override func setup() {
        super.setup()

        self.imageView?.addSubview(self.coverImage)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.coverImage.frame = self.imageView?.bounds ?? CGRect.zero
    }

}
