//
//  Utils.swift
//  SmartVector
//
//  Created by Etan Ossip on 7/10/21.
//

import Foundation

public extension Dictionary {
    func merged(with otherDict: Dictionary<Key, Value>, mergeIntoSelf: Bool = false, onIntersection: (Value, Value) -> Value) -> Dictionary {
        var (base, addendum) = mergeIntoSelf || count > otherDict.count ? (self, otherDict) : (otherDict, self)
        
        for (key, value) in addendum {
            if let baseValue = base[key] {
                base[key] = onIntersection(baseValue, value)
            } else {
                base[key] = value
            }
        }
        
        return base
    }
}
