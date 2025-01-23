//
//  OverlayLayoutContext.swift
//  ACUICalendar
//

import Foundation

public struct OverlayLayoutContext: Hashable {
    
    public let itemLocation: OverlaidItemLocation
    public let itemFrame: CGRect
    public let availableBounds: CGRect
    
    public init(
        itemLocation: OverlaidItemLocation,
        itemFrame: CGRect,
        availableBounds: CGRect
    ) {
        self.itemLocation = itemLocation
        self.itemFrame = itemFrame
        self.availableBounds = availableBounds
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(itemLocation)
        hasher.combine(itemFrame)
        hasher.combine(availableBounds)
    }
}

