//
//  SSBoardURLBase.swift
//  Common
//
//  Created by JunrenHuang on 14/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public protocol SSBoardURLBase {
    var title: String { get }
    var subtitle: String { get }
    var url: String { get set }
    var id: Int64 { get set }
    var siteType: Int { get set }
}
