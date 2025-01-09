//
//  Dictionary+Extension.swift
//  ACUICalendar
//

extension Dictionary {
    
    mutating func value(for key: Key, missingValueProvider: () -> Value) -> Value {
        if let value = self[key] {
            return value
        } else {
            let value = missingValueProvider()
            self[key] = value
            return value
        }
    }
    
    mutating func optionalValue(for key: Key, missingValueProvider: () -> Value?) -> Value? {
        if let value = self[key] {
            return value
        } else {
            let value = missingValueProvider()
            self[key] = value
            return value
        }
    }
}
