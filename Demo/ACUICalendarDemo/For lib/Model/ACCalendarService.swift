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
        let minDate = calendar.date(byAdding: .year, value: -1, to: currentDate) ?? currentDate
        let maxDate = calendar.date(byAdding: .year, value: 1, to: currentDate) ?? currentDate
        
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
    public var datesSelection: ACCalendarDateSelectionProtocol = ACCalendarRangeDateSelection()
    
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
            let date = self.calendar.date(byAdding: .month, value: 1, to: startOfMonth),
            self.dateIsCorrespondsToMinAndMax(date)
        else { return nil }
        
        return date
    }
    
    public func previousMonth() -> Date? {
        guard
            let startOfMonth = self.startOfMonth(for: self.currentMonthDate),
            let date = self.calendar.date(byAdding: .month, value: -1, to: startOfMonth),
            self.dateIsCorrespondsToMinAndMax(date)
        else { return nil }
        
        return date
    }
    
    public func dateIsCorrespondsToMinAndMax(_ date: Date) -> Bool {
        (date.isLess(than: self.maxDate, toGranularity: .month, calendar: self.calendar) || date.isEqual(to: self.maxDate, toGranularity: .month, calendar: self.calendar)) &&
        (date.isGreater(than: self.minDate, toGranularity: .month, calendar: self.calendar) || date.isEqual(to: self.minDate, toGranularity: .month, calendar: self.calendar))
    }
    
    public func dayIsSelected(_ day: ACCalendarDayModel) -> ACCalendarDateSelectionType {
        self.datesSelection.dateSelected(day.dayDate, calendar: self.calendar)
    }
    
    public mutating func daySelect(_ day: ACCalendarDayModel) {
        self.datesSelection.dateSelecting(day.dayDate, calendar: self.calendar, belongsToMonth: day.belongsToMonth)
    }
    
    public func startOfYear(for yearDate: Date) -> Date? {
        let date = self.calendar.startOfDay(for: yearDate)
        let dateComponents = self.calendar.dateComponents([.year], from: date)
        
        return self.calendar.date(from: dateComponents)
    }
    
    public func generateYears() -> [ACCalendarYearModel] {
        let months = self.generateMonths()
        var result: [ACCalendarYearModel] = []
        
        for month in months {
            if let last = result.last, last.yearDate.isEqual(to: month.monthDate, toGranularity: .year, calendar: self.calendar) {
                result = Array(result.dropLast())
                result += [
                    ACCalendarYearModel(
                        yearDate: last.yearDate,
                        months: last.months + [month]
                    )
                ]
            } else {
                result += [
                    ACCalendarYearModel(
                        yearDate: month.monthDate,
                        months: [month]
                    )
                ]
            }
        }
        
        return result
    }

}

public protocol ACCalendarDateSelectionProtocol {
    var datesSelected: [Date] { get set }
    
    func dateSelected(_ date: Date, calendar: Calendar) -> ACCalendarDateSelectionType
    mutating func dateSelecting(_ date: Date, calendar: Calendar, belongsToMonth: ACCalendarBelongsToMonth)
}

public extension ACCalendarDateSelectionProtocol {
    
    func dateSelected(_ date: Date, calendar: Calendar) -> ACCalendarDateSelectionType {
        if let first = self.datesSelected.first, first.isEqual(to: date, toGranularity: .day, calendar: calendar) {
            return .startOfRange
        } else if let last = self.datesSelected.last, last.isEqual(to: date, toGranularity: .day, calendar: calendar) {
            return .endOfRange
        } else if self.datesSelected.contains(where: { $0.isEqual(to: date, toGranularity: .day, calendar: calendar) }) {
            return .middleOfRange
        } else {
            return .notSelected
        }
    }
    
}

public struct ACCalendarSingleDateSelection: ACCalendarDateSelectionProtocol {
    
    public var datesSelected: [Date] = []
    
    public mutating func dateSelecting(_ date: Date, calendar: Calendar, belongsToMonth: ACCalendarBelongsToMonth) {
        guard belongsToMonth == .current else { return }
        self.datesSelected = [date]
    }
    
}

public struct ACCalendarRangeDateSelection: ACCalendarDateSelectionProtocol {
    
    public var datesSelected: [Date] = []
    
    public mutating func dateSelecting(_ date: Date, calendar: Calendar, belongsToMonth: ACCalendarBelongsToMonth) {
        guard belongsToMonth == .current else { return }
    
        if let first = self.datesSelected.first, first.isEqual(to: date, toGranularity: .day, calendar: calendar) {
            self.datesSelected = Array(self.datesSelected.dropFirst())
        } else if let last = self.datesSelected.last, last.isEqual(to: date, toGranularity: .day, calendar: calendar) {
            self.datesSelected = Array(self.datesSelected.dropLast())
        } else if let first = self.datesSelected.first, date.isLess(than: first, toGranularity: .day, calendar: calendar), let last = self.datesSelected.last {
            self.datesSelected = self.generateDatesRange(from: date, to: last, calendar: calendar)
        } else if let first = self.datesSelected.first, date.isGreater(than: first, toGranularity: .day, calendar: calendar) {
            self.datesSelected = self.generateDatesRange(from: first, to: date, calendar: calendar)
        } else {
            self.datesSelected = [date]
        }
    }
    
    public func generateDatesRange(from startDate: Date, to endDate: Date, calendar: Calendar) -> [Date] {
        var currentDate: Date = startDate
        var result: [Date] = []
        
        while currentDate.isLess(than: endDate, toGranularity: .day, calendar: calendar) || currentDate.isEqual(to: endDate, toGranularity: .day, calendar: calendar) {
            result += [currentDate]
            
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return result
    }
    
}

public struct ACCalendarYearModel {
    let yearDate: Date
    let months: [ACCalendarMonthModel]
}
