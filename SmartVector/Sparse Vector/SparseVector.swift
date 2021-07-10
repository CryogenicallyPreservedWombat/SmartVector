//
//  Vector.swift
//  SmartVector
//
//  Created by Etan Ossip on 7/10/21.
//

import Foundation

public struct SparseVector<T> where T : FloatingPoint {
    private(set) public var dictionary: [Int : T]
    private(set) public var count: Int
    
    var elements: [T] {
        var array = Array(repeating: T.zero, count: count)
        dictionary.forEach { index, value in
            array[index] = value
        }
        return array
    }
    
    init(valueDict: [Int : T], count: Int) {
        self.dictionary = valueDict
        self.count = count
    }
    
    init(elements: [T]) {
        self.dictionary = elements
            .enumerated()
            .filter { _, value in value != 0 }
            .reduce(into: [:]) { runningDictionary, tuple in
                let (index, value) = tuple
                runningDictionary[index] = value
            }
        
        self.count = elements.count
    }
    
    init(elements: T...) { self.init(elements: elements) }
    init(vector v: Vector<T>) { self.init(elements: v.elements) }
}

public struct SparseVectorIterator<T> : IteratorProtocol where T : FloatingPoint {
    public typealias Element = T
    
    let sparseVector: SparseVector<T>
    var index: Int = 0

    mutating public func next() -> T? {
        if index < sparseVector.count {
            defer { index += 1 }
            return sparseVector[index]
        }
        return nil
    }
}

extension SparseVector : Sequence {
    public func makeIterator() -> SparseVectorIterator<T> {
        SparseVectorIterator(sparseVector: self)
    }

    public typealias Iterator = SparseVectorIterator<T>
}

extension SparseVector : Collection {
    public typealias Index = Int
    public typealias Element = T

    public var startIndex: Int { 0 }
    public var endIndex: Int { count }

    public func index(after i: Int) -> Int { i + 1 }

    public subscript(position: Int) -> T {
        get {
            self.dictionary[position] ?? 0
        } set {
            self.dictionary[position] = newValue
        }
    }
}


extension SparseVector : InnerProductSpace {
    public typealias Scalar = T

    public static prefix func -(v: SparseVector<T>) -> SparseVector<T> {
        return SparseVector(valueDict: v.dictionary.mapValues(-), count: v.count)
    }

    public static func * (lhs: SparseVector<T>, rhs: SparseVector<T>) -> T {
        guard lhs.count == rhs.count else { fatalError("Cannot add vectors of different lengths") }
        
        return lhs.dictionary.merged(with: rhs.dictionary, onIntersection: *).reduce(into: 0) { runningSum, tuple in
                let (_, value) = tuple
                runningSum += value
            }
    }

    public static func +(lhs: SparseVector<T>, rhs: SparseVector<T>) -> SparseVector<T> {
        guard lhs.count == rhs.count else { fatalError("Cannot add vectors of different lengths") }
        return SparseVector(valueDict: lhs.dictionary.merged(with: rhs.dictionary, onIntersection: +), count: lhs.count)
    }
}
