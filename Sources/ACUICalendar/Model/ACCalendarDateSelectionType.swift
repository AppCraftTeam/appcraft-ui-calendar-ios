//
//  ACCalendarDateSelectionType.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 29.08.2022.
//

import Foundation

/// Specifies which selection type the day is
public enum ACCalendarDateSelectionType {
    
    /// The date is selected and is at the start of the range. If there is only one date, then this value will be returned.
    case startOfRange
    
    /// The date is selected and is at the end of the range.
    case endOfRange
    
    /// The date is selected and is between the start and end of the range.
    case middleOfRange
    
    /// Date not selected.
    case notSelected
    
    /// Date cannot be selected
    case notAvailableSelect
}
