//
//  ACCalendarBaseLayout.swift
//
//
//  Created by Damian on 11.09.2023.
//

import UIKit

open class ACCalendarBaseLayout: UICollectionViewFlowLayout {
    
    // MARK: Attributes
    var isPortraitOrientation = UIDevice.current.orientation.isPortrait
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
    
    // MARK: Utils
    let orientationObserver: PortraitOrientationObserver
    
    // MARK: - Init
    public override init() {
        self.orientationObserver = PortraitOrientationObserver()
        
        super.init()
        self.orientationObserver.add(self)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout methods
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        self.itemLayoutAttributes.first(where: { $0.indexPath == indexPath })
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
}
// MARK: - PortraitOrientationObserverListener
extension ACCalendarBaseLayout: PortraitOrientationObserverListener {
    func deviceOrientationObserver(didChangeOrientation isPortrait: Bool) {
        self.isPortraitOrientation = isPortrait
        self.resetLayoutAttributes()
        self.invalidateLayout()
        self.collectionView?.reloadData()
    }
}

// MARK: - Fabrications
public extension UICollectionViewFlowLayout {
    
    static func vertical(
        headerHeight: Double = 20,
        sectionInset: UIEdgeInsets = .zero
    ) -> UICollectionViewFlowLayout {
        ACCalendarVerticalLayout(headerHeight: headerHeight)
    }
    
    static var horizontal: UICollectionViewFlowLayout {
        ACCalendarHorizontalLayout()
    }
}
