//
//  VectorLike.swift
//  SmartVector
//
//  Created by Etan Ossip on 7/10/21.
//

import Foundation

public protocol VectorSpace {
    associatedtype Scalar : FloatingPoint

    static prefix func -(v: Self) -> Self
    
    static func +(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Scalar, rhs: Self) -> Self
}

public extension VectorSpace {
    static func -(lhs: Self, rhs: Self) -> Self { lhs + (-rhs) }
    static func *(lhs: Self, rhs: Scalar) -> Self { rhs * lhs }
}

public protocol InnerProductSpace : VectorSpace {
    static func *(lhs: Self, rhs: Self) -> Scalar
}
