//
//  Vector.swift
//  SmartVector
//
//  Created by Etan Ossip on 7/10/21.
//

import Foundation

public struct Vector<T> where T : FloatingPoint {
    private(set) public var elements: [T]
    
    public var count: Int {
        elements.count
    }
        
    init(elements: [T]) { self.elements = elements }
    init(elements: T...) { self.elements = elements }
}

extension Vector : Sequence {
    public func makeIterator() -> Array<T>.Iterator {
        self.elements.makeIterator()
    }
    
    public typealias Iterator = Array<T>.Iterator
}

extension Vector : Collection {
    public typealias Index = Int
    public typealias Element = T
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { count }
    
    public func index(after i: Int) -> Int { i + 1 }
        
    public subscript(position: Int) -> T {
        get {
            self.elements[position]
        } set {
            self.elements[position] = newValue
        }
    }
}

extension Vector : InnerProductSpace {
    public typealias Scalar = T
    
    public static prefix func -(v: Vector<T>) -> Vector<T> { Vector(elements: v.map(-)) }
    
    public static func * (lhs: Vector<T>, rhs: Vector<T>) -> T {
        guard lhs.count == rhs.count else { fatalError("Cannot add vectors of different lengths") }
        return zip(lhs, rhs).reduce(0) { accumulatingResult, tuple in
            let (x, y) = tuple
            return accumulatingResult + x * y
        }
    }
    
    public static func + (lhs: Vector<T>, rhs: Vector<T>) -> Vector<T> {
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
    init(sparseVector v: SparseVector<T>) {
        self.init(elements: v.elements)
    }
}
