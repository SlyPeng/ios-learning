//
//  AnchorKey.swift
//  ios-learning
//
//  Created by 彭少林 on 2025/12/10.
//

import SwiftUI

struct AnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()){ $1 }
    }
}

