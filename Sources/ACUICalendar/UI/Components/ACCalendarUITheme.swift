//
//  ACCalendarUITheme.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 29.08.2022.
//

import Foundation
import UIKit

public struct ACCalendarUITheme: Hashable {
    
    public init() { }
    
    public var backgroundColor: UIColor = .assetColor(name: "background")
    // deprecated
    public var monthSelectDateTextColor: UIColor = .assetColor(name: "textPrimary")
    public var monthSelectDateFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)
    public var monthSelectArrowImageTintColor: UIColor = .assetColor(name: "textPrimary")
    
    public var arrowsTintColor: UIColor = .assetColor(name: "textPrimary")
    
    public var weekDayTextColor: UIColor = .assetColor(name: "textSecondary")
    public var weekDayFont: UIFont = .systemFont(ofSize: 14)
    
    public var monthPickerSelectedBackgroundColor: UIColor = .assetColor(name: "accentPrimary")
    public var monthPickerFont: UIFont = .systemFont(ofSize: 23, weight: .regular)
    public var monthPickerTextColor: UIColor = .assetColor(name: "textPrimary")
    // new
    public var monthHeaderTextFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)
    public var monthHeaderTextColor: UIColor = .assetColor(name: "textPrimary")
    public var monthHeaderBackgroundColor: UIColor = .clear
    public var monthHeaderEdgeInsets: UIEdgeInsets = .zero
    public var monthHeaderTextAlignment = NSTextAlignment.natural
    
    public var dayOfWeekBackgroundColor: UIColor = .clear
    public var dayOfWeekEdgeInsets: UIEdgeInsets = .zero
    public var dayOfWeekFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)
    public var dayOfWeekTextAlignment = NSTextAlignment.center
    public var dayOfWeekTextColor: UIColor = .assetColor(name: "textSecondary")
    
    public var dayBackgroundColor: UIColor = .clear
    public var dayFont: UIFont = .systemFont(ofSize: 20, weight: .regular)
    public var dayNotCurrentMonthTextColor: UIColor = .assetColor(name: "textSecondary")
    public var dayCurrentMonthSelectedTextColor: UIColor = .black
    public var dayCurrentMonthNotSelectedTextColor: UIColor = .assetColor(name: "textPrimary")
    public var dayCurrentMonthNotAvailableSelectTextColor: UIColor = .assetColor(name: "textSecondary")
    public var dayNotSelectedBackgroundColor: UIColor = .clear
    public var dayEdgeAtRangeBackgroundColor: UIColor = .assetColor(name: "accentPrimary")
    public var dayMiddleAtRangeBackgroundColor: UIColor = .assetColor(name: "accentSecondary")
    public var dayEdgeInsets: UIEdgeInsets = .zero
    public var dayTextAlignment = NSTextAlignment.center
    
    public static func == (lhs: ACCalendarUITheme, rhs: ACCalendarUITheme) -> Bool {
        return lhs.backgroundColor == rhs.backgroundColor &&
        lhs.monthSelectDateTextColor == rhs.monthSelectDateTextColor &&
        lhs.monthSelectDateFont == rhs.monthSelectDateFont &&
        lhs.monthSelectArrowImageTintColor == rhs.monthSelectArrowImageTintColor &&
        lhs.arrowsTintColor == rhs.arrowsTintColor &&
        lhs.weekDayTextColor == rhs.weekDayTextColor &&
        lhs.weekDayFont == rhs.weekDayFont &&
        lhs.dayNotCurrentMonthTextColor == rhs.dayNotCurrentMonthTextColor &&
        lhs.dayCurrentMonthSelectedTextColor == rhs.dayCurrentMonthSelectedTextColor &&
        lhs.dayCurrentMonthNotSelectedTextColor == rhs.dayCurrentMonthNotSelectedTextColor &&
        lhs.dayCurrentMonthNotAvailableSelectTextColor == rhs.dayCurrentMonthNotAvailableSelectTextColor &&
        lhs.dayNotSelectedBackgroundColor == rhs.dayNotSelectedBackgroundColor &&
        lhs.dayEdgeAtRangeBackgroundColor == rhs.dayEdgeAtRangeBackgroundColor &&
        lhs.dayMiddleAtRangeBackgroundColor == rhs.dayMiddleAtRangeBackgroundColor &&
        lhs.dayFont == rhs.dayFont &&
        lhs.monthPickerSelectedBackgroundColor == rhs.monthPickerSelectedBackgroundColor &&
        lhs.monthPickerFont == rhs.monthPickerFont &&
        lhs.monthPickerTextColor == rhs.monthPickerTextColor &&
        lhs.monthHeaderTextFont == rhs.monthHeaderTextFont &&
        lhs.monthHeaderTextColor == rhs.monthHeaderTextColor &&
        lhs.monthHeaderBackgroundColor == rhs.monthHeaderBackgroundColor &&
        lhs.monthHeaderEdgeInsets == rhs.monthHeaderEdgeInsets &&
        lhs.monthHeaderTextAlignment == rhs.monthHeaderTextAlignment &&
        lhs.dayOfWeekBackgroundColor == rhs.dayOfWeekBackgroundColor &&
        lhs.dayOfWeekEdgeInsets == rhs.dayOfWeekEdgeInsets &&
        lhs.dayOfWeekFont == rhs.dayOfWeekFont &&
        lhs.dayOfWeekTextAlignment == rhs.dayOfWeekTextAlignment &&
        lhs.dayOfWeekTextColor == rhs.dayOfWeekTextColor &&
        
        lhs.dayBackgroundColor == rhs.dayBackgroundColor &&
        lhs.dayFont == rhs.dayFont &&
        lhs.dayNotCurrentMonthTextColor == rhs.dayNotCurrentMonthTextColor &&
        lhs.dayCurrentMonthSelectedTextColor == rhs.dayCurrentMonthSelectedTextColor &&
        lhs.dayCurrentMonthNotSelectedTextColor == rhs.dayCurrentMonthNotSelectedTextColor &&
        lhs.dayCurrentMonthNotAvailableSelectTextColor == rhs.dayCurrentMonthNotAvailableSelectTextColor &&
        lhs.dayNotSelectedBackgroundColor == rhs.dayNotSelectedBackgroundColor &&
        lhs.dayEdgeAtRangeBackgroundColor == rhs.dayEdgeAtRangeBackgroundColor &&
        lhs.dayMiddleAtRangeBackgroundColor == rhs.dayMiddleAtRangeBackgroundColor &&
        lhs.dayEdgeInsets == rhs.dayEdgeInsets &&
        lhs.dayTextAlignment == rhs.dayTextAlignment
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(backgroundColor)
        hasher.combine(monthSelectDateTextColor)
        hasher.combine(monthSelectDateFont)
        hasher.combine(monthSelectArrowImageTintColor)
        hasher.combine(arrowsTintColor)
        hasher.combine(weekDayTextColor)
        hasher.combine(weekDayFont)
        hasher.combine(dayNotCurrentMonthTextColor)
        hasher.combine(dayCurrentMonthSelectedTextColor)
        hasher.combine(dayCurrentMonthNotSelectedTextColor)
        hasher.combine(dayCurrentMonthNotAvailableSelectTextColor)
        hasher.combine(dayNotSelectedBackgroundColor)
        hasher.combine(dayEdgeAtRangeBackgroundColor)
        hasher.combine(dayMiddleAtRangeBackgroundColor)
        hasher.combine(dayFont)
        hasher.combine(monthPickerSelectedBackgroundColor)
        hasher.combine(monthPickerFont)
        hasher.combine(monthPickerTextColor)
        hasher.combine(monthHeaderTextFont)
        hasher.combine(monthHeaderTextColor)
        hasher.combine(monthHeaderBackgroundColor)
        hasher.combine(monthHeaderEdgeInsets.left)
        hasher.combine(monthHeaderEdgeInsets.right)
        hasher.combine(monthHeaderEdgeInsets.top)
        hasher.combine(monthHeaderEdgeInsets.bottom)
        hasher.combine(monthHeaderTextAlignment)
        hasher.combine(dayOfWeekBackgroundColor)
        hasher.combine(dayOfWeekEdgeInsets.left)
        hasher.combine(dayOfWeekEdgeInsets.right)
        hasher.combine(dayOfWeekEdgeInsets.top)
        hasher.combine(dayOfWeekEdgeInsets.bottom)
        hasher.combine(dayOfWeekFont)
        hasher.combine(dayOfWeekTextAlignment)
        hasher.combine(dayOfWeekTextColor)
        hasher.combine(dayBackgroundColor)
        hasher.combine(dayFont)
        hasher.combine(dayNotCurrentMonthTextColor)
        hasher.combine(dayCurrentMonthSelectedTextColor)
        hasher.combine(dayCurrentMonthNotSelectedTextColor)
        hasher.combine(dayCurrentMonthNotAvailableSelectTextColor)
        hasher.combine(dayEdgeAtRangeBackgroundColor)
        hasher.combine(dayMiddleAtRangeBackgroundColor)
        hasher.combine(dayEdgeInsets.left)
        hasher.combine(dayEdgeInsets.right)
        hasher.combine(dayEdgeInsets.top)
        hasher.combine(dayEdgeInsets.bottom)
    }
}
