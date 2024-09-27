//
//  PastMonthGenerator.swift
//  
//
//  Created by Damian on 16.05.2024.
//

import Foundation

open class PastMonthGenerator: MonthGenerator {
    
    public let minDate: Date?
    public let currentDate: Date
    public init(calendar: Calendar, currentDate: Date, minDate: Date? = nil) {
        self.minDate = minDate
        self.currentDate = currentDate
        super.init(calendar: calendar)
    }
        
    @discardableResult
    open override func next() -> ACCalendarMonthModel? {
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
        print("asyncGenerateFeatureDates months! \(nextMonth.monthDate)")

        return nextMonth
    }
}
