//
//  ACCalendarVerticalCollectionViewLayoutConfigurtor.swift
//
//
//  Created by Damian on 20.05.2024.
//

import UIKit

public struct ACCalendarVerticalCollectionViewLayoutConfigurtor: ACCalendarCollectionViewLayoutConfigurtor {

    public func makeLayout() -> UICollectionViewFlowLayout {
        ACCalendarVerticalLayout()
    }

    public func makePageProvider() -> ACPageProvider {
        ACVerticalPageProvider()
    }

    public func makeInsertionRules() -> ACDateInsertRules? {
        ACDateVerticalInsertRules()
    }
}
