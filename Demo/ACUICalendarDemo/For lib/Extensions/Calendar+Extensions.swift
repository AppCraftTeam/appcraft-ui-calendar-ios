//
//  Calendar+Extensions.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 25.08.2022.
//

import Foundation

public extension Calendar {
    
    static func defaultACCalendar() -> Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        return calendar
    }
    
}
