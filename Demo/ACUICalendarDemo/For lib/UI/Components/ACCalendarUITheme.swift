//
//  ACCalendarUITheme.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 29.08.2022.
//

import Foundation
import UIKit

public struct ACCalendarUITheme {
    public var backgroundColor: UIColor = .backgroundColor
    
    public var monthSelectDateTextColor: UIColor = .textPrimaryColor
    public var monthSelectDateFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)
    public var monthSelectArrowImageTintColor: UIColor = .textPrimaryColor
    
    public var arrowsTintColor: UIColor = .textPrimaryColor
    
    public var weekDayTextColor: UIColor = .textSecondaryColor
    public var weekDayFont: UIFont = .systemFont(ofSize: 14)
    
//    public var dayCurrentMonthTextColor: UIColor = .textPrimaryColor
    public var dayNotCurrentMonthTextColor: UIColor = .textSecondaryColor
    public var dayCurrentMonthSelectedTextColor: UIColor = .black
    public var dayCurrentMonthNotSelectedTextColor: UIColor = .textPrimaryColor
    
    public var dayNotSelectedBackgroundColor: UIColor = .clear
    public var dayEdgeAtRangeBackgroundColor: UIColor = .accentPrimaryColor
    public var dayMiddleAtRangeBackgroundColor: UIColor = .accentSecondaryColor
    public var dayFont: UIFont = .systemFont(ofSize: 20, weight: .regular)
}
