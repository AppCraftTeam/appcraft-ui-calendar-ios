//
//  CGRect+Extension.swift
//  ACUICalendar
//
//

import Foundation

extension CGRect {
    
    func alignedToPixels(forScreenWithScale scale: CGFloat) -> CGRect {
        CGRect(
            x: minX.alignedToPixel(forScreenWithScale: scale),
            y: minY.alignedToPixel(forScreenWithScale: scale),
            width: width.alignedToPixel(forScreenWithScale: scale),
            height: height.alignedToPixel(forScreenWithScale: scale)
        )
    }
}
