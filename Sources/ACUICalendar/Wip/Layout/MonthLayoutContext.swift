//
//  MonthLayoutContext.swift
//  ACUICalendar
//

import Foundation

public struct MonthLayoutContext: Hashable {
    
    public struct DayOfWeekFramePosition {
        public var dayOfWeekPosition: WeekdayPosition
        public var frame: CGRect
        
        public init(dayOfWeekPosition: WeekdayPosition, frame: CGRect) {
            self.dayOfWeekPosition = dayOfWeekPosition
            self.frame = frame
        }
    }
    
    public struct DayFrame {
        public var day: DayComponents
        public var frame: CGRect
        
        public init(day: DayComponents, frame: CGRect) {
            self.day = day
            self.frame = frame
        }
    }
    
    public let month: MonthComponents
    public let dayOfWeekPositionsAndFrames: [DayOfWeekFramePosition]
    public let daysAndFrames: [DayFrame]
    public let bounds: CGRect
    public let monthHeaderFrame: CGRect
    
    public static func == (lhs: MonthLayoutContext, rhs: MonthLayoutContext) -> Bool {
        lhs.month == rhs.month &&
        lhs.monthHeaderFrame == rhs.monthHeaderFrame &&
        lhs.dayOfWeekPositionsAndFrames.elementsEqual(
            rhs.dayOfWeekPositionsAndFrames,
            by: { $0.dayOfWeekPosition == $1.dayOfWeekPosition && $0.frame == $1.frame }) &&
        lhs.daysAndFrames.elementsEqual(
            rhs.daysAndFrames,
            by: { $0.day == $1.day && $0.frame == $0.frame }
        ) &&
        lhs.bounds == rhs.bounds
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(month)
        hasher.combine(monthHeaderFrame)
        
        for item in dayOfWeekPositionsAndFrames {
            hasher.combine(item.dayOfWeekPosition)
            hasher.combine(item.frame)
        }
        
        for item in daysAndFrames {
            hasher.combine(item.day)
            hasher.combine(item.frame)
        }
        
        hasher.combine(bounds)
    }
}
