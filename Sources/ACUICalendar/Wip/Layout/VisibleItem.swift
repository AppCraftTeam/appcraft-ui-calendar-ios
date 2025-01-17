//
//  VisibleItem.swift
//  ACUICalendar
//

import Foundation
import UIKit

public class VisibleItem: Equatable, Hashable {
    
    public enum ItemType: Equatable, Hashable {
        case layoutItemType(LayoutItem.ItemType)
        case dayBackground(DayComponents)
        case monthBackground(MonthComponents)
        case dayRange(DayRange)
        case overlayItem(OverlaidItemLocation)
    }
    
    let calendarItemModel: AnyCalendarItemModel
    let itemType: ItemType
    let frame: CGRect
    
    private let cachedHashValue: Int
    
    init(calendarItemModel: AnyCalendarItemModel, itemType: ItemType, frame: CGRect) {
        self.calendarItemModel = calendarItemModel
        self.itemType = itemType
        self.frame = frame
        
        var hasher = Hasher()
        hasher.combine(calendarItemModel._itemViewDifferentiator)
        hasher.combine(itemType)
        self.cachedHashValue = hasher.finalize()
    }
    
    static public func == (lhs: VisibleItem, rhs: VisibleItem) -> Bool {
        lhs.calendarItemModel._itemViewDifferentiator == rhs.calendarItemModel._itemViewDifferentiator &&
        lhs.itemType == rhs.itemType
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(cachedHashValue)
    }
}
