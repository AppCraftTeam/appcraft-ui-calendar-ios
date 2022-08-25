//
//  ACCalendarDayModel.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation

public struct ACCalendarDayModel {
    
    // MARK: - Init
    public init(date: Date, belongsToMonth: ACCalendarBelongsToMonth) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        self.dayDate = date
        self.dayDateText = formatter.string(from: date)
        self.belongsToMonth = belongsToMonth
    }
    
    // MARK: - Props
    public let dayDate: Date
    public let dayDateText: String
    public let belongsToMonth: ACCalendarBelongsToMonth
    
}
