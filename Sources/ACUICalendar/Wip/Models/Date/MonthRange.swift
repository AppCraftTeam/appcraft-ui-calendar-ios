//
//  MonthRange.swift
//  ACUICalendar
//

import Foundation

public typealias MonthRange = ClosedRange<MonthComponents>

extension MonthRange {
    
    public init(containing dateRange: ClosedRange<Date>, in calendar: Calendar) {
        self.init(
            uncheckedBounds: (
                lower: calendar.month(containing: dateRange.lowerBound),
                upper: calendar.month(containing: dateRange.upperBound))
        )
    }
}
