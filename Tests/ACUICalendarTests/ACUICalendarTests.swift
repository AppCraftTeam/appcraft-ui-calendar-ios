import XCTest
@testable import ACUICalendar

final class ACUICalendarTests: XCTestCase {

}

@discardableResult
func TimeMeasure<T>(_ title: String = #function, block: (@escaping () -> ()) -> T) -> T {
    
    let startTime = DispatchTime.now().uptimeNanoseconds
    
    return block {
        let timeElapsed = Double(DispatchTime.now().uptimeNanoseconds - startTime) / 1e9
        
        NSLog("[Measure] - [\(title)]: Time: \(timeElapsed) seconds")
    }
}
