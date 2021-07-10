//
//  Vector.swift
//  SmartVector
//
//  Created by Etan Ossip on 7/10/21.
//

import Foundation

public struct Vector<T> where T : FloatingPoint {
    private var _array: [T]
    
    public var count: Int {
        _array.count
    }
    
    var elements: [T] {
        _array
    }
    
    init(elements: [T]) { self._array = elements }
    init(elements: T...) { self._array = elements }
}

extension Vector : Sequence {
    public func makeIterator() -> Array<T>.Iterator {
        self._array.makeIterator()
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
            self._array[position]
        } set {
            self._array[position] = newValue
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
