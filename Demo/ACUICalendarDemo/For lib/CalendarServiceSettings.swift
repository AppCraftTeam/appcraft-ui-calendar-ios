//
//  CalendarServiceSettings.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation

public struct CalendarServiceSettings {
    
    static func `default`() -> Self {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        let currentDate = Date()
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate) ?? currentDate
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate) ?? currentDate
        
        return .init(calendar: calendar, minDate: minDate, maxDate: maxDate, currentDate: currentDate)
    }
    
    public var calendar: Calendar
    public var minDate: Date
    public var maxDate: Date
    public var currentDate: Date
}
