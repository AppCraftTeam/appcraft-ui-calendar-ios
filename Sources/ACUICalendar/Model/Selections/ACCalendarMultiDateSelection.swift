//
//  ACCalendarMultiDateSelection.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 03.09.2022.
//

import Foundation

public struct ACCalendarMultiDateSelection: ACCalendarDateSelectionProtocol {
    
    // MARK: - Init
    public init(calendar: Calendar, datesSelected: [Date], allowsDeselect: Bool = true) {
        self.calendar = calendar
        self.datesSelected = datesSelected
        self.allowsDeselect = allowsDeselect
        
        self.updateComponents()
    }
    
    // MARK: - Props
    public let name: ACCalendarDateSelectionName = .multi
    
    public var calendar: Calendar {
        didSet { self.updateComponents() }
    }
    
    public var datesSelected: [Date] = [] {
        didSet { self.updateComponents() }
    }
    
    public var allowsDeselect: Bool {
        didSet { self.updateComponents() }
    }
    
    // MARK: - Methods
    public func dateSelected(_ date: Date) -> ACCalendarDateSelectionType {
        if self.datesSelected.contains(where: { $0.isEqual(to: date, toGranularity: .day, calendar: self.calendar) }) {
            return .startOfRange
        } else {
            return .notSelected
        }
    }
    
    public mutating func dateSelect(_ date: Date) {
        if let index = self.datesSelected.firstIndex(where: { $0.isEqual(to: date, toGranularity: .day, calendar: self.calendar) }), self.allowsDeselect {
            self.datesSelected.remove(at: index)
        } else {
            self.datesSelected.append(date)
        }
    }
    
    public mutating func updateComponents() {
        var datesSelected = self.datesSelected
        datesSelected.removeDuplicates()
        datesSelected.sort()
        
        if self.datesSelected != datesSelected {
            self.datesSelected = datesSelected
        }
    }
    
}
