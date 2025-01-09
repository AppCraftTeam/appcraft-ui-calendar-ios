//
//  Foundation+Extension.swift
//  ACUICalendar
//

import Foundation

extension Calendar {
    
    func month(containing date: Date) -> MonthComponents {
        MonthComponents(
            era: component(.era, from: date),
            year: component(.year, from: date),
            month: component(.month, from: date),
            isGregorian: identifier == .gregorian
        )
    }
    
    func firstDate(of month: MonthComponents) -> Date {
        date(from: month.components) ?? Date()
    }
    
    func lastDate(of month: MonthComponents) -> Date {
        let firstDate = firstDate(of: month)
        guard let numberOfDaysInMonth = range(of: .day, in: .month, for: firstDate)?.count else {
            return Date()
        }
        
        let lastDateComponents = DateComponents(
            era: month.era,
            year: month.year,
            month: month.month,
            day: numberOfDaysInMonth
        )
        guard let lastDate = date(from: lastDateComponents) else {
            return Date()
        }
        
        return lastDate
    }
    
    func month(byAddingMonths numberOfMonths: Int, to month: MonthComponents) -> MonthComponents {
        guard let firstDateOfNextMonth = date(
            byAdding: .month,
            value: numberOfMonths,
            to: firstDate(of: month)
        ) else {
            return month
        }
        
        return self.month(containing: firstDateOfNextMonth)
    }
    
    func day(containing date: Date) -> DayComponents {
        let month = MonthComponents(
            era: component(.era, from: date),
            year: component(.year, from: date),
            month: component(.month, from: date),
            isGregorian: identifier == .gregorian
        )
        return DayComponents(month: month, day: component(.day, from: date))
    }
    
    func startDate(of day: DayComponents) -> Date {
        date(from: day.components) ?? Date()
    }
    
    func day(byAddingDays numberOfDays: Int, to day: DayComponents) -> DayComponents {
        guard let firstDateOfNextDay = date(byAdding: .day, value: numberOfDays, to: startDate(of: day)) else {
            return day
        }
        
        return self.day(containing: firstDateOfNextDay)
    }
    
    func dayOfWeekPosition(for date: Date) -> WeekdayPosition {
        let weekdayComponent = component(.weekday, from: date)
        let distanceFromFirstWeekday = firstWeekday - weekdayComponent
        
        let numberOfPositions = WeekdayPosition.totalPositions
        let weekdayIndex = (numberOfPositions - distanceFromFirstWeekday) % numberOfPositions
        
        guard let dayOfWeekPosition = WeekdayPosition(rawValue: weekdayIndex + 1) else {
            return .first
        }
        
        return dayOfWeekPosition
    }
    
    func weekdayIndex(for dayOfWeekPosition: WeekdayPosition) -> Int {
        let indexOfFirstWeekday = firstWeekday - 1
        let numberOfWeekdays = WeekdayPosition.totalPositions
        let weekdayIndex = (indexOfFirstWeekday + (dayOfWeekPosition.rawValue - 1)) % numberOfWeekdays
        
        return weekdayIndex
    }
    
    func rowInMonth(for date: Date) -> Int {
        let firstDateOfMonth = firstDate(
            of: MonthComponents(
                era: component(.era, from: date),
                year: component(.year, from: date),
                month: component(.month, from: date),
                isGregorian: identifier == .gregorian
            )
        )
        
        let numberOfPositions = WeekdayPosition.totalPositions
        let dayOfWeekPosition = dayOfWeekPosition(for: firstDateOfMonth)
        let daysFromEndOfWeek = numberOfPositions - (dayOfWeekPosition.rawValue - 1)
        let isFirstDayInFirstWeek = daysFromEndOfWeek >= minimumDaysInFirstWeek
        
        let row = component(.weekOfMonth, from: date)
        return isFirstDayInFirstWeek ? row - 1 : row
    }
}
