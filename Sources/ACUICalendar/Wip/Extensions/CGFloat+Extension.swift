//
//  CGFloat+Extension.swift
//  ACUICalendar
//

import Foundation

extension CGFloat {
    
    // Infinity number
    static let maxLayoutValue: CGFloat = 2.5E07
    
    func alignedToPixel(forScreenWithScale scale: CGFloat) -> CGFloat {
        (self * scale).rounded() / scale
    }
    
    func isEqual(to rhs: CGFloat, screenScale: CGFloat) -> Bool {
        let lhs = alignedToPixel(forScreenWithScale: screenScale)
        let rhs = rhs.alignedToPixel(forScreenWithScale: screenScale)
        return lhs == rhs
    }
}
