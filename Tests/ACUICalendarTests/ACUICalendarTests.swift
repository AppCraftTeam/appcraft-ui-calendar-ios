import XCTest
@testable import ACUICalendar

final class ACUICalendarTests: XCTestCase {
    func testLeftMonthIterator() {
        let calendar: Calendar = .defaultACCalendar()
        let currentDate = Date()
        
        let iterator = PastMonthGenerator(
            calendar: calendar,
            currentDate: currentDate,
            minDate: nil
        )
        let first = iterator.next()
        let second = iterator.next()
        let third = iterator.next()
        

    }
    func testLeftMonthGenerator() {
//        let calendar: Calendar = .defaultACCalendar()
//        let currentDate = Date()
//        let service = ACCalendarService(
//            calendar: calendar,
//            minDate: calendar.date(byAdding: .year, value: -2, to: currentDate) ?? currentDate,
//            maxDate: calendar.date(byAdding: .year, value: 1, to: currentDate) ?? currentDate,
//            currentMonthDate: currentDate,
//            selection: ACCalendarSingleDateSelection(
//                calendar: calendar,
//                datesSelected: []
//            )
//        )
//        func montToDateComponents(_ month: ACCalendarMonthModel) -> DateComponents {
//            Calendar.current.dateComponents([.year, .month], from: month.monthDate)
//        }
//        let leftMonths = service.nextLeftMonth()
//        let leftMonthsComponents = leftMonths.map(montToDateComponents)
//        let originMonthComponents = service.months.map(montToDateComponents)
//        
//        XCTAssertEqual(leftMonthsComponents.last?.month, (originMonthComponents.first?.month ?? 0) - 1)
//        
//        service.months.insert(contentsOf: leftMonths, at: 0)
//        
//        let leftMonthsIter2 = service.nextLeftMonth()
//        let leftMonthsComponents2 = leftMonths.map(montToDateComponents)
//        let originMonthComponents2 = service.months.map(montToDateComponents)
//        
//        XCTAssertEqual(leftMonthsComponents.last?.month, (originMonthComponents.first?.month ?? 0) - 1)
    }
    
    func test_simple() {
            let calendar: Calendar = .defaultACCalendar()
            let currentDate = Date()
        TimeMeasure { block in
            let service = ACCalendarService(
                calendar: calendar,
                minDate: calendar.date(
                    byAdding: .year,
                    value: -180,
                    to: currentDate
                ) ?? currentDate,
                maxDate: calendar.date(
                    byAdding: .year,
                    value: 1,
                    to: currentDate
                ) ?? currentDate,
                currentMonthDate: currentDate,
                selection: ACCalendarSingleDateSelection(
                    calendar: calendar,
                    datesSelected: []
                )
            )
            block()
        }
  
//        for year in service.years {
//            print("Year: \(year.year), \(year.yearDate), months: \(year.months.count)")
//            for month in year.months {
//                print(" Month: \(month.month), \(month.monthDate), days: \(month.days.count)")
//                for day in month.days {
//                    print("     Day: \(day.day), \(day.dayDate)")
//                }
//            }
//        }
        XCTAssert(true)
    }
}

func memoryUsage() -> (UInt64, UInt64) {
    var taskInfo = task_vm_info_data_t()
    var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
    let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
        }
    }
    
    var used: UInt64 = 0
    if result == KERN_SUCCESS {
        used = UInt64(taskInfo.phys_footprint)
    }
    
    let total = ProcessInfo.processInfo.physicalMemory
    return (used, total)
}

func memoryUsageStringDecorator(_ proxyBlock: () -> (UInt64, UInt64)) -> String {
    let data = proxyBlock()
    let bytesInMegabyte = 1024.0 * 1024.0
    let usedMemory = Double(data.0) / bytesInMegabyte
    let totalMemory = Double(data.1) / bytesInMegabyte
    return  String(format: "%.1f of %.0f MB used", usedMemory, totalMemory)
}

func TimeMeasure(_ title: String = #function, block: (@escaping () -> ()) -> ()) {
    
    let startTime = DispatchTime.now().uptimeNanoseconds
    
    block {
        let timeElapsed = Double(DispatchTime.now().uptimeNanoseconds - startTime) / 1e9
        
        NSLog("[Measure] - [\(title)]: Time: \(timeElapsed) seconds")
    }
}
