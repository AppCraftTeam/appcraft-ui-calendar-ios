//
//  ACCalendarService.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 23.08.2022.
//

import Foundation

/// A set of methods for working with calendar data.
public class ACCalendarService {
    
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
    
    static func makeLessCurrentMinDate(_ currentMinDate: Date, calendar: Calendar) -> ACCalendarService {
        ACCalendarService(
            calendar: calendar,
            minDate: calendar.date(byAdding: .year, value: -2, to: currentMinDate) ?? currentMinDate,
            maxDate: currentMinDate,
            currentMonthDate: currentMinDate,
            selection: ACCalendarSingleDateSelection(calendar: calendar, datesSelected: [])
        )
    }
    
    public convenience init(isInfinity: Bool = false) {
        let calendar = Calendar.defaultACCalendar()
        let currentDate = Date()
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate) ?? currentDate
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate) ?? currentDate
        
        self.init(
            calendar: calendar,
            minDate: minDate,
            maxDate: maxDate,
            currentMonthDate: currentDate,
            selection: ACCalendarSingleDateSelection(calendar: calendar, datesSelected: [])
        )
    }

    // MARK: - Props

    lazy var pastMonthGenerator = PastMonthGenerator(
        calendar: calendar,
        currentDate: currentMonthDate,
        minDate: minDate
    )
    
    lazy var futureMonthGenerator = FutureMonthGenerator(
        calendar: calendar,
        currentDate: currentMonthDate,
        maxDate: maxDate
    )

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
    
    public var months: [ACCalendarMonthModel] {
        pastMonthGenerator.months + futureMonthGenerator.months
    }
    public var years: [ACCalendarYearModel] = []
    
    public var datesSelected: [Date] {
        get { self.selection.datesSelected }
        set { self.selection.datesSelected = newValue }
    }
    
    // MARK: - Methods
    public func setupComponents() {
        self.selection.calendar = self.calendar
        self.generatePastMonths()
        self.generateFutureMonths()
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
// MARK: - Generators
public extension ACCalendarService {
    
    @discardableResult
    func generatePastMonths(count: Int = 2) -> [ACCalendarMonthModel] {
        let months = (0...count + 1).compactMap { _ in
            self.pastMonthGenerator.next()
        }
        if !months.isEmpty {
            years = generateYears(from: self.months)
        }
        return months
    }

    @discardableResult
    func generateFutureMonths(count: Int = 2) -> [ACCalendarMonthModel] {
        let months = (0...count + 1).compactMap { _ in
            self.futureMonthGenerator.next()
        }
        if !months.isEmpty {
           years = generateYears(from: self.months)
        }
        return months
    }
}

// MARK: - Helpers
public extension ACCalendarService {
    
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
    
    func daySelect(_ day: ACCalendarDayModel) {
        guard
            day.belongsToMonth == .current,
            self.dateShouldSelect(day.dayDate)
        else { return }
        
        self.selection.dateSelect(day.dayDate)
    }
    
    func dateShouldSelect(_ date: Date) -> Bool {
        (date.isLess(than: self.maxDate, toGranularity: .day, calendar: self.calendar) ||
         date.isEqual(to: self.maxDate, toGranularity: .day, calendar: self.calendar)) &&
        (date.isGreater(than: self.minDate, toGranularity: .day, calendar: self.calendar) || date.isEqual(to: self.minDate, toGranularity: .day, calendar: self.calendar))
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
    
}

func measure(_ title: String = #function, block: (@escaping () -> ()) -> ()) {
    
    let startTime = DispatchTime.now().uptimeNanoseconds
    
    block {
        let timeElapsed = Double(DispatchTime.now().uptimeNanoseconds - startTime) / 1e9
        
        NSLog("[Measure] - [\(title)]: Time: \(timeElapsed) seconds")
    }
}
