//
//  Item.swift
//  ios-learning
//
//  Created by 彭少林 on 2025/12/8.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
