//
//  ACDynamicSizeLabel.swift
//  ACUICalendar
//

import UIKit

public protocol ContentSizeProvider: CalendarView {
    func getContentSize(for width: CGFloat) -> CGSize
}

public class ACDynamicSizeLabel: UILabel {
    
    private weak var provider: ContentSizeProvider?
    
    public init(provider: ContentSizeProvider) {
        self.provider = provider
        
        super.init(frame: .zero)
        
        numberOfLines = 0
        isUserInteractionEnabled = false
        isHidden = true
    }
    
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        guard let provider else {
            return .zero
        }
        
        if preferredMaxLayoutWidth == 0 {
            return super.intrinsicContentSize
        } else {
            return provider.getContentSize(for: preferredMaxLayoutWidth)
        }
    }
}
