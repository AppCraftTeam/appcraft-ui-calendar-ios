//
//  ACCalendarScrollOptions.swift
//  ACUICalendar
//

import Foundation

public struct ACCalendarScrollOptions {
    
    public enum TargetItem {
        case month(MonthComponents)
        case day(DayComponents)
    }
    
    public enum Position {
        case before
        case after
        case visible(rect: CGRect)
    }
    
    public let targetItem: TargetItem
    public let scrollPosition: CalendarScrollPosition
    public let isAnimated: Bool
    
    public init(
        targetItem: ACCalendarScrollOptions.TargetItem,
        scrollPosition: CalendarScrollPosition,
        isAnimated: Bool
    ) {
        self.targetItem = targetItem
        self.scrollPosition = scrollPosition
        self.isAnimated = isAnimated
    }
}
