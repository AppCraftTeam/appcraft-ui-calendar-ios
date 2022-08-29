//
//  ACCalendarUITheme.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 29.08.2022.
//

import Foundation
import UIKit

public struct ACCalendarUITheme {
    public var monthSelectDateTextColor: UIColor = .black
    public var monthSelectDateFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)
    public var monthSelectArrowImageTintColor: UIColor = .black
    
    public var arrowsTintColor: UIColor = .black
    
    public var weekDayTextColor: UIColor = .black
    public var weekDayFont: UIFont = .systemFont(ofSize: 14)
    
    public var dayCurrentMonthTextColor: UIColor = .black
    public var dayNotCurrentMonthTextColor: UIColor = .gray
    public var dayNotSelectedBackgroundColor: UIColor = .clear
    public var dayEdgeAtRangeBackgroundColor: UIColor = .red
    public var dayMiddleAtRangeBackgroundColor: UIColor = .yellow
    public var dayFont: UIFont = .systemFont(ofSize: 20, weight: .regular)
}
