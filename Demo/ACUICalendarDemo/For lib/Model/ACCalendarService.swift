//
//  ACCalendarService.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 23.08.2022.
//

import Foundation

public struct ACCalendarService {
    
    // MARK: - Init
    public init(
        calendar: Calendar,
        minDate: Date,
        maxDate: Date,
        currentMonthDate: Date,
        locale: Locale
    ) {
        self.calendar = calendar
        self.minDate = minDate
        self.maxDate = maxDate
        self.currentMonthDate = currentMonthDate
        self.locale = locale
    }
    
    public static func `default`() -> Self {
        let calendar = Calendar.defaultACCalendar()
        let currentDate = Date()
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate) ?? currentDate
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate) ?? currentDate
        
        return .init(
            calendar: calendar,
            minDate: minDate,
            maxDate: maxDate,
            currentMonthDate: currentDate,
            locale: .current
        )
    }

    // MARK: - Props
    public var calendar: Calendar
    public var minDate: Date
    public var maxDate: Date
    public var currentMonthDate: Date
    public var locale: Locale
    
    // MARK: - Methods
    public func generateMonths() -> [ACCalendarMonthModel] {
        var result: [ACCalendarMonthModel] = []
        var currentDate = self.minDate
        
        var condition: Bool {
            let compare = currentDate.compare(self.maxDate)
            let condition = compare == .orderedAscending || compare == .orderedSame
            
            return condition
        }
        
        while currentDate <= self.maxDate {
            guard
                let month = self.generateMonth(for: currentDate),
                let nextDate = self.calendar.date(byAdding: .month, value: 1, to: month.monthDate)
            else { break }
            
            result += [month]
            currentDate = nextDate
        }
        
        return result
    }
    
    public func generateMonth(for monthDate: Date) -> ACCalendarMonthModel? {
        guard
            let monthDates = self.generateCurrentMonthDates(for: monthDate),
            let previousMonthDates = self.generatePreviousMonthDates(for: monthDate),
            let nextMonthDates = self.generateNextMonthDates(for: monthDate),
            let monthDate = monthDates.first
        else { return nil }
        
        let days = (previousMonthDates + monthDates + nextMonthDates)
            .sorted()
            .map({ date in
                self.generateDay(date, previousMonthDates: previousMonthDates, nextMonthDates: nextMonthDates)
            })
        
        return ACCalendarMonthModel(
            monthDate: monthDate,
            monthDates: monthDates,
            previousMonthDates: previousMonthDates,
            nextMonthDates: nextMonthDates,
            days: days
        )
    }
    
    public func generateCurrentMonthDates(for monthDate: Date) -> [Date]? {
        guard
            let startOfMonth = self.startOfMonth(for: monthDate),
            let endOfMonth = self.endOfMonth(for: monthDate)
        else { return nil }
        
        var result: [Date] = []
        var nextDate = startOfMonth
        
        var startCondition: Bool {
            let compare = nextDate.compare(startOfMonth)
            let condition = compare == .orderedDescending || compare == .orderedSame
            
            return condition
        }
        
        var endCondition: Bool {
            let compare = nextDate.compare(endOfMonth)
            let condition = compare == .orderedAscending || compare == .orderedSame
            
            return condition
        }
        
        while startCondition && endCondition {
            result += [nextDate]
            
            guard let dateAddingDay = self.calendar.date(byAdding: .day, value: 1, to: nextDate) else { break }
            nextDate = dateAddingDay
        }
        
        return result.sorted()
    }
    
    public func startOfMonth(for monthDate: Date) -> Date? {
        let date = self.calendar.startOfDay(for: monthDate)
        let dateComponents = self.calendar.dateComponents([.year, .month], from: date)
        
        return self.calendar.date(from: dateComponents)
    }
    
    public func endOfMonth(for monthDate: Date) -> Date? {
        guard let startOfMonth = self.startOfMonth(for: monthDate) else { return nil }
        let dateComponents = DateComponents(month: 1, day: -1)
        
        return self.calendar.date(byAdding: dateComponents, to: startOfMonth)
    }
    
    public func generatePreviousMonthDates(for monthDate: Date) -> [Date]? {
        guard
            let startOfMonth = self.startOfMonth(for: monthDate),
            let previousStartOfMonth = self.calendar.date(byAdding: .day, value: -1, to: startOfMonth)
        else { return nil }
        
        var result: [Date] = []
        var nextDate = previousStartOfMonth
        
        while self.calendar.component(.weekOfYear, from: startOfMonth) == self.calendar.component(.weekOfYear, from: nextDate) {
            result += [nextDate]
            
            guard let dateAddingDay = self.calendar.date(byAdding: .day, value: -1, to: nextDate) else { break }
            nextDate = dateAddingDay
        }
        
        return result.sorted()
    }
    
    public func generateNextMonthDates(for monthDate: Date) -> [Date]? {
        guard
            let endOfMonth = self.endOfMonth(for: monthDate),
            let nextEndOfMonth = self.calendar.date(byAdding: .day, value: 1, to: endOfMonth)
        else { return nil }
        
        var result: [Date] = []
        var nextDate = nextEndOfMonth
        
        while self.calendar.component(.weekOfYear, from: endOfMonth) == self.calendar.component(.weekOfYear, from: nextDate) {
            result += [nextDate]
            
            guard let dateAddingDay = self.calendar.date(byAdding: .day, value: 1, to: nextDate) else { break }
            nextDate = dateAddingDay
        }
        
        return result.sorted()
    }
    
    public func generateDay(_ dayDate: Date, previousMonthDates: [Date], nextMonthDates: [Date]) -> ACCalendarDayModel {
        var belongsToMonth: ACCalendarBelongsToMonth {
            if self.isContaints(date: dayDate, in: previousMonthDates) {
                return .previous
            } else if self.isContaints(date: dayDate, in: nextMonthDates) {
                return .next
            } else {
                return .current
            }
        }
        
        return ACCalendarDayModel(
            date: dayDate,
            belongsToMonth: belongsToMonth
        )
    }
    
    public func isContaints(date: Date, in dates: [Date]) -> Bool {
        dates.contains { dateFromDates in
            self.calendar.compare(date, to: dateFromDates, toGranularity: .day) == .orderedSame
        }
    }
    
    public func nextMonth() -> Date? {
        guard
            let startOfMonth = self.startOfMonth(for: self.currentMonthDate),
            let nextMonthDate = self.calendar.date(byAdding: .month, value: 1, to: startOfMonth)
        else { return nil }
        
        return nextMonthDate
    }
    
    public func previousMonth() -> Date? {
        guard
            let startOfMonth = self.startOfMonth(for: self.currentMonthDate),
            let previousMonthDate = self.calendar.date(byAdding: .month, value: -1, to: startOfMonth)
        else { return nil }
        
        return previousMonthDate
    }

}
