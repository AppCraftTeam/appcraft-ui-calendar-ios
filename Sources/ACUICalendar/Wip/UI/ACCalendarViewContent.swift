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
    public let params: ACCalendarViewContent.Params
    
    public struct Params {
        public var dayAspectRatio: CGFloat
        public var dayOfWeekAspectRatio: CGFloat
        public var interMonthSpacing: CGFloat
        public var monthDayInsets: UIEdgeInsets
        public var verticalDayMargin: CGFloat
        public var horizontalDayMargin: CGFloat
        
        public init(
            dayAspectRatio: CGFloat = 1,
            dayOfWeekAspectRatio: CGFloat = 1,
            interMonthSpacing: CGFloat = 0,
            monthDayInsets: UIEdgeInsets = .zero,
            verticalDayMargin: CGFloat = 0,
            horizontalDayMargin: CGFloat = 0
        ) {
            self.interMonthSpacing = interMonthSpacing
            self.monthDayInsets = monthDayInsets
            self.verticalDayMargin = verticalDayMargin
            self.horizontalDayMargin = horizontalDayMargin
            
            let validAspectRatioRange: ClosedRange<CGFloat> = 0.5...3
            
            self.dayOfWeekAspectRatio = min(
                max(dayOfWeekAspectRatio, validAspectRatioRange.lowerBound),
                validAspectRatioRange.upperBound
            )
            self.dayAspectRatio = min(
                max(dayAspectRatio, validAspectRatioRange.lowerBound),
                validAspectRatioRange.upperBound
            )
        }
    }
    
    public var selectedDate: Date?
    
    public var monthHeaderDateFormatter: DateFormatter {
        calendar.createMonthFormatter()
    }
    
    public var dayDateFormatter: DateFormatter {
        calendar.createDayFormatter()
    }
    
    public var dayRangesAndItemProvider: (
        dayRanges: Set<DayRange>,
        dayRangeItemProvider: (DayRangeLayoutContext) -> AnyCalendarItemModel)?
    
    public var overlaidItemLocationsAndItemProvider: (
        overlaidItemLocations: Set<OverlaidItemLocation>,
        overlayItemProvider: (OverlayLayoutContext) -> AnyCalendarItemModel)?
    
    public init(
        calendar: Calendar = Calendar.current,
        visibleDateRange: ClosedRange<Date>,
        monthsLayout: ACMonthsLayout,
        params: ACCalendarViewContent.Params
    ){
        self.calendar = calendar
        monthRange = MonthRange(containing: visibleDateRange, in: calendar)
        self.monthsLayout = monthsLayout
        self.params = params
        
        let firstDateOfLowerBoundMonth = calendar.firstDate(of: monthRange.lowerBound)
        let lastDateOfUpperBoundMonth = calendar.lastDate(of: monthRange.upperBound)
        dayRange = DayRange(
            containing: firstDateOfLowerBoundMonth...lastDateOfUpperBoundMonth,
            in: calendar
        )
    }
    
    public func dayRangeItemProvider(
        for dateRanges: Set<ClosedRange<Date>>,
        _ dayRangeItemProvider: @escaping (
            _ dayRangeLayoutContext: DayRangeLayoutContext)
        -> AnyCalendarItemModel) {
        let dayRanges = Set(dateRanges.map { DayRange(containing: $0, in: calendar) })
        dayRangesAndItemProvider = (dayRanges, dayRangeItemProvider)
    }
    
    public func overlayItemProvider(
        for overlaidItemLocations: Set<OverlaidItemLocation>,
        _ overlayItemProvider: @escaping (
            _ overlayLayoutContext: OverlayLayoutContext)
        -> AnyCalendarItemModel) {
        overlaidItemLocationsAndItemProvider = (overlaidItemLocations, overlayItemProvider)
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
