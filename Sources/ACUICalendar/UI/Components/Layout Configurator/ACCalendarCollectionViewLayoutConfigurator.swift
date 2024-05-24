//
//  ACCalendarCollectionViewLayoutConfigurator.swift
//
//
//  Created by Damian on 16.05.2024.
//

import UIKit

public protocol ACCalendarCollectionViewLayoutConfigurator {
    func makeLayout() -> ACCalendarLayout
    func makePageProvider() -> ACPageProvider
    func makeInsertionRules() -> ACDateInsertRules?
}

// MARK: - Fabrication
public extension ACCalendarCollectionViewLayoutConfigurator where Self == ACCalendarVerticalCollectionViewLayoutConfigurator {
    static func vertical() -> Self {
        ACCalendarVerticalCollectionViewLayoutConfigurator()
    }
}
public extension ACCalendarCollectionViewLayoutConfigurator where Self == ACCalendarHorizontalCollectionViewLayoutConfigurator {
    static func horizontal() -> Self {
        ACCalendarHorizontalCollectionViewLayoutConfigurator()
    }
}
