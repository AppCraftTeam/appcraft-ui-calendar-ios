//
//  ACCalendarScrollView.swift
//  ACUICalendar
//

import UIKit

public class ACCalendarScrollView: UIScrollView {
    
    public let scrollAxis: ACCalendarScrollDirection
    
    private var isConfigured = false
    private let unlimitedContentInset: CGFloat = 10_000_000_000_000
    
    public init(scrollAxis: ACCalendarScrollDirection) {
        self.scrollAxis = scrollAxis
        super.init(frame: .zero)
        contentInsetAdjustmentBehavior = .never
    }
    
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var contentInsetAdjustmentBehavior: ContentInsetAdjustmentBehavior {
        didSet {
            super.contentInsetAdjustmentBehavior = .never
        }
    }
}

extension ACCalendarScrollView {
    
    public func configure() {
        guard !isConfigured else { return }
        
        self.setSize(to: unlimitedContentInset, for: scrollAxis)
        self.setStartInset(to: unlimitedContentInset, for: scrollAxis)
        self.setEndInset(to: 0, for: scrollAxis)
        
        self.setOffset(to: 0, for: scrollAxis)
        
        isConfigured = true
    }
    
    public func updateSize(viewportSize: CGSize) {
        switch scrollAxis {
        case .vertical:
            self.setSize(to: viewportSize.width, for: .horizontal)
        case .horizontal:
            self.setSize(to: viewportSize.height, for: .vertical)
        }
    }
    
    public func updateInsets(minScrollOffset: CGFloat?, maxScrollOffset: CGFloat?) {
        let originalOffset = self.getOffset(for: scrollAxis)
        
        if let minScrollOffset {
            self.setStartInset(to: -minScrollOffset, for: scrollAxis)
        } else {
            self.setStartInset(to: unlimitedContentInset, for: scrollAxis)
        }
        
        if let maxScrollOffset {
            let size = self.getSize(for: scrollAxis)
            self.setEndInset(to: -(size - maxScrollOffset), for: scrollAxis)
        } else {
            self.setEndInset(to: 0, for: scrollAxis)
        }
        
        self.setOffset(to: originalOffset, for: scrollAxis)
    }
    
    public func updateOffset(_ offset: CGFloat) {
        let currentOffset = self.getOffset(for: scrollAxis)
        let minimumOffset = self.getMinOffset(for: scrollAxis)
        let maximumOffset = self.getMaxOffset(for: scrollAxis)
        let newOffset = max(minimumOffset, min(currentOffset + offset, maximumOffset))
        self.setOffset(to: newOffset, for: scrollAxis)
    }
    
    public func getSize(for scrollAxis: ACCalendarScrollDirection) -> CGFloat {
        switch scrollAxis {
        case .vertical:
            return contentSize.height
        case .horizontal:
            return contentSize.width
        }
    }
    
    public func setSize(to size: CGFloat, for scrollAxis: ACCalendarScrollDirection) {
        switch scrollAxis {
        case .vertical:
            contentSize.height = size
        case .horizontal:
            contentSize.width = size
        }
    }
    
    public func getOffset(for scrollAxis: ACCalendarScrollDirection) -> CGFloat {
        switch scrollAxis {
        case .vertical:
            return contentOffset.y
        case .horizontal:
            return contentOffset.x
        }
    }
    
    public func setOffset(to offset: CGFloat, for scrollAxis: ACCalendarScrollDirection) {
        switch scrollAxis {
        case .vertical:
            contentOffset.y = offset
        case .horizontal:
            contentOffset.x = offset
        }
    }
    
    public func getStartInset(for scrollAxis: ACCalendarScrollDirection) -> CGFloat {
        switch scrollAxis {
        case .vertical:
            return contentInset.top
        case .horizontal:
            return contentInset.left
        }
    }
    
    public func setStartInset(to inset: CGFloat, for scrollAxis: ACCalendarScrollDirection) {
        switch scrollAxis {
        case .vertical:
            contentInset.top = inset
        case .horizontal:
            contentInset.left = inset
        }
    }
    
    public func getEndInset(for scrollAxis: ACCalendarScrollDirection) -> CGFloat {
        switch scrollAxis {
        case .vertical:
            return contentInset.bottom
        case .horizontal:
            return contentInset.right
        }
    }
    
    public func setEndInset(to inset: CGFloat, for scrollAxis: ACCalendarScrollDirection) {
        switch scrollAxis {
        case .vertical:
            contentInset.bottom = inset
        case .horizontal:
            contentInset.right = inset
        }
    }
    
    public func getMinOffset(for scrollAxis: ACCalendarScrollDirection) -> CGFloat {
        switch scrollAxis {
        case .vertical:
            return -contentInset.top
        case .horizontal:
            return -contentInset.left
        }
    }
    
    public func getMaxOffset(for scrollAxis: ACCalendarScrollDirection) -> CGFloat {
        switch scrollAxis {
        case .vertical:
            return contentSize.height + contentInset.bottom - bounds.height
        case .horizontal:
            return contentSize.width + contentInset.right - bounds.width
        }
    }
}
