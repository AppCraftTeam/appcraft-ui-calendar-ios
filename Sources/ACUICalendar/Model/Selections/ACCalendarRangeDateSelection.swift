//
//  ACCalendarRangeDateSelection.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 30.08.2022.
//

import Foundation

/// Select date range. Dates go strictly from smallest to largest in order.
public struct ACCalendarRangeDateSelection: ACCalendarDateSelectionProtocol {
    
    // MARK: - Init
    public init(calendar: Calendar, datesSelected: [Date]) {
        self.calendar = calendar
        self.datesSelected = datesSelected
        
        self.updateComponents()
    }
    
    // MARK: - Props
    public let name: ACCalendarDateSelectionName = .range
    
    public var calendar: Calendar {
        didSet { self.updateComponents() }
    }
    
    public var datesSelected: [Date] = [] {
        didSet { self.updateComponents() }
    }
    
    public var allowsDeselect: Bool = true
    
    // MARK: - Methods
    public func dateSelected(_ date: Date) -> ACCalendarDateSelectionType {
        if let first = self.datesSelected.first, first.isEqual(to: date, toGranularity: .day, calendar: self.calendar) {
            return .startOfRange
        } else if let last = self.datesSelected.last, last.isEqual(to: date, toGranularity: .day, calendar: self.calendar) {
            return .endOfRange
        } else if self.datesSelected.contains(where: { $0.isEqual(to: date, toGranularity: .day, calendar: self.calendar) }) {
            return .middleOfRange
        } else {
            return .notSelected
        }
    }
    
    public mutating func dateSelect(_ date: Date) {
        if let first = self.datesSelected.first, first.isEqual(to: date, toGranularity: .day, calendar: self.calendar) {
            self.datesSelected = Array(self.datesSelected.dropFirst())
        } else if let last = self.datesSelected.last, last.isEqual(to: date, toGranularity: .day, calendar: self.calendar) {
            self.datesSelected = Array(self.datesSelected.dropLast())
        } else if let first = self.datesSelected.first, date.isLess(than: first, toGranularity: .day, calendar: self.calendar), let last = self.datesSelected.last {
            self.datesSelected = self.generateDatesRange(from: date, to: last)
        } else if let first = self.datesSelected.first, date.isGreater(than: first, toGranularity: .day, calendar: self.calendar) {
            self.datesSelected = self.generateDatesRange(from: first, to: date)
        } else {
            self.datesSelected = [date]
        }
    }
    
    public mutating func updateComponents() {
        let dates = self.datesSelected.removingDuplicates().sorted()
        
        if let first = dates.first, let last = dates.last, first != last {
            let datesRange = self.generateDatesRange(from: first, to: last)
            
            if self.datesSelected != datesRange {
                self.datesSelected = datesRange
            }
        }
    }
    
    public func generateDatesRange(from startDate: Date, to endDate: Date) -> [Date] {
        var currentDate: Date = startDate
        var result: [Date] = []
        
        while currentDate.isLess(than: endDate, toGranularity: .day, calendar: self.calendar) || currentDate.isEqual(to: endDate, toGranularity: .day, calendar: self.calendar) {
            result += [currentDate]
            
            guard let nextDate = self.calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return result
    }
    
}
