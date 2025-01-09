//
//  MonthComponents.swift
//  ACUICalendar
//

import Foundation

public struct MonthComponents: Hashable {
    
    public let era: Int
    public let year: Int
    public let month: Int
    
    public var components: DateComponents {
        DateComponents(era: era, year: year, month: month)
    }
    
    public let isGregorian: Bool
    
    public init(era: Int, year: Int, month: Int, isGregorian: Bool) {
        self.era = era
        self.year = year
        self.month = month
        self.isGregorian = isGregorian
    }
}

extension MonthComponents: CustomStringConvertible {
    
    public var description: String {
        "\(String(format: "%04d", year))-\(String(format: "%02d", month))"
    }
}

extension MonthComponents: Comparable {
    
    public static func < (lhs: MonthComponents, rhs: MonthComponents) -> Bool {
        if lhs.era != rhs.era {
            return lhs.era < rhs.era
        }
        
        let lhsCorrectedYear = lhs.isGregorian && lhs.era == 0 ? -lhs.year : lhs.year
        let rhsCorrectedYear = rhs.isGregorian && rhs.era == 0 ? -rhs.year : rhs.year
        
        if lhsCorrectedYear != rhsCorrectedYear {
            return lhsCorrectedYear < rhsCorrectedYear
        }
        
        return lhs.month < rhs.month
    }
}
