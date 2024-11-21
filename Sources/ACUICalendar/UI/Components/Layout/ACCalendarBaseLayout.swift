//
//  ACCalendarBaseLayout.swift
//
//
//  Created by Damian on 11.09.2023.
//

import UIKit

open class ACCalendarBaseLayout: UICollectionViewFlowLayout, ACCalendarLayout {

    // MARK: Attributes
    open var itemHeight: CGFloat = .zero {
        didSet {
            self.reloadLayout()
        }
    }

    open var isLandscapeOrientation = UIDevice.current.orientation.isLandscape {
        didSet {
            self.reloadLayout()
        }
    }

    open var itemLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    open var headerLayoutAttributes: [UICollectionViewLayoutAttributes] = []

    // MARK: Properties
    open var contentSize: CGSize = .zero

    open override var collectionViewContentSize: CGSize {
        self.contentSize
    }

    open func resetLayoutAttributes() {
        self.itemLayoutAttributes.removeAll()
        self.headerLayoutAttributes.removeAll()
    }

    open func reloadLayout() {
        self.resetLayoutAttributes()
        self.invalidateLayout()
    }

    // MARK: - Layout methods
    private var attributesByIndexPath: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    open override func prepare() {
        super.prepare()
        
        attributesByIndexPath = [:]
        for attribute in itemLayoutAttributes {
            attributesByIndexPath[attribute.indexPath] = attribute
        }
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //print("layoutSubviews layoutAttributesForItem, all \(attributesByIndexPath.count)")
        return attributesByIndexPath[indexPath]
    }

    open override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        //print("layoutSubviews layoutAttributesForSupplementaryView")
        if headerLayoutAttributes.indices.contains(indexPath.section) {
            return headerLayoutAttributes[indexPath.section]
        }
        return nil
    }
    
     open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
         let visibleCellLayoutAttributes = itemLayoutAttributes.binarySearchRange(for: rect)
         let visibleHeaderLayoutAttributes = headerLayoutAttributes.binarySearchRange(for: rect)
         return visibleCellLayoutAttributes + visibleHeaderLayoutAttributes
     }
}

// MARK: - Fabrications
public extension UICollectionViewFlowLayout {
    
    static func vertical(
        headerHeight: Double = 20
    ) -> UICollectionViewFlowLayout {
        ACCalendarVerticalLayout(headerHeight: headerHeight)
    }
    
    static var horizontal: UICollectionViewFlowLayout {
        ACCalendarHorizontalLayout()
    }
}
