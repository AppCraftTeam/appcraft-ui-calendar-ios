//
//  File.swift
//  
//
//  Created by Damian on 16.05.2024.
//

import Foundation
import UIKit

public struct ACCalendarCollectionViewLayoutFactory {
    
    var makeLayout: () -> UICollectionViewFlowLayout
    var makePageProvider: () -> ACPageProvider
    var makeInsertionRules: () -> ACDateInsertRules?
    
    public static func vertical() -> Self {
        .init(
            makeLayout: { ACCalendarVerticalLayout() },
            makePageProvider: { ACVerticalPageProvider() },
            makeInsertionRules: { ACDateVerticalInsertRules() }
        )
    }
    
    public static func horizontal() -> Self {
        .init(
            makeLayout: { ACCalendarHorizontalLayout() },
            makePageProvider: { ACHorizontalPageProvider() },
            makeInsertionRules: { ACDateHorizontalInsertRules() }
        )
    }
}
