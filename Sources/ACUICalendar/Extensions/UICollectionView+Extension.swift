//
//  UICollectionView+Extension.swift
//
//
//  Created by Pavel Moslienko on 17.09.2024.
//

import UIKit

extension UICollectionView {
    
    func scrollToItemWithCompletion(
        at indexPath: IndexPath,
        position: UICollectionView.ScrollPosition,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        if animated {
            UIView.animate(withDuration: 0.3,
                           animations: {
                self.scrollToItem(at: indexPath, at: position, animated: false)
            }, completion: { _ in
                completion()
            })
        } else {
            self.scrollToItem(at: indexPath, at: position, animated: false)
            completion()
        }
    }
    
    func isCellAtIndexPathFullyVisible(_ indexPath: IndexPath) -> Bool {
        guard let layoutAttribute = layoutAttributesForItem(at: indexPath) else {
            return false
        }
        
        let cellFrame = layoutAttribute.frame
        return self.bounds.contains(cellFrame)
    }
    
    func indexPathsForFullyVisibleItems() -> [IndexPath] {
        
        let visibleIndexPaths = indexPathsForVisibleItems
        
        return visibleIndexPaths.filter { indexPath in
            return isCellAtIndexPathFullyVisible(indexPath)
        }
    }
}
