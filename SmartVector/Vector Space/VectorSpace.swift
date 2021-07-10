//
//  VectorLike.swift
//  SmartVector
//
//  Created by Etan Ossip on 7/10/21.
//

import Foundation

public protocol VectorSpace {
    static func +(lhs: Self, rhs: Self) -> Self
    static prefix func -(v: Self) -> Self
}

public extension VectorSpace {
    static func -(lhs: Self, rhs: Self) -> Self { lhs + (-rhs) }
}

public protocol InnerProductSpace : VectorSpace {
    associatedtype Scalar
    
    static func *(lhs: Self, rhs: Self) -> Scalar
}
