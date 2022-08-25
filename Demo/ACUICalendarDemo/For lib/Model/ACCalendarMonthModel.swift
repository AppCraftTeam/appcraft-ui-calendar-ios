//
//  ACCalendarMonthModel.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation

public struct ACCalendarMonthModel {
    public let monthDate: Date
    public let monthDates: [Date]
    public let previousMonthDates: [Date]
    public let nextMonthDates: [Date]
    public let days: [ACCalendarDayModel]
}
