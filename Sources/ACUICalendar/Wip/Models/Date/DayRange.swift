//
//  DayRange.swift
//  ACUICalendar
//

import Foundation

public typealias DayRange = ClosedRange<DayComponents>

extension DayRange {
    
    public init(containing dateRange: ClosedRange<Date>, in calendar: Calendar) {
        let lowerBound = calendar.day(containing: dateRange.lowerBound)
        let upperBound = calendar.day(containing: dateRange.upperBound)
        self.init(uncheckedBounds: (lower: lowerBound, upper: upperBound))
    }
}
