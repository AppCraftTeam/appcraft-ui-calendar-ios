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
    
    public subscript(index: Int) -> Value? {
        get {
            self.queue.sync { collection[safe: index] }
        }
        set {
            queue.async(flags: .barrier) { [weak self] in
                self?.collection[safe: index] = newValue
            }
        }
    }
    
    public var debugDescription: String {
        return collection.debugDescription
    }
    
    public func insert(_ newElement: Value, at i: Int) {
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
    
    public var count: Int {
        collection.count
    }
    
    
    public static func + (lhs: ACSafeCollection, rhs: ACSafeCollection) -> [Value] {
        lhs.original + rhs.original
    }
    
    public func removeLast(_ counter: Int) {
        print("removeLast counter \(counter), all - \(self.count)")
        self.queue.sync {
            if counter <= collection.count {
                let monthData = Array(collection.suffix(counter)) as? [ACCalendarMonthModel]
                print("removeLast \(monthData?.map({ $0.monthDate }))")
                collection.removeLast(counter)
            } else {
                print("Failed removeLast")
            }
        }
    }
    
    public func removeFirst(_ counter: Int) {
        print("removeFirst counter \(counter)")
        self.queue.sync {
            if counter <= collection.count {
                let monthData = Array(collection.prefix(counter)) as? [ACCalendarMonthModel]
                print("removeFirst \(monthData?.map({ $0.monthDate }))")
                collection.removeFirst(counter)
            } else {
                print("Failed removeFirst")
            }
        }
    }
    
    public func clear() {
        self.queue.sync {
            self.collection = []
        }
    }
}

public enum ScrollType {
    case top, bottom
}

extension ACSafeCollection where Value == ACCalendarMonthModel {
    func forEachVisibleDates(
        scrollType: ScrollType,
        startDate: Date,
        endDate: Date,
        pastMonthCount: Int,
        action: (Int) -> Void
    ) {
        self.queue.sync {
            for (index, month) in self.collection.enumerated() {
                let itemDate = month.monthDate
                var isVisible: Bool {
                    switch scrollType {
                    case .top:
                        //print("itemDate - \(itemDate), startDate - \(startDate), endDate - \(endDate) -> is \(itemDate >= startDate && itemDate <= endDate)")
                        return itemDate >= startDate && itemDate <= endDate //itemDate <= startDate || itemDate >= endDate
                    case .bottom:
                        return itemDate >= startDate && itemDate <= endDate
                    }
                }
                self.collection[index].isVisible = isVisible
                
                if isVisible {
                    print("visible section - \(self.collection[index].monthDate)")
                    action(index)
                }
            }
        }
    }
}
