//
//  ACCalendarDateSelectionProtocol.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 30.08.2022.
//

import Foundation

/// Protocol for selecting dates.
public protocol ACCalendarDateSelectionProtocol {
    
    /// Unique name.
    var name: ACCalendarDateSelectionName { get }
    
    /// Current calendar.
    var calendar: Calendar { get set }
    
    /// Selected dates.
    var datesSelected: [Date] { get set }
    
    /// Allows you to deselect.
    var allowsDeselect: Bool { get set }
    
    /// Allows you to determine what `ACCalendarDateSelectionType` of selection the date belongs to.
    func dateSelected(_ date: Date) -> ACCalendarDateSelectionType
    
    /// Method changing datesSelected.
    mutating func dateSelect(_ date: Date)
}
