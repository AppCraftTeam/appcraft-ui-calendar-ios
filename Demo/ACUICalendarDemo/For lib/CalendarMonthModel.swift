//
//  CalendarMonthModel.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation

public struct CalendarMonthModel {
    
    init?(monthDates: [Date], weekDatesOfStartOfMonthWithoutCurrentMonth: [Date], weekDatesOfEndOfMonthWithoutCurrentMonth: [Date]) {
        guard
            !monthDates.isEmpty,
            let monthDate = monthDates.first
        else { return nil }
        
        self.monthDate = monthDate
        self.monthDates = monthDates
        self.weekDatesOfStartOfMonthWithoutCurrentMonth = weekDatesOfStartOfMonthWithoutCurrentMonth
        self.weekDatesOfEndOfMonthWithoutCurrentMonth = weekDatesOfEndOfMonthWithoutCurrentMonth
        self.allDates = weekDatesOfStartOfMonthWithoutCurrentMonth + monthDates + weekDatesOfEndOfMonthWithoutCurrentMonth
    }
    
    let monthDate: Date
    let monthDates: [Date]
    let weekDatesOfStartOfMonthWithoutCurrentMonth: [Date]
    let weekDatesOfEndOfMonthWithoutCurrentMonth: [Date]
    let allDates: [Date]
    
    func containtsDate(_ date: Date) -> Bool {
        self.monthDates.contains(where: { $0.compare(date) == .orderedSame })
    }
}
