//
//  SSBoardNotes.swift
//  Common
//
//  Created by JunrenHuang on 14/3/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardNotes: JSONMappable {

    public let content: String

    public init?(_ json: JSON) {

        guard let content = json["content"] as? String else {
            return nil
        }

        self.content = content

    }
}
