//
//  FutureMonthGenerator.swift
//
//
//  Created by Damian on 16.05.2024.
//

import Foundation

open class FutureMonthGenerator: MonthGenerator {

    public let maxDate: Date?
    public let currentDate: Date
    
    public init(calendar: Calendar, currentDate: Date,  maxDate: Date? = nil) {
        self.maxDate = maxDate
        self.currentDate = currentDate
        super.init(calendar: calendar)
        if let month = self.generateMonth(for: currentDate) {
            self.months.append(month)
        }
    }
    
    @discardableResult
    open override func next() -> ACCalendarMonthModel? {
        let lastMaxDate = self.months.last?.monthDate ?? currentDate

        guard let nextDate = calendar.date(byAdding: .month, value: 1, to: lastMaxDate) else {
            return nil
        }

        if let maxDate, maxDate <= nextDate {
            return nil
        }

        guard let nextMonth = self.generateMonth(for: nextDate) else {
            return nil
        }
        self.months.append(nextMonth)

        return nextMonth
    }
    
}
