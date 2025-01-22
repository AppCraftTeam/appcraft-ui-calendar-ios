//
//  ACCalendarVerticalLayout.swift
//  ACUICalendar
//

import Foundation

open class ACCalendarVerticalLayout: ACMonthsLayout {
    
    open var scrollDirection: ACCalendarScrollDirection {
        .vertical
    }
    
    open var scrollsToFirstMonthOnStatusBarTap: Bool {
        true
    }
    
    open var isPaginationEnabled: Bool {
        true
    }
    
    open func monthWidth(calendarWidth: CGFloat, interMonthSpacing: CGFloat) -> CGFloat {
        calendarWidth
    }
    
    open func pageSize(calendarWidth: CGFloat, interMonthSpacing: CGFloat) -> CGFloat {
        calendarWidth
    }
    
    public init() {}
}
