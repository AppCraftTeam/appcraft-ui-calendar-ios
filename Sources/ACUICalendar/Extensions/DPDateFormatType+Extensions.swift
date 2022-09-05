//
//  DPDateFormatType+Extenions.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 29.08.2022.
//

import Foundation
import DPSwift

public extension DPDateFormatType {
    
    /// Example: `september`
    static let montLetters: Self = "LLLL"
    
    /// Example: `september 2022`
    static let montLettersAndYear: Self = "LLLL yyyy"
    
    /// Example: 5
    static let day: Self = "d"
    
    /// Example: 2022
    static let year: Self = "yyyy"
}
