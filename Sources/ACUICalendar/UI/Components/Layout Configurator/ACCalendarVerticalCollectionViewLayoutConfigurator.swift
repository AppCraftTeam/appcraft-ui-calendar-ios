//
//  ACCalendarVerticalCollectionViewLayoutConfigurator.swift
//
//
//  Created by Damian on 20.05.2024.
//

import UIKit

public struct ACCalendarVerticalCollectionViewLayoutConfigurator: ACCalendarCollectionViewLayoutConfigurator {

    public func makeLayout() -> ACCalendarBaseLayout {
        ACCalendarVerticalLayout()
    }

    public func makePageProvider() -> ACPageProvider {
        ACVerticalPageProvider()
    }

    public func makeInsertionRules() -> ACDateInsertRules? {
        ACDateVerticalInsertRules()
    }
}
