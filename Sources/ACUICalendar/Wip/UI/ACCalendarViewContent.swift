//
//  CalendarViewContent.swift
//  ACUICalendar
//

import UIKit

public final class ACCalendarViewContent {
    
    public let calendar: Calendar
    public let dayRange: DayRange
    public let monthRange: MonthRange
    public let monthsLayout: ACMonthsLayout
    
    public var selectedDate: Date?
    
    public var monthHeaderDateFormatter: DateFormatter {
        calendar.createMonthFormatter()
    }
    
    public var dayDateFormatter: DateFormatter {
        calendar.createDayFormatter()
    }
    
    public init(
        calendar: Calendar = Calendar.current,
        visibleDateRange: ClosedRange<Date>,
        monthsLayout: ACMonthsLayout
    ){
        self.calendar = calendar
        monthRange = MonthRange(containing: visibleDateRange, in: calendar)
        self.monthsLayout = monthsLayout
        
        let firstDateOfLowerBoundMonth = calendar.firstDate(of: monthRange.lowerBound)
        let lastDateOfUpperBoundMonth = calendar.lastDate(of: monthRange.upperBound)
        dayRange = DayRange(
            containing: firstDateOfLowerBoundMonth...lastDateOfUpperBoundMonth,
            in: calendar
        )
    }
    
    public func monthHeaderItemProvider(for month: MonthComponents) -> AnyCalendarItemModel {
        let firstDateInMonth = calendar.firstDate(of: month)
        let monthText = monthHeaderDateFormatter.string(from: firstDateInMonth)
        
        let viewModel = MonthHeaderView.ViewModel(
            theme: ACCalendarUITheme()
        )
        let content = MonthHeaderView.Content(
            monthText: monthText
        )
        
        return MonthHeaderView.calendarItemModel(
            viewModel: viewModel,
            content: content
        )
    }
    
    public func dayOfWeekItemProvider(for month: MonthComponents?, weekdayIndex: Int) -> AnyCalendarItemModel {
        let dayOfWeekText = monthHeaderDateFormatter.veryShortStandaloneWeekdaySymbols[weekdayIndex]
        
        let viewModel = DayOfWeekView.ViewModel(
            theme: ACCalendarUITheme()
        )
        let content = DayOfWeekView.Content(
            dayOfWeekText: dayOfWeekText
        )
        
        return DayOfWeekView.calendarItemModel(
            viewModel: viewModel,
            content: content
        )
    }
    
    public func dayItemProvider(for day: DayComponents) -> AnyCalendarItemModel {
        let date = calendar.date(from: day.components)
        
        let viewModel = DayView.ViewModel(
            isSelected: date == selectedDate,
            isEnabled: true,
            theme: ACCalendarUITheme()
        )
        let content = DayView.Content(
            dayText: "\(day.day)"
        )
        
        return DayView.calendarItemModel(
            viewModel: viewModel,
            content: content
        )
    }
}

