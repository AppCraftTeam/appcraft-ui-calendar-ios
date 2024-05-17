//
//  PastMonthGenerator.swift
//  
//
//  Created by Damian on 16.05.2024.
//

import Foundation

class PastMonthGenerator: MonthGenerator {
    
    let minDate: Date?
    let currentDate: Date

    init(calendar: Calendar, currentDate: Date, minDate: Date? = nil) {
        self.minDate = minDate
        self.currentDate = currentDate
        super.init(calendar: calendar)
    }
    
    @discardableResult
    public override func next() -> ACCalendarMonthModel? {
        let lastMinDate = self.months.first?.monthDate ?? currentDate
        guard let nextLeftDate = calendar.date(byAdding: .month, value: -1, to: lastMinDate) else {
            return nil
        }
        
        if let minDate, let nextDate = calendar.date(byAdding: .day, value: 1, to: nextLeftDate), nextDate <= minDate {
            return nil
        }
        guard let nextMonth = self.generateMonth(for: nextLeftDate) else {
            return nil
        }
        self.months.insert(nextMonth, at: 0)
        return nextMonth
    }
}
