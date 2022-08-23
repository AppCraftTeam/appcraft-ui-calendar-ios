//
//  Calendar+Extensions.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 23.08.2022.
//

import Foundation

public extension Calendar {
    
    func startOfMonth(for monthDate: Date) -> Date? {
        let date = self.startOfDay(for: monthDate)
        
        return self.date(from: self.dateComponents([.year, .month], from: date))
    }
    
    func endOfMonth(for monthDate: Date) -> Date? {
        let date = self.startOfDay(for: monthDate)
        guard let startOfMonth = self.startOfMonth(for: date) else { return nil }
        
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
    }
    
    func monthDates(for monthDate: Date) -> [Date]? {
        let date = self.startOfDay(for: monthDate)
        
        guard
            let startOfMonth = self.startOfMonth(for: date),
            let endOfMonth = self.endOfMonth(for: date)
        else { return nil }
        
        var result: [Date] = []
        var nextDate = startOfMonth
        
        var startCondition: Bool {
            let compare = nextDate.compare(startOfMonth)
            let condition = compare == .orderedDescending || compare == .orderedSame
            
            return condition
        }
        
        var endCondition: Bool {
            let compare = nextDate.compare(endOfMonth)
            let condition = compare == .orderedAscending || compare == .orderedSame
            
            return condition
        }
        
        while startCondition && endCondition {
            result += [nextDate]
            
            guard let dateAddingDay = self.date(byAdding: .day, value: 1, to: nextDate) else { break }
            nextDate = dateAddingDay
        }
        
        return result
    }
    
    func weekDatesOfStartOfMonthWithoutCurrentMonth(for monthDate: Date) -> [Date]? {
        let date = self.startOfDay(for: monthDate)
        
        guard
            let startOfMonth = self.startOfMonth(for: date),
            let previousStartOfMonth = self.date(byAdding: .day, value: -1, to: startOfMonth)
        else { return nil }
        
        var result: [Date] = []
        var nextDate = previousStartOfMonth
        
        while self.component(.weekOfYear, from: startOfMonth) == self.component(.weekOfYear, from: nextDate) {
            result += [nextDate]
            
            guard let dateAddingDay = self.date(byAdding: .day, value: -1, to: nextDate) else { break }
            nextDate = dateAddingDay
        }
        
        return result
    }
    
    func weekDatesOfEndOfMonthWithoutCurrentMonth(for monthDate: Date) -> [Date]? {
        let date = self.startOfDay(for: monthDate)
        
        guard
            let endOfMonth = self.endOfMonth(for: date),
            let nextEndOfMonth = self.date(byAdding: .day, value: 1, to: endOfMonth)
        else { return nil }
        
        var result: [Date] = []
        var nextDate = nextEndOfMonth
        
        while self.component(.weekOfYear, from: endOfMonth) == self.component(.weekOfYear, from: nextDate) {
            result += [nextDate]
            
            guard let dateAddingDay = self.date(byAdding: .day, value: 1, to: nextDate) else { break }
            nextDate = dateAddingDay
        }
        
        return result
    }
    
}
