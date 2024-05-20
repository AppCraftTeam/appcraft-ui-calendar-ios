import XCTest
@testable import ACUICalendar

final class ACUICalendarTests: XCTestCase {

}

func TimeMeasure(_ title: String = #function, block: (@escaping () -> ()) -> ()) {
    
    let startTime = DispatchTime.now().uptimeNanoseconds
    
    block {
        let timeElapsed = Double(DispatchTime.now().uptimeNanoseconds - startTime) / 1e9
        
        NSLog("[Measure] - [\(title)]: Time: \(timeElapsed) seconds")
    }
}
