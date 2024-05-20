//
//  MonthGenerator.swift
//  
//
//  Created by Damian on 16.05.2024.
//

import Foundation

open class MonthGenerator: IteratorProtocol {

    public typealias Element = ACCalendarMonthModel

    open var months = [ACCalendarMonthModel]()

    public let calendar: Calendar

    public init(calendar: Calendar) {
        self.calendar = calendar
    }

    @discardableResult
    open func next() -> ACCalendarMonthModel? { nil }

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
            month: self.calendar.component(.month, from: monthDate),
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
        func isContaints(date: Date, in dates: [Date]) -> Bool {
            dates.contains { dateFromDates in
                self.calendar.compare(date, to: dateFromDates, toGranularity: .day) == .orderedSame
            }
        }
        
        var belongsToMonth: ACCalendarBelongsToMonth {
            if isContaints(date: dayDate, in: previousMonthDates) {
                return .previous
            } else if isContaints(date: dayDate, in: nextMonthDates) {
                return .next
            } else {
                return .current
            }
        }

        let locale = self.calendar.locale ?? .current
        
        return ACCalendarDayModel(
            day: self.calendar.component(.day, from: dayDate),
            dayDate: dayDate,
            dayDateText: dayDate.toLocalString(withFormatType: .day, locale: locale),
            belongsToMonth: belongsToMonth
        )
    }
}
