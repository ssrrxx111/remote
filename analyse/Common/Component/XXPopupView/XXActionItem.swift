//
//  XXActionItem.swift
//
//
//  Created by adad184 on 7/12/16.
//  Copyright © 2016 adad184. All rights reserved.
//

import UIKit

public typealias XXActionHandler = ((_ index: Int) -> Void)

public enum XXActionItemStatus: Int {
    case normal
    case highlighted
    case disabled
    case selected
}

public struct XXActionItem {

    public var title: String
    public var action: XXActionHandler?
    public var status: XXActionItemStatus
    public var image: UIImage?
    public var noticeText: String?
    public var mutiSelected: Bool?

    public init(
        title: String = "",
        action: XXActionHandler? = nil,
        status: XXActionItemStatus = .normal,
        image: UIImage? = nil,
        mutiSelected: Bool? = false
    ) {
        self.title = title
        self.status = status
        self.action = action
        self.image = image
        self.mutiSelected = mutiSelected
    }
}
