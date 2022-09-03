//
//  ACCalendarDateSelectionProtocol.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 30.08.2022.
//

import Foundation

public protocol ACCalendarDateSelectionProtocol {
    var name: ACCalendarDateSelectionName { get }
    var calendar: Calendar { get set }
    var datesSelected: [Date] { get set }
    var allowsDeselect: Bool { get set }
    
    func dateSelected(_ date: Date) -> ACCalendarDateSelectionType
    mutating func dateSelect(_ date: Date)
}
