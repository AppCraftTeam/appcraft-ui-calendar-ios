//
//  ACMonthsLayout.swift
//  ACUICalendar
//

import Foundation

public protocol ACMonthsLayout {
    var scrollDirection: ACCalendarScrollDirection { get }
    var scrollsToFirstMonthOnStatusBarTap: Bool { get }
    var isPaginationEnabled: Bool { get }
    
    func monthWidth(calendarWidth: CGFloat, interMonthSpacing: CGFloat) -> CGFloat
    func pageSize(calendarWidth: CGFloat, interMonthSpacing: CGFloat) -> CGFloat
}
