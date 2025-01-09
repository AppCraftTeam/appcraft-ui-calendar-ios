//
//  DayOfWeekPosition.swift
//  ACUICalendar
//

import Foundation

public enum WeekdayPosition: Int, CaseIterable, Hashable {
    case first = 1
    case second
    case third
    case fourth
    case fifth
    case sixth
    case last = 7

    static let totalPositions = 7
}

extension WeekdayPosition: Comparable {
    public static func < (lhs: WeekdayPosition, rhs: WeekdayPosition) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
