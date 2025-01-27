//
//  CalendarScrollPosition.swift
//  ACUICalendar
//

import Foundation

public enum CalendarScrollPosition {
    case centered
    case firstFullyVisible(padding: CGFloat)
    case lastFullyVisible(padding: CGFloat)
}

public extension CalendarScrollPosition {
    static let firstFullyVisible: CalendarScrollPosition = .firstFullyVisible(padding: 0)
    static let lastFullyVisible: CalendarScrollPosition = .lastFullyVisible(padding: 0)
}
