//
//  CalendarMonthModel.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation

public struct CalendarMonthModel {
    
    init?(settings: CalendarSettings, monthDates: [Date], previousMonthDates: [Date], nextMonthDates: [Date]) {
        guard
            !monthDates.isEmpty,
            let monthDate = monthDates.first
        else { return nil }
        
        self.monthDate = monthDate
        self.monthDates = monthDates
        self.previousMonthDates = previousMonthDates
        self.nextMonthDates = nextMonthDates
        
        self.days = (previousMonthDates + monthDates + nextMonthDates)
            .sorted()
            .map({ date in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd"
                
                let dateText = formatter.string(from: date)
                
                var belongsToMonth: CalendarDayBelongsToMonth {
                    func dateContaints(_ date: Date, in dates: [Date]) -> Bool {
                        dates.contains(where: { settings.calendar.compare($0, to: date, toGranularity: .day) == .orderedSame })
                    }
                    
                    if dateContaints(date, in: previousMonthDates) {
                        return .previous
                    } else if dateContaints(date, in: nextMonthDates) {
                        return .next
                    } else {
                        return .current
                    }
                }
                
                return CalendarDayModel(
                    date: date,
                    dateText: dateText,
                    belongsToMonth: belongsToMonth
                )
            })
    }
    
    let monthDate: Date
    let monthDates: [Date]
    let previousMonthDates: [Date]
    let nextMonthDates: [Date]
    let days: [CalendarDayModel]
    
    func containtsDate(_ date: Date) -> Bool {
        self.monthDates.contains(where: { $0.compare(date) == .orderedSame })
    }
}
