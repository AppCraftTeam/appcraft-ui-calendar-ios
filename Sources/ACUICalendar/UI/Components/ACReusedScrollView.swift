//
//  ACReusedScrollView.swift
//
//
//  Created by Pavel Moslienko on 08.10.2024.
//

import UIKit

public class ACReusedScrollView<ItemIndex>: UIScrollView {
    
    public enum Orientation {
        case horizontal
        case vertical
    }
    
    private var scaleMultiplier: CGFloat
    private var currentIndex: ItemIndex
    private let spacing: CGFloat
    private var displayedViews: [(UIView, ItemIndex)]
    private let viewProvider: (ItemIndex) -> UIView
    private let frameProvider: (ItemIndex) -> CGRect
    
    private let incrementIndexAction: (ItemIndex) -> ItemIndex?
    private let decrementIndexAction: (ItemIndex) -> ItemIndex?
    
    private let layoutOrientation: Orientation
    
    public init(
        frame: CGRect,
        viewProvider: @escaping (ItemIndex) -> UIView,
        frameProvider: @escaping (ItemIndex) -> CGRect,
        currentIndex: ItemIndex,
        incrementIndexAction: @escaping (ItemIndex) -> ItemIndex?,
        decrementIndexAction: @escaping (ItemIndex) -> ItemIndex?,
        scaleMultiplier: CGFloat = 6,
        layoutOrientation: Orientation,
        spacing: CGFloat = 0
    ) {
        self.displayedViews = []
        self.viewProvider = viewProvider
        self.frameProvider = frameProvider
        self.currentIndex = currentIndex
        self.incrementIndexAction = incrementIndexAction
        self.decrementIndexAction = decrementIndexAction
        self.scaleMultiplier = scaleMultiplier
        self.layoutOrientation = layoutOrientation
        self.spacing = spacing
        super.init(frame: frame)
        
        switch layoutOrientation {
        case .horizontal:
            self.contentSize = CGSize(width: self.frame.size.width * self.scaleMultiplier, height: self.frame.size.height)
        case .vertical:
            self.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height * self.scaleMultiplier)
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let beforeIndex: ItemIndex? = {
            if let firstLabel = self.displayedViews.first {
                return self.decrementIndexAction(firstLabel.1)
            } else {
                return self.decrementIndexAction(self.currentIndex)
            }
        }()
        
        let afterIndex: ItemIndex? = {
            if let lastLabel = self.displayedViews.last {
                return self.incrementIndexAction(lastLabel.1)
            } else {
                return self.incrementIndexAction(self.currentIndex)
            }
        }()
        
        let isCompact: Bool = {
            guard let firstLabel = self.displayedViews.first?.0, let lastLabel = self.displayedViews.last?.0 else { return false }
            let totalWidth = lastLabel.frame.origin.x + lastLabel.frame.width - firstLabel.frame.origin.x
            let totalHeight = lastLabel.frame.origin.y + lastLabel.frame.height - firstLabel.frame.origin.y
            return (layoutOrientation == .horizontal && totalWidth < self.frame.size.width + 1)
            || (layoutOrientation == .vertical && totalHeight < self.frame.size.height + 1)
        }()
        
        if beforeIndex == nil && afterIndex == nil && isCompact {
            adjustContentSizeForCompactState()
        } else {
            adjustContentSizeForNormalState()
            self.recenterIfNecessary(beforeIndexUndefined: beforeIndex == nil, afterIndexUndefined: afterIndex == nil)
        }
        
        updateVisibleViews(beforeIndex: beforeIndex, afterIndex: afterIndex, isCompact: isCompact)
    }
}

// MARK: - Layout helpers
private extension ACReusedScrollView {
    
    func adjustContentSizeForCompactState() {
        switch layoutOrientation {
        case .horizontal:
            self.contentSize = CGSize(width: self.frame.size.width + 1, height: self.frame.size.height)
        case .vertical:
            self.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height + 1)
            self.goUp()
        }
    }
    
    func adjustContentSizeForNormalState() {
        switch layoutOrientation {
        case .horizontal:
            self.contentSize = CGSize(width: self.frame.size.width * self.scaleMultiplier, height: self.frame.size.height)
        case .vertical:
            self.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height * self.scaleMultiplier)
        }
    }
    
    func updateVisibleViews(beforeIndex: ItemIndex?, afterIndex: ItemIndex?, isCompact: Bool) {
        let visibleBounds = self.convert(self.bounds, to: self)
        
        switch layoutOrientation {
        case .horizontal:
            let minVisibleX = visibleBounds.minX
            let maxVisibleX = visibleBounds.maxX
            self.updateHorizontalViews(minVisibleX: minVisibleX, maxVisibleX: maxVisibleX, previousIndex: beforeIndex, nextIndex: afterIndex, isCompact: isCompact)
        case .vertical:
            let minVisibleY = visibleBounds.minY
            let maxVisibleY = visibleBounds.maxY
            self.updateVerticalViews(minVisibleY: minVisibleY, maxVisibleY: maxVisibleY, previousIndex: beforeIndex, nextIndex: afterIndex, isCompact: isCompact)
        }
    }
    
}

private extension ACReusedScrollView {
    
    func insertView() -> UIView {
        let newView = viewProvider(currentIndex)
        newView.frame = self.frameProvider(currentIndex)
        newView.backgroundColor = .clear
        self.addSubview(newView)
        return newView
    }
    
    func recenterIfNecessary(beforeIndexUndefined: Bool, afterIndexUndefined: Bool) {
        let currentOffset = self.contentOffset
        
        switch layoutOrientation {
        case .horizontal:
            let contentWidth = self.contentSize.width
            let centerOffsetX = (contentWidth - self.bounds.width) / 2
            let distanceFromCenterX = abs(currentOffset.x - centerOffsetX)
            
            if beforeIndexUndefined {
                self.goLeft()
            } else if afterIndexUndefined {
                self.goRight()
            } else if distanceFromCenterX > contentWidth / scaleMultiplier {
                self.contentOffset = CGPoint(x: centerOffsetX, y: currentOffset.y)
                adjustLabelPositionsForHorizontalShift(by: centerOffsetX - currentOffset.x)
            }
            
        case .vertical:
            let contentHeight = self.contentSize.height
            let centerOffsetY = (contentHeight - self.bounds.height) / 2
            let distanceFromCenterY = abs(currentOffset.y - centerOffsetY)
            
            if beforeIndexUndefined {
                self.goUp()
            } else if afterIndexUndefined {
                self.goDown()
            } else if distanceFromCenterY > contentHeight / scaleMultiplier {
                self.contentOffset = CGPoint(x: currentOffset.x, y: centerOffsetY)
                adjustLabelPositionsForVerticalShift(by: centerOffsetY - currentOffset.y)
            }
        }
    }
    
    func adjustLabelPositionsForHorizontalShift(by offsetX: CGFloat) {
        for (label, _) in self.displayedViews {
            var adjustedCenter = self.convert(label.center, to: self)
            adjustedCenter.x += offsetX
            label.center = self.convert(adjustedCenter, to: self)
        }
    }
    
    func adjustLabelPositionsForVerticalShift(by offsetY: CGFloat) {
        for (label, _) in self.displayedViews {
            var adjustedCenter = self.convert(label.center, to: self)
            adjustedCenter.y += offsetY
            label.center = self.convert(adjustedCenter, to: self)
        }
    }
    
    func goUp() {
        adjustLabelsVertical(isUp: true)
    }
    
    func goDown() {
        adjustLabelsVertical(isUp: false)
    }
    
    func goLeft() {
        adjustLabelsHorizontal(isLeft: true)
    }
    
    func goRight() {
        adjustLabelsHorizontal(isLeft: false)
    }
    
    private func adjustLabelsVertical(isUp: Bool) {
        var currentY: CGFloat = isUp ? 0 : self.contentSize.height
        var adjustedOffset = false
        
        let labels = isUp ? self.displayedViews : self.displayedViews.reversed()
        
        for (label, _) in labels {
            var origin = self.convert(label.frame.origin, to: self)
            
            if isUp {
                if !adjustedOffset {
                    self.contentOffset.y -= origin.y
                    adjustedOffset = true
                }
                origin.y = currentY
                currentY += label.frame.height + spacing
            } else {
                currentY -= label.frame.height
                if !adjustedOffset {
                    self.contentOffset.y += currentY - origin.y
                    adjustedOffset = true
                }
                origin.y = currentY
                currentY -= spacing
            }
            
            label.frame.origin = self.convert(origin, to: self)
        }
    }
    
    private func adjustLabelsHorizontal(isLeft: Bool) {
        var currentX: CGFloat = isLeft ? 0 : self.contentSize.width
        var adjustedOffset = false
        
        let labels = isLeft ? self.displayedViews : self.displayedViews.reversed()
        
        for (label, _) in labels {
            var origin = self.convert(label.frame.origin, to: self)
            
            if isLeft {
                if !adjustedOffset {
                    self.contentOffset.x -= origin.x
                    adjustedOffset = true
                }
                origin.x = currentX
                currentX += label.frame.width + spacing
            } else {
                currentX -= label.frame.width
                if !adjustedOffset {
                    self.contentOffset.x += currentX - origin.x
                    adjustedOffset = true
                }
                origin.x = currentX
                currentX -= spacing
            }
            
            label.frame.origin = self.convert(origin, to: self)
        }
    }
}

private extension ACReusedScrollView {
    
    func appendNewViewAtEnd() -> UIView? {
        if let lastVisible = displayedViews.last {
            guard let nextIndex = self.incrementIndexAction(lastVisible.1) else { return nil }
            currentIndex = nextIndex
        }
        
        let newView = self.insertView()
        self.displayedViews.append((newView, currentIndex))
        return newView
    }
    
    func placeNewViewToRight(rightBoundary: CGFloat) -> CGFloat? {
        guard let newView = appendNewViewAtEnd() else { return nil }
        
        var frame = newView.frame
        frame.origin.x = rightBoundary
        newView.frame = frame
        
        return frame.maxX
    }
    
    func placeNewViewToBottom(bottomBoundary: CGFloat) -> CGFloat? {
        guard let newView = appendNewViewAtEnd() else { return nil }
        
        var frame = newView.frame
        frame.origin.y = bottomBoundary
        newView.frame = frame
        
        return frame.maxY
    }
    
    func prependNewViewAtBeginning() -> UIView? {
        if let firstVisible = displayedViews.first {
            guard let previousIndex = self.decrementIndexAction(firstVisible.1) else { return nil }
            currentIndex = previousIndex
        }
        
        let newView = self.insertView()
        self.displayedViews.insert((newView, currentIndex), at: 0)
        return newView
    }
    
    func placeNewViewToLeft(leftBoundary: CGFloat) -> CGFloat? {
        guard let newView = prependNewViewAtBeginning() else { return nil }
        
        var frame = newView.frame
        frame.origin.x = leftBoundary - frame.width
        newView.frame = frame
        
        return frame.minX
    }
    
    func placeNewViewToTop(topBoundary: CGFloat) -> CGFloat? {
        guard let newView = prependNewViewAtBeginning() else { return nil }
        
        var frame = newView.frame
        frame.origin.y = topBoundary - frame.height
        newView.frame = frame
        
        return frame.minY
    }
    
    func updateHorizontalViews(minVisibleX: CGFloat, maxVisibleX: CGFloat, previousIndex: ItemIndex?, nextIndex: ItemIndex?, isCompact: Bool) {
        if displayedViews.isEmpty {
            guard placeNewViewToLeft(leftBoundary: minVisibleX) != nil else {
                goLeft()
                return
            }
            if let firstView = displayedViews.first?.0 {
                firstView.frame.origin.x += firstView.frame.width + spacing
            }
        }
        
        if previousIndex != nil, let firstView = displayedViews.first?.0 {
            var currentLeftEdge = firstView.frame.minX
            while currentLeftEdge > minVisibleX {
                guard let newLeftEdge = placeNewViewToLeft(leftBoundary: currentLeftEdge) else {
                    goLeft()
                    return
                }
                currentLeftEdge = newLeftEdge
            }
        }
        
        if nextIndex != nil, let lastView = displayedViews.last?.0 {
            var currentRightEdge = lastView.frame.maxX
            while currentRightEdge < maxVisibleX {
                guard let newRightEdge = placeNewViewToRight(rightBoundary: currentRightEdge) else {
                    if !isCompact { goRight() }
                    return
                }
                currentRightEdge = newRightEdge
            }
        }
        
        while let lastView = displayedViews.last?.0,
              lastView.frame.minX > maxVisibleX {
            lastView.removeFromSuperview()
            displayedViews.removeLast()
        }
        
        while let firstView = displayedViews.first?.0,
              firstView.frame.maxX < minVisibleX {
            firstView.removeFromSuperview()
            displayedViews.removeFirst()
        }
    }
    
    func updateVerticalViews(minVisibleY: CGFloat, maxVisibleY: CGFloat, previousIndex: ItemIndex?, nextIndex: ItemIndex?, isCompact: Bool) {
        if displayedViews.isEmpty {
            guard placeNewViewToTop(topBoundary: minVisibleY) != nil else {
                goUp()
                return
            }
            if let firstView = displayedViews.first?.0 {
                firstView.frame.origin.y += firstView.frame.height + spacing
            }
        }
        
        if previousIndex != nil,
           let firstView = displayedViews.first?.0 {
            var currentTopEdge = firstView.frame.minY
            while currentTopEdge > minVisibleY {
                guard let newTopEdge = placeNewViewToTop(topBoundary: currentTopEdge) else {
                    goUp()
                    return
                }
                currentTopEdge = newTopEdge
            }
        }
        
        if nextIndex != nil,
           let lastView = displayedViews.last?.0 {
            var currentBottomEdge = lastView.frame.maxY
            while currentBottomEdge < maxVisibleY {
                guard let newBottomEdge = placeNewViewToBottom(bottomBoundary: currentBottomEdge) else {
                    if !isCompact { goDown() }
                    return
                }
                currentBottomEdge = newBottomEdge
            }
        }
        
        while let lastView = displayedViews.last?.0,
              lastView.frame.minY > maxVisibleY {
            lastView.removeFromSuperview()
            displayedViews.removeLast()
        }
        
        while let firstView = displayedViews.first?.0,
              firstView.frame.maxY < minVisibleY {
            firstView.removeFromSuperview()
            displayedViews.removeFirst()
        }
    }
}
