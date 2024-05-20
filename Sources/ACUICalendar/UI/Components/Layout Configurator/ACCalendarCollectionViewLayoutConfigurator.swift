//
//  ACCalendarCollectionViewLayoutConfigurator.swift
//
//
//  Created by Damian on 16.05.2024.
//

import UIKit

public protocol ACCalendarCollectionViewLayoutConfigurator {
    func makeLayout() -> UICollectionViewFlowLayout
    func makePageProvider() -> ACPageProvider
    func makeInsertionRules() -> ACDateInsertRules?
}

// MARK: - Fabrications
extension ACCalendarCollectionViewLayoutConfigurator {
    static func vertical() -> ACCalendarVerticalCollectionViewLayoutConfigurtor {
        ACCalendarVerticalCollectionViewLayoutConfigurtor()
    }
    
    static func horizontal() -> ACCalendarHorizontalCollectionViewLayoutConfigurtor {
        ACCalendarHorizontalCollectionViewLayoutConfigurtor()
    }
}
