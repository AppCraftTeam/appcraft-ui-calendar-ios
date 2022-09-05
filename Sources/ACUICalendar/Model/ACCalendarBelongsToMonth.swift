//
//  ACCalendarBelongsToMonth.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation

/// Match type of calendar day to calendar month.
public enum ACCalendarBelongsToMonth {
    
    /// The day belongs to the current month.
    case current
    
    /// A day belongs to the previous month if the current month does not start on the first day of the week.
    case previous
    
    /// A day belongs to the next month if the current month does not end on the last day of the week.
    case next
}
