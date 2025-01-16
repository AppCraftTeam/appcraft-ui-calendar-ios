//
//  LayoutItem.swift
//  ACUICalendar
//

import Foundation

public struct LayoutItem {
    public let itemType: ItemType
    public let frame: CGRect
    
    public enum ItemType: Equatable, Hashable {
        case monthHeader(MonthComponents)
        case dayOfWeekInMonth(position: WeekdayPosition, month: MonthComponents)
        case day(DayComponents)
        case emptyDate(DayComponents)
        
        var month: MonthComponents {
            switch self {
            case .monthHeader(let month):
                return month
            case .dayOfWeekInMonth(_, let month):
                return month
            case .day(let day):
                return day.month
            case .emptyDate(let day):
                return day.month
            }
        }
    }
}

extension LayoutItem.ItemType: Comparable {
    
    static public func < (lhs: LayoutItem.ItemType, rhs: LayoutItem.ItemType) -> Bool {
        switch (lhs, rhs) {
        case let (.monthHeader(lhsMonth), .monthHeader(rhsMonth)):
            return lhsMonth < rhsMonth
        case let (.monthHeader(lhsMonth), .dayOfWeekInMonth(_, rhsMonth)):
            return lhsMonth <= rhsMonth
        case let (.monthHeader(lhsMonth), .day(rhsDay)):
            return lhsMonth <= rhsDay.month
        case let (.dayOfWeekInMonth(lhsPosition, lhsMonth), .dayOfWeekInMonth(rhsPosition, rhsMonth)):
            return lhsMonth < rhsMonth || (lhsMonth == rhsMonth && lhsPosition < rhsPosition)
        case let (.dayOfWeekInMonth(_, lhsMonth), .monthHeader(rhsMonth)):
            return lhsMonth < rhsMonth
        case let (.dayOfWeekInMonth(_, lhsMonth), .day(rhsDay)):
            return lhsMonth <= rhsDay.month
        case let (.day(lhsDay), .day(rhsDay)):
            return lhsDay < rhsDay
        case let (.day(lhsDay), .monthHeader(rhsMonth)):
            return lhsDay.month < rhsMonth
        case let (.day(lhsDay), .dayOfWeekInMonth(_, rhsMonth)):
            return lhsDay.month < rhsMonth
        case (.emptyDate(_), _):
            return true
        case (_, .emptyDate(_)):
            return true
        }
    }
}
