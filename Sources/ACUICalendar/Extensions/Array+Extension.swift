//
//  Array+Extension.swift
//
//
//  Created by Pavel Moslienko on 20.09.2024.
//

import Foundation
import UIKit

extension Array where Element: UICollectionViewLayoutAttributes {
    
    func binarySearchRange(for rect: CGRect) -> [Element] {
        var lowerBound = 0
        var upperBound = count
        
        while lowerBound < upperBound {
            let midIndex = (lowerBound + upperBound) / 2
            if self[midIndex].frame.maxY < rect.minY {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        
        let startIndex = lowerBound
        
        upperBound = count
        while lowerBound < upperBound {
            let midIndex = (lowerBound + upperBound) / 2
            if self[midIndex].frame.minY > rect.maxY {
                upperBound = midIndex
            } else {
                lowerBound = midIndex + 1
            }
        }
        
        let endIndex = lowerBound
        return Array(self[startIndex..<endIndex])
    }
}

extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
