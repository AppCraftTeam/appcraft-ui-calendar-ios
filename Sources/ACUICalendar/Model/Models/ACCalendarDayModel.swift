//
//  ACCalendarDayModel.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation

/// Model for describing a calendar day.
public struct ACCalendarDayModel {
    
    /// Day number.
    public let day: Int
    
    /// Day date.
    public let dayDate: Date
    
    /// The displayed value of the day.
    public let dayDateText: String
    
    /// Month match.
    public let belongsToMonth: ACCalendarBelongsToMonth
}
