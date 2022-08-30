//
//  ACCalendarSingleDateSelection.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 30.08.2022.
//

import Foundation

public struct ACCalendarSingleDateSelection: ACCalendarDateSelectionProtocol {
    
    public var datesSelected: [Date] = []
    
    public mutating func dateSelecting(_ date: Date, calendar: Calendar, belongsToMonth: ACCalendarBelongsToMonth) {
        guard belongsToMonth == .current else { return }
        self.datesSelected = [date]
    }
    
}
