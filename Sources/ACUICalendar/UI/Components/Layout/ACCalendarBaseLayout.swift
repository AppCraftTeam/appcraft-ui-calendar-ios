//
//  ACCalendarBaseLayout.swift
//
//
//  Created by Damian on 11.09.2023.
//

import UIKit

open class ACCalendarBaseLayout: UICollectionViewFlowLayout {
    
    // MARK: Attributes
    open var itemHeight: Double = .zero {
        didSet {
            self.reloadLayout()
        }
    }
    open var isLandscapeOrientation = UIDevice.current.orientation.isLandscape

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

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        self.searchItemLayoutAttribute(
            itemLayoutAttributes.sorted(by: { $0.indexPath < $1.indexPath }),
            where: indexPath
        )
    }

    open override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        if headerLayoutAttributes.indices.contains(indexPath.section) {
            return headerLayoutAttributes[indexPath.section]
        }
        return nil
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let visibleCellLayoutAttributes = itemLayoutAttributes.filter { rect.intersects($0.frame) }
        let visibleHeaderLayoutAttributes = headerLayoutAttributes.filter { rect.intersects($0.frame) }
        return visibleCellLayoutAttributes + visibleHeaderLayoutAttributes
    }
    
    // MARK: - Utils
    private func searchItemLayoutAttribute(
        _ list: [UICollectionViewLayoutAttributes],
        where indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        var low = 0
        var high = list.count - 1
        
        while low <= high {
            let mid = (high + low) / 2
            let midAttr = list[mid]
            
            if indexPath == midAttr.indexPath {
                return midAttr
            }
            else if midAttr.indexPath > indexPath {
                high = mid - 1
            } else {
                low = mid + 1
            }
        }
        return nil
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
