//
//  ACCalendarView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 25.08.2022.
//

import Foundation
import UIKit

open class ACCalendarView: UIView {
    
    // MARK: - Props
    open lazy var monthCollectionView: ACCalendarMonthCollectionView = {
        let result = ACCalendarMonthCollectionView()
        
        return result
    }()
    
}


