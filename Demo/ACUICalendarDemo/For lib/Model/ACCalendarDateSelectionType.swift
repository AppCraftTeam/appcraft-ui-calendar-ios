//
//  ACCalendarDateSelectionType.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 29.08.2022.
//

import Foundation

public enum ACCalendarDateSelectionType {
    case startOfRange
    case endOfRange
    case middleOfRange
    case notSelected
    
    var isSelected: Bool {
        self != .notSelected
    }
}
