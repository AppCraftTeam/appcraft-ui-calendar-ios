//
//  ACCalendarMonthModel.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation

/// Model for describing a calendar month.
public struct ACCalendarMonthModel {
    
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
    public var totalDays: [Int] = []
    
    init(month: Int, monthDate: Date, monthDates: [Date], previousMonthDates: [Date], nextMonthDates: [Date], days: [ACCalendarDayModel]) {
        self.month = month
        self.monthDate = monthDate
        self.monthDates = monthDates
        self.previousMonthDates = previousMonthDates
        self.nextMonthDates = nextMonthDates
        self.days = days
    }
}
