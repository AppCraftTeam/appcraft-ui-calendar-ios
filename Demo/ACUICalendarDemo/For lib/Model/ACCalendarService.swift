//
//  ACCalendarService.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 23.08.2022.
//

import Foundation

open class ACCalendarService {
    
    // MARK: - Init
    public init(settings: ACCalendarSettings) {
        self.settings = settings
    }

    // MARK: - Props
    open var settings: ACCalendarSettings
    
    public var calendar: Calendar {
        get { self.settings.calendar }
        set { self.settings.calendar = newValue }
    }
    
    // MARK: - Methods
    open func generateMonths() -> [ACCalendarMonthModel] {
        var result: [ACCalendarMonthModel] = []
        var currentDate = self.settings.minDate
        
        var condition: Bool {
            let compare = currentDate.compare(self.settings.maxDate)
            let condition = compare == .orderedAscending || compare == .orderedSame
            
            return condition
        }
        
        while currentDate <= self.settings.maxDate {
            guard
                let month = self.generateMonth(for: currentDate),
                let nextDate = self.calendar.date(byAdding: .month, value: 1, to: month.monthDate)
            else { break }
            
            result += [month]
            currentDate = nextDate
        }
        
        return result
    }
    
    open func generateMonth(for monthDate: Date) -> ACCalendarMonthModel? {
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
    
    open func generateCurrentMonthDates(for monthDate: Date) -> [Date]? {
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
    
    open func startOfMonth(for monthDate: Date) -> Date? {
        let date = self.calendar.startOfDay(for: monthDate)
        let dateComponents = self.calendar.dateComponents([.year, .month], from: date)
        
        return self.calendar.date(from: dateComponents)
    }
    
    open func endOfMonth(for monthDate: Date) -> Date? {
        guard let startOfMonth = self.startOfMonth(for: monthDate) else { return nil }
        let dateComponents = DateComponents(month: 1, day: -1)
        
        return self.calendar.date(byAdding: dateComponents, to: startOfMonth)
    }
    
    open func generatePreviousMonthDates(for monthDate: Date) -> [Date]? {
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
    
    open func generateNextMonthDates(for monthDate: Date) -> [Date]? {
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
    
    open func generateDay(_ dayDate: Date, previousMonthDates: [Date], nextMonthDates: [Date]) -> ACCalendarDayModel {
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
    
    open func isContaints(date: Date, in dates: [Date]) -> Bool {
        let calendar = self.settings.calendar
        
        let result = dates.contains { dateFromDates in
            calendar.compare(date, to: dateFromDates, toGranularity: .day) == .orderedSame
        }
        
        return result
    }

}
