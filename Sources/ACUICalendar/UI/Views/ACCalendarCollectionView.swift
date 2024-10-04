//
//  ACCalendarCollectionView.swift
//
//
//  Created by Damian on 24.05.2024.
//

import UIKit

open class ACCalendarCollectionView: UICollectionView {

    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentInsetAdjustmentBehavior = .never
        self.register(
            ACCalendarMonthSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ACCalendarMonthSupplementaryView.identifer
        )
        self.register(
            ACCalendarDayCollectionViewCell.self,
            forCellWithReuseIdentifier: ACCalendarDayCollectionViewCell.identifer
        )
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
