//
//  ACCalendarYearModel.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 30.08.2022.
//

import Foundation

/// Model for describing a calendar year.
public struct ACCalendarYearModel {
    
    /// Year number.
    public let year: Int
    
    /// Year date.
    public let yearDate: Date
    
    /// All calendar months of the year.
    public let months: [ACCalendarMonthModel]
}
