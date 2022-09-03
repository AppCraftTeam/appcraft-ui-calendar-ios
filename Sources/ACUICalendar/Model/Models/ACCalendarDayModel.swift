//
//  ACCalendarDayModel.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation

public struct ACCalendarDayModel {
    public let day: Int
    public let dayDate: Date
    public let dayDateText: String
    public let belongsToMonth: ACCalendarBelongsToMonth
}
