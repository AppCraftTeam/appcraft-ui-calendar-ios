//
//  ACCalendarService.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 23.08.2022.
//

import Foundation

/// A set of methods for working with calendar data.
public struct ACCalendarService {
    
    // MARK: - Init
    public init(
        calendar: Calendar,
        minDate: Date,
        maxDate: Date,
        currentMonthDate: Date,
        selection: ACCalendarDateSelectionProtocol
    ) {
        self.calendar = calendar
        self.minDate = minDate
        self.maxDate = maxDate
        self.currentMonthDate = currentMonthDate
        self.selection = selection
        
        self.setupComponents()
    }
    
    public init() {
        let calendar = Calendar.defaultACCalendar()
        let currentDate = Date()
        let minDate = calendar.date(byAdding: .day, value: -2, to: currentDate) ?? currentDate
        let maxDate = calendar.date(byAdding: .day, value: 2, to: currentDate) ?? currentDate
        
        self.init(
            calendar: calendar,
            minDate: minDate,
            maxDate: maxDate,
            currentMonthDate: currentDate,
            selection: ACCalendarSingleDateSelection(calendar: calendar, datesSelected: [])
        )
    }

    // MARK: - Props
    
    /// The current calendar, which is used for all calculations related to dates. When setting a new value, the `setupComponents()` method will be called.
    public var calendar: Calendar {
        didSet {
            guard self.calendar != oldValue else { return }
            self.setupComponents()
        }
    }
    
    /// Minimum date. Starting from it, the data for the calendar will be calculated. When setting a new value, the `setupComponents()` method will be called.
    public var minDate: Date {
        didSet {
            guard self.minDate != oldValue else { return }
            self.setupComponents()
        }
    }
    
    /// Maximum date. Calendar data will be calculated before it. When setting a new value, the `setupComponents()` method will be called.
    public var maxDate: Date {
        didSet {
            guard self.maxDate != oldValue else { return }
            self.setupComponents()
        }
    }
    
    /// Date of the currently displayed month
    public var currentMonthDate: Date
    
    public var selection: ACCalendarDateSelectionProtocol
    
    public private(set) var months: [ACCalendarMonthModel] = []
    public private(set) var years: [ACCalendarYearModel] = []
    
    public var datesSelected: [Date] {
        get { self.selection.datesSelected }
        set { self.selection.datesSelected = newValue }
    }
    
    // MARK: - Methods
    public mutating func setupComponents() {
        self.selection.calendar = self.calendar
        
        self.months = self.generateMonths()
        self.years = self.generateYears(from: self.months)
    }
    
}

// MARK: - Equatable
extension ACCalendarService: Equatable {
    
    public static func == (lhs: ACCalendarService, rhs: ACCalendarService) -> Bool {
        lhs.calendar == rhs.calendar &&
        lhs.minDate == rhs.minDate &&
        lhs.maxDate == rhs.maxDate &&
        lhs.currentMonthDate == rhs.currentMonthDate &&
        lhs.selection.datesSelected == rhs.selection.datesSelected
    }
    
}

// MARK: - Helpers
public extension ACCalendarService {
    
    func generateMonths() -> [ACCalendarMonthModel] {
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
    
    func generateMonth(for monthDate: Date) -> ACCalendarMonthModel? {
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
    
    func generateCurrentMonthDates(for monthDate: Date) -> [Date]? {
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
    
    func startOfMonth(for monthDate: Date) -> Date? {
        let date = self.calendar.startOfDay(for: monthDate)
        let dateComponents = self.calendar.dateComponents([.year, .month], from: date)
        
        return self.calendar.date(from: dateComponents)
    }
    
    func endOfMonth(for monthDate: Date) -> Date? {
        guard let startOfMonth = self.startOfMonth(for: monthDate) else { return nil }
        let dateComponents = DateComponents(month: 1, day: -1)
        
        return self.calendar.date(byAdding: dateComponents, to: startOfMonth)
    }
    
    func generatePreviousMonthDates(for monthDate: Date) -> [Date]? {
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
    
    func generateNextMonthDates(for monthDate: Date) -> [Date]? {
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
    
    func generateDay(_ dayDate: Date, previousMonthDates: [Date], nextMonthDates: [Date]) -> ACCalendarDayModel {
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
    
    func month(on direction: ACCalendarDirection) -> Date? {
        var monthValue: Int {
            switch direction {
            case .previous:
                return -1
            case .next:
                return 1
            }
        }
        
        guard
            let startOfMonth = self.startOfMonth(for: self.currentMonthDate),
            let date = self.calendar.date(byAdding: .month, value: monthValue, to: startOfMonth),
            (date.isLess(than: self.maxDate, toGranularity: .month, calendar: self.calendar) || date.isEqual(to: self.maxDate, toGranularity: .month, calendar: self.calendar)),
            (date.isGreater(than: self.minDate, toGranularity: .month, calendar: self.calendar) || date.isEqual(to: self.minDate, toGranularity: .month, calendar: self.calendar))
        else { return nil }
        
        return date
    }
    
    func daySelected(_ day: ACCalendarDayModel) -> ACCalendarDateSelectionType {
        let dayDate = day.dayDate
        
        if self.dateShouldSelect(dayDate) {
            return self.selection.dateSelected(dayDate)
        } else {
            return .notAvailableSelect
        }
    }
    
    mutating func daySelect(_ day: ACCalendarDayModel) {
        guard
            day.belongsToMonth == .current,
            self.dateShouldSelect(day.dayDate)
        else { return }
        
        self.selection.dateSelect(day.dayDate)
    }
    
    func startOfYear(for yearDate: Date) -> Date? {
        let date = self.calendar.startOfDay(for: yearDate)
        let dateComponents = self.calendar.dateComponents([.year], from: date)
        
        return self.calendar.date(from: dateComponents)
    }
    
    func generateYears(from months: [ACCalendarMonthModel]) -> [ACCalendarYearModel] {
        var result: [ACCalendarYearModel] = []
        
        for month in months {
            if let last = result.last, last.yearDate.isEqual(to: month.monthDate, toGranularity: .year, calendar: self.calendar) {
                result = Array(result.dropLast())
                result += [
                    ACCalendarYearModel(
                        year: last.year,
                        yearDate: last.yearDate,
                        months: last.months + [month]
                    )
                ]
            } else {
                result += [
                    ACCalendarYearModel(
                        year: self.calendar.component(.year, from: month.monthDate),
                        yearDate: month.monthDate,
                        months: [month]
                    )
                ]
            }
        }
        
        return result
    }
    
    func dateShouldSelect(_ date: Date) -> Bool {
        (date.isLess(than: self.maxDate, toGranularity: .day, calendar: self.calendar) ||
            date.isEqual(to: self.maxDate, toGranularity: .day, calendar: self.calendar)) &&
        (date.isGreater(than: self.minDate, toGranularity: .day, calendar: self.calendar) || date.isEqual(to: self.minDate, toGranularity: .day, calendar: self.calendar))
    }
    
}
