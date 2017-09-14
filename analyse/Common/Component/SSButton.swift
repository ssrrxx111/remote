//
//  SSButton.swift
//  Common
//
//  Created by JunrenHuang on 19/1/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import UIKit

public struct SSButton {

    // navigation bar button
    public static func name(_ name: String) -> UIButton {

        let button = UIButton(type: .custom)
        button.setImage(SSImage.name(name), for: .normal)
        button.sizeToFit()

        return button
    }

    public static func extendedButton(name: String, gap: CGFloat = 8) -> UIButton {
        let button = self.name(name)
        button.contentEdgeInsets = UIEdgeInsets(top: gap, left: gap, bottom: gap, right: gap)
        return button
    }

    public static func backBarButton(
        target: Any?,
        action: Selector,
        event: UIControlEvents = .touchUpInside)
        -> [UIBarButtonItem]
    {
        return customBarButton("nav_back", target: target, action: action)
    }

    public static func backBarButtonWhite(
        target: Any?,
        action: Selector,
        event: UIControlEvents = .touchUpInside)
        -> [UIBarButtonItem]
    {
        return customBarButton("back_white", target: target, action: action)
    }

    public static func spaceBarButton(width: CGFloat = -4) -> UIBarButtonItem {
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = width
        return space
    }

    public static func customBarButton(
        _ name: String,
        target: Any?,
        action: Selector,
        event: UIControlEvents = .touchUpInside)
        -> [UIBarButtonItem]
    {
        let button = SSButton.name(name)
        button.addTarget(target, action: action, for: event)

        let barButton = UIBarButtonItem(customView: button)
        return [spaceBarButton(), barButton]
    }
}
