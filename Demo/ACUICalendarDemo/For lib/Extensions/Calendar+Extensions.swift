//
//  Calendar+Extensions.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 25.08.2022.
//

import Foundation
import DPSwift

public extension Calendar {
    
    static func defaultACCalendar() -> Calendar {
        var calendar = Calendar.current
        calendar.firstDPWeekDay = .monday
        
        return calendar
    }
    
}
