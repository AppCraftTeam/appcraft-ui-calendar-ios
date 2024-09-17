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
}
