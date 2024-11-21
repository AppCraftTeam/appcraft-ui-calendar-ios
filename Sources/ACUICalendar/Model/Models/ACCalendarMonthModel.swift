//
//  ACCalendarMonthModel.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation

/// Model for describing a calendar month.
public struct ACCalendarMonthModel: Hashable {
    
    /// Month number
    public let month: Int
    
    /// First date in the month.
    public let monthDate: Date
    
    /// Dates of the month.
    public let monthDates: [Date]
    
    /// The dates of the previous month of the first week of the current month, if the current month does not start at the beginning of the week.
    public let previousMonthDates: [Date]
    
    /// The dates of the next month of the last week of the current month, if the current month ends on the last day of the week.
    public let nextMonthDates: [Date]
    
    /// All calendar days of the month.
    public let days: [ACCalendarDayModel]
    
    public var isVisible = true

    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(monthDate)
    }
}
