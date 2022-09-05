//
//  ACCalendarSingleDateSelection.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 30.08.2022.
//

import Foundation

/// Selecting only one date.
public struct ACCalendarSingleDateSelection: ACCalendarDateSelectionProtocol {
    
    // MARK: - Init
    public init(calendar: Calendar, datesSelected: [Date], allowsDeselect: Bool = true) {
        self.calendar = calendar
        self.datesSelected = datesSelected
        self.allowsDeselect = allowsDeselect
        
        self.updateComponents()
    }
    
    // MARK: - Props
    public let name: ACCalendarDateSelectionName = .single
    
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
            self.datesSelected = [date]
        }
    }
    
    public mutating func updateComponents() {
        guard self.datesSelected.count > 1, let first = self.datesSelected.first else { return }
        self.datesSelected = [first]
    }
    
}
