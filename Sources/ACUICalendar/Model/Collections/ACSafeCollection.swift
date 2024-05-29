//
//  ACSafeCollection.swift
//
//  Created by Damian on 29.05.2024.
//

import Foundation

public class ACSafeCollection<Value>: CustomDebugStringConvertible {
    
    private var collection = [Value]()
    
    private let queue = DispatchQueue(
        label: "com.safe.collection.\(UUID().uuidString)",
        qos: .utility,
        attributes: .concurrent,
        target: .global()
    )
    
    public init() {}
    
    public subscript(index: Int) -> Value? {
        get {
            self.queue.sync { collection[index] }
        }
        set { queue.async(flags: .barrier) { [weak self] in
            self?.collection[safe: index] = newValue
        }
        }
    }
    
    public var debugDescription: String {
        return collection.debugDescription
    }
    
    public func insert(
        _ newElement: Value,
        at i: Int
    ) {
        queue.async(flags: .barrier) { [weak self] in
            self?.collection.insert(newElement, at: i)
        }
    }
    
    public func append(_ newElement: Value) {
        queue.async(flags: .barrier) { [weak self] in
            self?.collection.append(newElement)
        }
    }
    
    public var original: [Value] {
        self.queue.sync {
            collection
        }
    }
    
    public var first: Value? {
        self.queue.sync {
            collection.first
        }
    }
    
    public var last: Value? {
        self.queue.sync {
            collection.last
        }
    }
    
    public static func + (lhs: ACSafeCollection, rhs: ACSafeCollection) -> [Value] {
        lhs.original + rhs.original
    }
}
