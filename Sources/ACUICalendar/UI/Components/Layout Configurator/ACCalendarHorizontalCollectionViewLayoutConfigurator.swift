//
//  ACCalendarHorizontalCollectionViewLayoutConfigurator.swift
//
//
//  Created by Damian on 20.05.2024.
//

import UIKit

public struct ACCalendarHorizontalCollectionViewLayoutConfigurator: ACCalendarCollectionViewLayoutConfigurator {

    public func makeLayout() -> ACCalendarLayout {
        ACCalendarHorizontalLayout()
    }

    public func makePageProvider() -> ACPageProvider {
        ACHorizontalPageProvider()
    }

    public func makeInsertionRules() -> ACDateInsertRules? {
        ACDateHorizontalInsertRules()
    }
}
