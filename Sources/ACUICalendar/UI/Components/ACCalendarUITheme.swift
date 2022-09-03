//
//  ACCalendarUITheme.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 29.08.2022.
//

import Foundation
import UIKit

public struct ACCalendarUITheme {
    public var backgroundColor: UIColor = ACCalendarColor.backgroundColor
    
    public var monthSelectDateTextColor: UIColor = ACCalendarColor.textPrimaryColor
    public var monthSelectDateFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)
    public var monthSelectArrowImageTintColor: UIColor = ACCalendarColor.textPrimaryColor
    
    public var arrowsTintColor: UIColor = ACCalendarColor.textPrimaryColor
    
    public var weekDayTextColor: UIColor = ACCalendarColor.textSecondaryColor
    public var weekDayFont: UIFont = .systemFont(ofSize: 14)
    
    public var dayNotCurrentMonthTextColor: UIColor = ACCalendarColor.textSecondaryColor
    public var dayCurrentMonthSelectedTextColor: UIColor = .black
    public var dayCurrentMonthNotSelectedTextColor: UIColor = ACCalendarColor.textPrimaryColor
    
    public var dayNotSelectedBackgroundColor: UIColor = .clear
    public var dayEdgeAtRangeBackgroundColor: UIColor = ACCalendarColor.accentPrimaryColor
    public var dayMiddleAtRangeBackgroundColor: UIColor = ACCalendarColor.accentSecondaryColor
    public var dayFont: UIFont = .systemFont(ofSize: 20, weight: .regular)
    
    public var monthPickerSelectedBackgroundColor: UIColor = ACCalendarColor.accentPrimaryColor
    public var monthPickerFont: UIFont = .systemFont(ofSize: 23, weight: .regular)
    public var monthPickerTextColor: UIColor = ACCalendarColor.textPrimaryColor
}

