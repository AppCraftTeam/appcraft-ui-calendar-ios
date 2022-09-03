//
//  ACCalendarDateSelectionName.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 03.09.2022.
//

import Foundation

public struct ACCalendarDateSelectionName: Equatable {
    public let identifer: String
}

public extension ACCalendarDateSelectionName {
    static let single = ACCalendarDateSelectionName(identifer: "single")
    static let multi = ACCalendarDateSelectionName(identifer: "multi")
    static let range = ACCalendarDateSelectionName(identifer: "range")
}
