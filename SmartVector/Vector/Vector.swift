//
//  Vector.swift
//  SmartVector
//
//  Created by Etan Ossip on 7/10/21.
//

import Foundation

public struct Vector<Scalar> where Scalar : FloatingPoint {
    private(set) public var elements: [Scalar]
    
    public var count: Int {
        elements.count
    }
        
    init(elements: [Scalar]) { self.elements = elements }
    init(elements: Scalar...) { self.elements = elements }
}

extension Vector : Sequence {
    public func makeIterator() -> Array<Scalar>.Iterator {
        self.elements.makeIterator()
    }
    
    public typealias Iterator = Array<Scalar>.Iterator
}

extension Vector : Collection {
    public typealias Index = Int
    public typealias Element = Scalar
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { count }
    
    public func index(after i: Int) -> Int { i + 1 }
        
    public subscript(position: Int) -> Scalar {
        get {
            self.elements[position]
        } set {
            self.elements[position] = newValue
        }
    }
}

extension Vector : InnerProductSpace {
    public static func *(lhs: Scalar, rhs: Vector<Scalar>) -> Vector<Scalar> { Vector(elements: rhs.elements.map { lhs * $0 }) }
    
    public static prefix func -(v: Vector<Scalar>) -> Vector<Scalar> { Vector(elements: v.map(-)) }
    
    public static func *(lhs: Vector<Scalar>, rhs: Vector<Scalar>) -> Scalar {
        guard lhs.count == rhs.count else { fatalError("Cannot add vectors of different lengths") }
        return zip(lhs, rhs).reduce(0) { accumulatingResult, tuple in
            let (x, y) = tuple
            return accumulatingResult + x * y
        }
    }
    
    public static func +(lhs: Vector<Scalar>, rhs: Vector<Scalar>) -> Vector<Scalar> {
        guard lhs.count == rhs.count else { fatalError("Cannot add vectors of different lengths") }
        return Vector(elements:
            zip(lhs, rhs).map { (x, y) in x + y }
        )
    }
}

extension Vector : CustomStringConvertible {
    public var description: String {
        var string = "<"
        for index in indices {
            string += "\(self[index])" + (index == count - 1 ? ">" : ", ")
        }
        return string
    }
}

public extension Vector {
    init(sparseVector v: SparseVector<Scalar>) {
        self.init(elements: v.elements)
    }
}
