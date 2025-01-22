//
//  LayoutItemTypeEnumerator.swift
//  ACUICalendar
//

import UIKit

final class LayoutItemTypeEnumerator {
        
    init(calendar: Calendar, monthsLayout: ACMonthsLayout, monthRange: MonthRange, dayRange: DayRange) {
        self.calendar = calendar
        self.monthsLayout = monthsLayout
        self.monthRange = monthRange
        self.dayRange = dayRange
    }
        
    func enumerateItemTypes(
        startingAt startingItemType: LayoutItem.ItemType,
        itemTypeHandlerLookingBackwards: (LayoutItem.ItemType, _ shouldStop: inout Bool) -> Void,
        itemTypeHandlerLookingForwards: (LayoutItem.ItemType, _ shouldStop: inout Bool) -> Void) {
        var currentItemType = previousItemType(from: startingItemType)
        
        var shouldStopLookingBackwards = false
            
        while !shouldStopLookingBackwards {
            guard isItemTypeInRange(currentItemType) else { break }
            itemTypeHandlerLookingBackwards(currentItemType, &shouldStopLookingBackwards)
            currentItemType = previousItemType(from: currentItemType)
        }
        
        currentItemType = startingItemType
        
        var shouldStopLookingForwards = false
            
        while !shouldStopLookingForwards {
            guard isItemTypeInRange(currentItemType) else { break }
            itemTypeHandlerLookingForwards(currentItemType, &shouldStopLookingForwards)
            currentItemType = nextItemType(from: currentItemType)
        }
    }
    
    // MARK: Private
    
    private let calendar: Calendar
    private let monthsLayout: ACMonthsLayout
    private let monthRange: MonthRange
    private let dayRange: DayRange
    
    private func isItemTypeInRange(_ itemType: LayoutItem.ItemType) -> Bool {
        switch itemType {
        case .monthHeader(let month):
            return monthRange.contains(month)
        case .dayOfWeekInMonth(_, let month):
            return monthRange.contains(month)
        case .day(let day):
            return dayRange.contains(day)
        case .emptyDate(let day):
            return true
        }
    }
    
    private func previousItemType(from itemType: LayoutItem.ItemType) -> LayoutItem.ItemType {
        switch itemType {
        case .monthHeader(let month):
            let previousMonth = calendar.month(byAddingMonths: -1, to: month)
            let lastDateOfPreviousMonth = calendar.lastDate(of: previousMonth)
            return .day(calendar.day(containing: lastDateOfPreviousMonth))
        case .dayOfWeekInMonth(let position, let month):
            if position == .first {
                return .monthHeader(month)
            }
            guard let previousPosition = WeekdayPosition(rawValue: position.rawValue - 1) else {
                return .monthHeader(month)
            }
            return .dayOfWeekInMonth(position: previousPosition, month: month)
        case .day(let day):
            if day.day == 1 || day == dayRange.lowerBound {
                return .dayOfWeekInMonth(position: .last, month: day.month)
            }
            return .day(calendar.day(byAddingDays: -1, to: day))
        case .emptyDate(let day):
            return .emptyDate(day)
        }
    }
    
    private func nextItemType(from itemType: LayoutItem.ItemType) -> LayoutItem.ItemType {
        switch itemType {
        case .monthHeader(let month):
            return .dayOfWeekInMonth(position: .first, month: month)
        case .dayOfWeekInMonth(let position, let month):
            if position == .last {
                return .day(firstDayInRange(in: month))
            } else {
                guard let nextPosition = WeekdayPosition(rawValue: position.rawValue + 1) else {
                    return .monthHeader(month)
                }
                return .dayOfWeekInMonth(position: nextPosition, month: month)
            }
        case .day(let day):
            let nextDay = calendar.day(byAddingDays: 1, to: day)
            if day.month != nextDay.month {
                return .monthHeader(nextDay.month)
            } else if day == dayRange.upperBound {
                let nextMonth = calendar.month(byAddingMonths: 1, to: nextDay.month)
                return .monthHeader(nextMonth)
            } else {
                return .day(nextDay)
            }
        case .emptyDate(let day):
            return .emptyDate(day)
        }
    }
    
    private func firstDayInRange(in month: MonthComponents) -> DayComponents {
        let firstDate = calendar.firstDate(of: month)
        let firstDay = calendar.day(containing: firstDate)
        
        if month == dayRange.lowerBound.month {
            return max(firstDay, dayRange.lowerBound)
        }
        return firstDay
    }
}
