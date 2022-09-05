//
//  ACCalendarDateSelectionName.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 03.09.2022.
//

import Foundation

/// Special structure to support uniqueness and comparison of structures corresponding to the `ACCalendarDateSelectionProtocol` protocol.
public struct ACCalendarDateSelectionName: Equatable {
    
    /// Unique identificator.
    public let identifer: String
}

// MARK: - Store
public extension ACCalendarDateSelectionName {
    static let single = ACCalendarDateSelectionName(identifer: "single")
    static let multi = ACCalendarDateSelectionName(identifer: "multi")
    static let range = ACCalendarDateSelectionName(identifer: "range")
}
