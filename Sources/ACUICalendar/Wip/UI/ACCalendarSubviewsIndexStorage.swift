//
//  ACCalendarSubviewsIndexStorage.swift
//  ACUICalendar
//

import Foundation

public class ACCalendarSubviewsIndexStorage {
    
    private var monthBackgroundItemsEndIndex = 0
    private var dayBackgroundItemsEndIndex = 0
    private var dayRangeItemsEndIndex = 0
    private var mainItemsEndIndex = 0
    private var overlayItemsEndIndex = 0
    
    public func getIndex(for itemType: VisibleItem.ItemType) -> Int {
        var index: Int {
            switch itemType {
            case .monthBackground:
                return monthBackgroundItemsEndIndex
            case .dayBackground:
                return dayBackgroundItemsEndIndex
            case .dayRange:
                return dayRangeItemsEndIndex
            case .layoutItemType:
                return mainItemsEndIndex
            case .overlayItem:
                return overlayItemsEndIndex
            }
        }
        
        addValue(1, to: itemType)
        
        return index
    }
    
    private func addValue(_ value: Int, to itemType: VisibleItem.ItemType) {
        switch itemType {
        case .monthBackground:
            monthBackgroundItemsEndIndex += value
            dayRangeItemsEndIndex += value
            mainItemsEndIndex += value
            overlayItemsEndIndex += value
        case .dayBackground:
            dayBackgroundItemsEndIndex += value
            dayRangeItemsEndIndex += value
            mainItemsEndIndex += value
            overlayItemsEndIndex += value
        case .dayRange:
            dayRangeItemsEndIndex += value
            mainItemsEndIndex += value
            overlayItemsEndIndex += value
        case .layoutItemType:
            mainItemsEndIndex += value
            overlayItemsEndIndex += value
        case .overlayItem:
            overlayItemsEndIndex += value
        }
    }
}
