//
//  ACCalendarHorizontalLayout.swift
//  ACUICalendar
//

import Foundation

open class ACCalendarHorizontalLayout: ACMonthsLayout {
    
    open var maximumFullyVisibleMonths: Double = 1

    open var scrollDirection: ACCalendarScrollDirection {
        .vertical
    }
    
    open var scrollsToFirstMonthOnStatusBarTap: Bool {
        false
    }
    
    open var isPaginationEnabled: Bool {
        true
    }
    
    open func monthWidth(calendarWidth: CGFloat, interMonthSpacing: CGFloat) -> CGFloat {
        let visibleInterMonthSpacing = CGFloat(maximumFullyVisibleMonths) * interMonthSpacing
        return (calendarWidth - visibleInterMonthSpacing) / CGFloat(maximumFullyVisibleMonths)
    }
    
    open func pageSize(calendarWidth: CGFloat, interMonthSpacing: CGFloat) -> CGFloat {
        let monthWidth = monthWidth(
            calendarWidth: calendarWidth,
            interMonthSpacing: interMonthSpacing
        )
        return monthWidth + interMonthSpacing
    }
    
    public init() {}
}
