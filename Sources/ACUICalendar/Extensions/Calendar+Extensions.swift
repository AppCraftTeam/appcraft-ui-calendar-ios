//
//  Calendar+Extensions.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 25.08.2022.
//

import Foundation
import DPSwift

public extension Calendar {
    
    /// Default calendar with Monday as the first day of the week
    ///
    static func defaultACCalendar() -> Calendar {
        var calendar = Calendar.current
        calendar.firstDPWeekDay = .monday
        calendar.locale = .current
        
        return calendar
    }
    
}
