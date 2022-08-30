//
//  ACCalendarRangeDateSelection.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 30.08.2022.
//

import Foundation

public struct ACCalendarRangeDateSelection: ACCalendarDateSelectionProtocol {
    
    public var datesSelected: [Date] = []
    
    public mutating func dateSelecting(_ date: Date, calendar: Calendar, belongsToMonth: ACCalendarBelongsToMonth) {
        guard belongsToMonth == .current else { return }
    
        if let first = self.datesSelected.first, first.isEqual(to: date, toGranularity: .day, calendar: calendar) {
            self.datesSelected = Array(self.datesSelected.dropFirst())
        } else if let last = self.datesSelected.last, last.isEqual(to: date, toGranularity: .day, calendar: calendar) {
            self.datesSelected = Array(self.datesSelected.dropLast())
        } else if let first = self.datesSelected.first, date.isLess(than: first, toGranularity: .day, calendar: calendar), let last = self.datesSelected.last {
            self.datesSelected = self.generateDatesRange(from: date, to: last, calendar: calendar)
        } else if let first = self.datesSelected.first, date.isGreater(than: first, toGranularity: .day, calendar: calendar) {
            self.datesSelected = self.generateDatesRange(from: first, to: date, calendar: calendar)
        } else {
            self.datesSelected = [date]
        }
    }
    
    public func generateDatesRange(from startDate: Date, to endDate: Date, calendar: Calendar) -> [Date] {
        var currentDate: Date = startDate
        var result: [Date] = []
        
        while currentDate.isLess(than: endDate, toGranularity: .day, calendar: calendar) || currentDate.isEqual(to: endDate, toGranularity: .day, calendar: calendar) {
            result += [currentDate]
            
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return result
    }
    
}
