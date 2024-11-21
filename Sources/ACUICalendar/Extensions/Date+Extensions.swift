//
//  Date+Extensions.swift
//
//
//  Created by Pavel Moslienko on 17.09.2024.
//

import Foundation

extension Date {
    
    func yearsToDate(endDate: Date,
                          calendar: Calendar = Calendar.current
    ) -> Int {
        calendar.dateComponents([.year], from: self, to: endDate).year ?? 0
    }
}
