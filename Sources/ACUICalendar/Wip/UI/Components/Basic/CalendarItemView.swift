//
//  CalendarItemView.swift
//  ACUICalendar
//

import UIKit

public class CalendarItemView: UIView {
    
    public let contentView: UIView
    
    public var selectionHandler: (() -> Void)?
    
    public var itemType: VisibleItem.ItemType?
    
    public var calendarItemModel: AnyCalendarItemModel {
        didSet {
            guard calendarItemModel._itemViewDifferentiator == oldValue._itemViewDifferentiator,
                  !calendarItemModel._isContentEqual(toContentOf: oldValue) else {
                return
            }
            
            updateContent()
        }
    }
    
    public init(initialCalendarItemModel: AnyCalendarItemModel) {
        calendarItemModel = initialCalendarItemModel
        contentView = calendarItemModel._createView()
        
        super.init(frame: .zero)
        
        contentView.insetsLayoutMarginsFromSafeArea = false
        addSubview(contentView)
        updateContent()
    }
    
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public class var layerClass: AnyClass {
        CATransformLayer.self
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if touches.first.map(isTouchInView(_:)) ?? false {
            selectionHandler?()
        }
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === self {
            return nil
        }
        
        return view
    }
    
    private func updateContent() {
        calendarItemModel._updateComponents(onViewOfSameType: contentView)
    }
    
    private func isTouchInView(_ touch: UITouch) -> Bool {
        contentView.bounds.contains(touch.location(in: contentView))
    }
}
