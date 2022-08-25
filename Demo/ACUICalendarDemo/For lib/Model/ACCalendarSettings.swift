//
//  ACCalendarSettings.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation

public struct ACCalendarSettings {
    
    // MARK: - Init
    public init(
        calendar: Calendar,
        minDate: Date,
        maxDate: Date,
        currentDate: Date
    ) {
        self.calendar = calendar
        self.minDate = minDate
        self.maxDate = maxDate
        self.currentDate = currentDate
    }
    
    static func `default`() -> Self {
        let calendar = Calendar.defaultACCalendar()
        let currentDate = Date()
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate) ?? currentDate
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate) ?? currentDate
        
        return .init(calendar: calendar, minDate: minDate, maxDate: maxDate, currentDate: currentDate)
    }
    
    // MARK: - Props
    public var calendar: Calendar
    public var minDate: Date
    public var maxDate: Date
    public var currentDate: Date
}
