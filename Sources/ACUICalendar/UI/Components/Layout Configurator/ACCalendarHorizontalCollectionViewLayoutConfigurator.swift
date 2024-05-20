//
//  ACCalendarHorizontalCollectionViewLayoutConfigurtor.swift
//
//
//  Created by Damian on 20.05.2024.
//

import UIKit

public struct ACCalendarHorizontalCollectionViewLayoutConfigurtor: ACCalendarCollectionViewLayoutConfigurtor {

    public func makeLayout() -> UICollectionViewFlowLayout {
        ACCalendarHorizontalLayout()
    }

    public func makePageProvider() -> ACPageProvider {
        ACHorizontalPageProvider()
    }

    public func makeInsertionRules() -> ACDateInsertRules? {
        ACDateHorizontalInsertRules()
    }
}
