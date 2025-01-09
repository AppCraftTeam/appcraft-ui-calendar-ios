//
//  DayComponents.swift
//  ACUICalendar
//

import Foundation

public struct DayComponents: Hashable {
    
    public init(month: MonthComponents, day: Int) {
        self.month = month
        self.day = day
    }
    
    public let month: MonthComponents
    public let day: Int
    
    public var components: DateComponents {
        DateComponents(era: month.era, year: month.year, month: month.month, day: day)
    }
}

extension DayComponents: CustomStringConvertible {
    
    public var description: String {
        let yearDescription = String(format: "%04d", month.year)
        let monthDescription = String(format: "%02d", month.month)
        let dayDescription = String(format: "%02d", day)
        return "\(yearDescription)-\(monthDescription)-\(dayDescription)"
    }
}

extension DayComponents: Comparable {
    
    public static func < (lhs: DayComponents, rhs: DayComponents) -> Bool {
        if lhs.month != rhs.month {
            return lhs.month < rhs.month
        }
        return lhs.day < rhs.day
    }
}
