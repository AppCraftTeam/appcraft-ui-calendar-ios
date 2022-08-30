//
//  ACCalendarDateSelectionProtocol.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 30.08.2022.
//

import Foundation

public protocol ACCalendarDateSelectionProtocol {
    var datesSelected: [Date] { get set }
    
    func dateSelected(_ date: Date, calendar: Calendar) -> ACCalendarDateSelectionType
    mutating func dateSelecting(_ date: Date, calendar: Calendar, belongsToMonth: ACCalendarBelongsToMonth)
}

public extension ACCalendarDateSelectionProtocol {
    
    func dateSelected(_ date: Date, calendar: Calendar) -> ACCalendarDateSelectionType {
        if let first = self.datesSelected.first, first.isEqual(to: date, toGranularity: .day, calendar: calendar) {
            return .startOfRange
        } else if let last = self.datesSelected.last, last.isEqual(to: date, toGranularity: .day, calendar: calendar) {
            return .endOfRange
        } else if self.datesSelected.contains(where: { $0.isEqual(to: date, toGranularity: .day, calendar: calendar) }) {
            return .middleOfRange
        } else {
            return .notSelected
        }
    }
    
}
