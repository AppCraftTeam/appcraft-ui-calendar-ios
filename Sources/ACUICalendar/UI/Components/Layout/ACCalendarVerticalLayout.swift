//
//  ACCalendarVerticalLayout.swift
//  ACUICalendar
//
//  Created by Damian on 08.09.2023.
//

import UIKit

// TODO: Add custom section insets for layout

open class ACCalendarVerticalLayout: ACCalendarBaseLayout {
    
    open var headerHeight: Double {
        didSet {
            invalidateLayout()
        }
    }
    
    public init(headerHeight: Double = 20) {
        self.headerHeight = headerHeight
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func prepare() {
        super.prepare()
        guard let collectionView else { return }
        self.resetLayoutAttributes()
        self.scrollDirection = .vertical
        
        let sectionWidth: CGFloat = collectionView.frame.width
        let sectionHeight: CGFloat = collectionView.frame.height * 0.5
        let collumnsCount: Int = 7
        let itemWidth = sectionWidth / CGFloat(collumnsCount)
        
        var contentY: CGFloat = 0
        
        for section in 0..<collectionView.numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            let rowsCount = numberOfItems / 7
            let itemHeight = sectionHeight / CGFloat(rowsCount)
            var currentRow: Int = 0
            var currentColumn: Int = 0
            
            if headerHeight > 0 {
                let attr = UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    with: IndexPath(item: 0, section: section)
                )
                attr.frame = CGRect(x: 0, y: contentY, width: sectionWidth, height: headerHeight)
                
                self.headerLayoutAttributes.append(attr)
                contentY += headerHeight + self.sectionInset.top
            }
            
            for item in 0..<numberOfItems {
                let x = itemWidth * CGFloat(currentColumn)
                let y = itemHeight * CGFloat(currentRow) + contentY
                
                let frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
                let indexPath = IndexPath(item: item, section: section)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                
                self.itemLayoutAttributes.append(attributes)
                
                if currentColumn >= collumnsCount - 1 {
                    currentColumn = 0
                    currentRow += 1
                } else {
                    currentColumn += 1
                }
            }
            contentY += sectionHeight
        }
        self.headerReferenceSize = .init(width: sectionWidth, height: headerHeight)
        self.contentSize = .init(width: sectionWidth, height: contentY)
    }
}
