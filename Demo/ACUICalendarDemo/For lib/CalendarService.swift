//
//  CalendarService.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 23.08.2022.
//

import Foundation

open class CalendarService {
    
    // MARK: - Init
    public init(settings: CalendarSettings) {
        self.settings = settings
    }

    // MARK: - Props
    open var settings: CalendarSettings
    
    public var calendar: Calendar {
        get { self.settings.calendar }
        set { self.settings.calendar = newValue }
    }
    
    // MARK: - Methods
    open func generateMonth(_ monthDate: Date) -> CalendarMonthModel? {
        CalendarMonthModel(
            settings: self.settings,
            monthDates: self.monthDates(monthDate),
            previousMonthDates: self.weekDatesOfStartOfMonthWithoutCurrentMonth(for: monthDate),
            nextMonthDates: self.weekDatesOfEndOfMonthWithoutCurrentMonth(for: monthDate)
        )
    }
    
    open func monthDates(_ monthDate: Date) -> [Date] {
        guard
            let startOfMonth = self.startOfMonth(for: monthDate),
            let endOfMonth = self.endOfMonth(for: monthDate)
        else { return [] }
        
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
        
        return result
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
    
    open func weekDatesOfStartOfMonthWithoutCurrentMonth(for monthDate: Date) -> [Date] {
        guard
            let startOfMonth = self.startOfMonth(for: monthDate),
            let previousStartOfMonth = self.calendar.date(byAdding: .day, value: -1, to: startOfMonth)
        else { return [] }
        
        var result: [Date] = []
        var nextDate = previousStartOfMonth
        
        while self.calendar.component(.weekOfYear, from: startOfMonth) == self.calendar.component(.weekOfYear, from: nextDate) {
            result += [nextDate]
            
            guard let dateAddingDay = self.calendar.date(byAdding: .day, value: -1, to: nextDate) else { break }
            nextDate = dateAddingDay
        }
        
        return result
    }
    
    open func weekDatesOfEndOfMonthWithoutCurrentMonth(for monthDate: Date) -> [Date] {
        guard
            let endOfMonth = self.endOfMonth(for: monthDate),
            let nextEndOfMonth = self.calendar.date(byAdding: .day, value: 1, to: endOfMonth)
        else { return [] }
        
        var result: [Date] = []
        var nextDate = nextEndOfMonth
        
        while self.calendar.component(.weekOfYear, from: endOfMonth) == self.calendar.component(.weekOfYear, from: nextDate) {
            result += [nextDate]
            
            guard let dateAddingDay = self.calendar.date(byAdding: .day, value: 1, to: nextDate) else { break }
            nextDate = dateAddingDay
        }
        
        return result
    }
    
    func generateMonths() -> [CalendarMonthModel] {
        var result: [CalendarMonthModel] = []
        var currentDate = self.settings.minDate
        
        var condition: Bool {
            let compare = currentDate.compare(self.settings.maxDate)
            let condition = compare == .orderedAscending || compare == .orderedSame
            
            return condition
        }
        
        while currentDate <= self.settings.maxDate {
            guard let month = self.generateMonth(currentDate), let nextDate = self.calendar.date(byAdding: .month, value: 1, to: month.monthDate) else { break }
            result += [month]
            currentDate = nextDate
        }
        
        return result
    }

}
