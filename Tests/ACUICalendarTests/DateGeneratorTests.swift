import XCTest
@testable import ACUICalendar

final class MonthsGeneratorTests: XCTestCase {
    
    func testMonthGeneration() {
        let generator = MonthGenerator(calendar: Calendar.current)
        let currentDate = Calendar.current.date(
            from: DateComponents(year: 2007, month: 1, day: 1)
        )!
        
        let month = generator.generateMonth(for: currentDate)!
        
        var febDay = 0
        let expectedModel = ACCalendarMonthModel(
            month: 1,
            monthDate: Calendar.current.date(
                from: DateComponents(year: 2006, month: 12, day: 31)
            )!,
            monthDates: (0...32).map({ day in
                if day == 0 {
                    return Calendar.current.date(
                        from: DateComponents(year: 2006, month: 12, day: 31)
                    )!
                } else {
                    return Calendar.current.date(
                        from: DateComponents(year: 2007, month: 1, day: day)
                    )!
                }
            }),
            previousMonthDates: [],
            nextMonthDates: (0...5).map({ idx in
                if idx == 0 {
                    return Calendar.current.date(
                        from: DateComponents(year: 2007, month: 31, day: 1)
                    )!
                } else {
                    return  Calendar.current.date(
                        from: DateComponents(year: 2007, month: 02, day: idx)
                    )!
                }
            }),
            days: (0...34).map({ day in
                let dayDate = {
                    var febDay = 1
                    if day == 0 {
                        return Calendar.current.date(
                            from: DateComponents(year: 2006, month: 12, day: 31, hour: 24)
                        )!
                    }
                    else if day >= 31 {
                        let date = Calendar.current.date(
                            from: DateComponents(year: 2007, month: febDay, day: day, hour: 24)
                        )!
                        febDay += 1
                        return date
                    }
                    else {
                        return Calendar.current.date(
                            from: DateComponents(year: 2007, month: 1, day: day, hour: 24)
                        )!
                    }
                }()
                let dayNumber: Int = {
                    if day == 0 {
                        return 1
                    }
                    else if day >= 31 {
                        febDay += 1
                        return febDay
                    }
                    else {
                       return day + 1
                    }
                }()
                return .init(day: dayNumber, dayDate: dayDate, dayDateText: "\(dayNumber)", belongsToMonth: .current)
            })
        )
        
        XCTAssertEqual(month.days, expectedModel.days)
        XCTAssertEqual(month.month, expectedModel.month)
        XCTAssertEqual(month.monthDate, expectedModel.monthDate)
        XCTAssertEqual(month.monthDates, expectedModel.monthDates)
        XCTAssertEqual(month.nextMonthDates, expectedModel.nextMonthDates)
        XCTAssertEqual(month.previousMonthDates, expectedModel.previousMonthDates)
    }
}

final class PastMonthsGeneratorTests: XCTestCase {
    
    func testCorrectnessGenerationOfMonths() {
        let currentDate = Calendar.current.date(
            from: DateComponents(year: 2007, month: 5, day: 1)
        )!
        let generator = PastMonthGenerator(calendar: Calendar.current, currentDate: currentDate)
        
        generator.next()
        generator.next()
        generator.next()
        
        XCTAssertEqual(generator.months.map(\.month), [2,3,4])
    }

    func testLimitGenerationOfMonths() {
        let minDate = Calendar.current.date(
            from: DateComponents(year: 2007, month: 2, day: 1)
        )!
        let currentDate = Calendar.current.date(
            from: DateComponents(year: 2007, month: 5, day: 1)
        )!
        let generator = PastMonthGenerator(calendar: Calendar.current, currentDate: currentDate, minDate: minDate)
        for _ in 0...5 {
            generator.next()
        }
        XCTAssertEqual(generator.months.map(\.month), [2,3,4])
    }
}

final class FutureMontsGeneratorTests: XCTestCase {
    
    func testCorrectnessGenerationOfMonths() {
        let currentDate = Calendar.current.date(
            from: DateComponents(year: 2007, month: 5, day: 1)
        )!
        let generator = FutureMonthGenerator(calendar: Calendar.current, currentDate: currentDate)
        
        generator.next()
        generator.next()
        generator.next()
        
        XCTAssertEqual(generator.months.map(\.month), [5, 6, 7, 8])
    }

    func testLimitGenerationOfMonths() {
        let maxDate = Calendar.current.date(
            from: DateComponents(year: 2007, month: 8, day: 31)
        )!
        let currentDate = Calendar.current.date(
            from: DateComponents(year: 2007, month: 5, day: 1)
        )!
        let generator = FutureMonthGenerator(calendar: Calendar.current, currentDate: currentDate, maxDate: maxDate)
        
        for _ in 0...5 {
            generator.next()
        }
        
        XCTAssertEqual(generator.months.map(\.month), [5,6,7,8])
    }
}
