//
//  Vector.swift
//  SmartVector
//
//  Created by Etan Ossip on 7/10/21.
//

import Foundation



public struct SparseVector<Scalar> where Scalar : FloatingPoint {
    private(set) public var dictionary: [Int : Scalar]
    private(set) public var count: Int
    
    public var elements: [Scalar] {
        var array = Array(repeating: Scalar.zero, count: count)
        dictionary.forEach { index, value in
            array[index] = value
        }
        return array
    }
    
    init(valueDict: [Int : Scalar], count: Int) {
        self.dictionary = valueDict
        self.count = count
    }
    
    init(elements: [Scalar]) {
        self.dictionary = elements
            .lazy
            .enumerated()
            .filter { _, value in value != 0 }
            .reduce(into: [:]) { runningDictionary, tuple in
                let (index, value) = tuple
                runningDictionary[index] = value
            }
        
        self.count = elements.count
    }
    
    init(elements: Scalar...) { self.init(elements: elements) }
    init(vector v: Vector<Scalar>) { self.init(elements: v.elements) }
}

public struct SparseVectorIterator<Scalar> : IteratorProtocol where Scalar : FloatingPoint {
    public typealias Element = Scalar
    
    let sparseVector: SparseVector<Scalar>
    var index: Int = 0

    mutating public func next() -> Scalar? {
        if index < sparseVector.count {
            defer { index += 1 }
            return sparseVector[index]
        }
        return nil
    }
}

extension SparseVector : Sequence {
    public func makeIterator() -> SparseVectorIterator<Scalar> {
        SparseVectorIterator(sparseVector: self)
    }

    public typealias Iterator = SparseVectorIterator<Scalar>
}

extension SparseVector : Collection {
    public typealias Index = Int
    public typealias Element = Scalar

    public var startIndex: Int { 0 }
    public var endIndex: Int { count }

    public func index(after i: Int) -> Int { i + 1 }

    public subscript(position: Int) -> Scalar {
        get {
            self.dictionary[position] ?? 0
        } set {
            self.dictionary[position] = newValue
        }
    }
}

extension SparseVector : InnerProductSpace {
    public static prefix func -(v: SparseVector<Scalar>) -> SparseVector<Scalar> { SparseVector(valueDict: v.dictionary.mapValues(-), count: v.count) }
    
    public static func +(lhs: SparseVector<Scalar>, rhs: SparseVector<Scalar>) -> SparseVector<Scalar> {
        guard lhs.count == rhs.count else { fatalError("Cannot add vectors of different lengths") }
        return SparseVector(valueDict: lhs.dictionary.merged(with: rhs.dictionary, onIntersection: +), count: lhs.count)
    }
    
    public static func *(lhs: Scalar, rhs: SparseVector<Scalar>) -> SparseVector<Scalar> {
        guard lhs != 0 else { return SparseVector(valueDict: [:], count: rhs.count) }
        return SparseVector(valueDict: rhs.dictionary.mapValues { lhs * $0 }, count: rhs.count)
    }

    public static func *(lhs: SparseVector<Scalar>, rhs: SparseVector<Scalar>) -> Scalar {
        guard lhs.count == rhs.count else { fatalError("Cannot add vectors of different lengths") }
        return lhs.dictionary.merged(with: rhs.dictionary, onIntersection: *).reduce(into: 0) { runningSum, tuple in
            let (_, value) = tuple
            runningSum += value
        }
    }
}
