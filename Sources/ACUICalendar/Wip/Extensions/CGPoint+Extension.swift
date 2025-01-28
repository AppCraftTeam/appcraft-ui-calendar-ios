
//
//  CGPoint+Extension.swift
//  ACUICalendar
//

import Foundation

extension CGPoint {
    
    func alignedToPixels(forScreenWithScale scale: CGFloat) -> CGPoint {
        CGPoint(
            x: x.alignedToPixel(forScreenWithScale: scale),
            y: y.alignedToPixel(forScreenWithScale: scale)
        )
    }
}
