//
//  CalendarService.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 23.08.2022.
//

import Foundation

public struct CalendarServiceSettings {
    public var calendar: Calendar
    public var minDate: Date
    public var maxDate: Date
    public var currentDate: Date
}

open class CalendarService {
    
    // MARK: - Init
    public init(settings: CalendarServiceSettings) {
        self.settings = settings
    }
    
    // MARK: - Props
    open var settings: CalendarServiceSettings
    
    // MARK: - Methods
    open func getMonthDates(_ monthDate: Date) -> [Date]? {
        let calendar = self.settings.calendar
        let date = calendar.startOfDay(for: monthDate)
        
        var result: [Date] = []
        
//        let startOfMonth =
//        let endOfMonth =
        
        return result
    }
}
